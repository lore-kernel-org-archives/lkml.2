Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab0FQBRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:17:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35431 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab0FQBRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qfgH4/9QKV9lP86xryM25HZFALHqMSmG8MyeFQ6tNGsGRYVmyQgtz1SH0oTC8ivjRo
         ElcNHx1E+4YEragUP4v4HHwio+rCuUN7CvSc8A9+JuBx87V47vgi0x5WLs+1sGGrKReh
         Ansu9bNIeyKjMkUpsfx2TWBJamT/YBRxjKkDo=
MIME-Version: 1.0
In-Reply-To: <1276737229.2847.853.camel@mulgrave.site>
References: <1276737229.2847.853.camel@mulgrave.site>
Date: Wed, 16 Jun 2010 21:17:15 -0400
X-Google-Sender-Auth: C0EfAic8RjDTBL7BtHwAYIZBN5o
Message-ID: <AANLkTilSfOwwT87mgDcWBogL4gPnM7VBTOALKpZv_upN@mail.gmail.com>
Subject: Re: bnx2 fails to compile on parisc because of missing get_dma_ops()
From: Mike Frysinger <vapier@gentoo.org>
To: James Bottomley <JBottomley@novell.com>
Cc: netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Michael Chan <mchan@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 9:13 PM, James Bottomley wrote:
> I'm not quite sure whose fault this one is.
>
> However, this code in bnx2.c:
>
>                if (!get_dma_ops(&pdev->dev)->sync_single_for_cpu) {
>                        next_rx_buf =
>                                &rxr->rx_buf_ring[
>                                        RX_RING_IDX(NEXT_RX_BD(sw_cons))];
>                        prefetch(next_rx_buf->desc);
>                }
>
> Looks remarkably fragile: what exactly is it trying to do?
>
> The commit that causes the problem:
>
> commit a33fa66bcf365ffe5b79d1ae1d3582cc261ae56e
> Author: Michael Chan <mchan@broadcom.com>
> Date:   Thu May 6 08:58:13 2010 +0000
>
>    bnx2: Add prefetches to rx path.
>
> Looks fairly innocuous by the description.
>
> Should parisc have a get_dma_ops()?  We don't need one because our dma
> ops are per platform not per bus.

looks like it'll be broken on more than just parisc:
$ grep get_dma_ops arch/*/include/asm/ -rl | cut -d/ -f 2
alpha
ia64
microblaze
powerpc
sh
sparc
x86
-mike
