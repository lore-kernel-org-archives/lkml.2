Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab2KDNUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:20:05 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59777 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2KDNUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 08:20:02 -0500
MIME-Version: 1.0
In-Reply-To: <1348553352-14334-2-git-send-email-dhobsong@igel.co.jp>
References: <1348553352-14334-1-git-send-email-dhobsong@igel.co.jp>
	<1348553352-14334-2-git-send-email-dhobsong@igel.co.jp>
Date: Sun, 4 Nov 2012 14:20:00 +0100
X-Google-Sender-Auth: 1_pVaqjf_UwAKCd5umZS9tUl3IM
Message-ID: <CAMuHMdWKByLXR-2wkiej=F1WPf7xePf3nMkUqwSf_hEJNNZbvg@mail.gmail.com>
Subject: Re: [v2 PATCH 1/2] Add new uio device for dynamic memory allocation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Damian Hobson-Garcia <dhobsong@igel.co.jp>
Cc: hjk@hansjkoch.de, gregkh@linuxfoundation.org, magnus.damm@gmail.com,
        horms@verge.net.au, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, hdk@igel.co.jp,
        Linux-Next <linux-next@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 8:09 AM, Damian Hobson-Garcia
<dhobsong@igel.co.jp> wrote:
> are holding the device file open, the address returned to userspace is
> DMA_ERROR_CODE.

Only a small subset of the architectures
(arm/ia64/microblaze/openrisc/powerpc/sparc/x86)
seem to define DMA_ERROR_CODE, causing everywhere else:

drivers/uio/uio_dmem_genirq.c: In function ‘uio_dmem_genirq_release’:
drivers/uio/uio_dmem_genirq.c:95: error: ‘DMA_ERROR_CODE’ undeclared
(first use in this function)
drivers/uio/uio_dmem_genirq.c:95: error: (Each undeclared identifier
is reported only once
drivers/uio/uio_dmem_genirq.c:95: error: for each function it appears in.)
drivers/uio/uio_dmem_genirq.c: In function ‘uio_dmem_genirq_probe’:
drivers/uio/uio_dmem_genirq.c:238: error: ‘DMA_ERROR_CODE’ undeclared
(first use in this function)
make[1]: *** [drivers/uio/uio_dmem_genirq.o] Error 1
make: *** [drivers/uio/] Error 2

(e.g. http://kisskb.ellerman.id.au/kisskb/buildresult/7462173/)

Furthermore, none of them define it in <uapi/...>, so DMA_ERROR_CODE is not
part of the userspace API (yet), while it is architecture-specific (some use 0,
others ~0).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
