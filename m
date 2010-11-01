Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0KAW0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 18:26:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19941 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab0KAW0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 18:26:37 -0400
Date: Mon, 1 Nov 2010 15:26:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "werner" <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.37-rc1 problems
Message-Id: <20101101152624.f567dbe2.randy.dunlap@oracle.com>
In-Reply-To: <web-395637137@zbackend1.aha.ru>
References: <web-395637137@zbackend1.aha.ru>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Nov 2010 18:14:12 -0400 werner wrote:

> 2.6.37-rc1 probelms:
> 
> ===========================
> 
>    CC [M] 
>  drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.o
> drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c: 
> In function 'SetupHIFScatterSupport':
> drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:288: 
> error: 'struct mmc_host' has no member named 'max_hw_segs'
> drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:289: 
> error: 'struct mmc_host' has no member named 'max_hw_segs'

Already reported, Greg said that he would fix it up.

> make[3]: 
> [drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.o] 
> Error 1 (ignored)
>    LD [M]  drivers/staging/ath6kl/ath6kl.o
> ld: 
> drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.o: 
> No such file: No such file or directory

Comes from error above and using -i or -k (as I do).

> make[3]: [drivers/staging/ath6kl/ath6kl.o] Error 1 
> (ignored)
> 
> ============================
> 
>    CC [M]  drivers/staging/solo6x10/solo6010-core.o
>    CC [M]  drivers/staging/solo6x10/solo6010-i2c.o
>    CC [M]  drivers/staging/solo6x10/solo6010-p2m.o
>    CC [M]  drivers/staging/solo6x10/solo6010-v4l2.o
> drivers/staging/solo6x10/solo6010-v4l2.c: In function 
> 'solo_v4l2_open':
> drivers/staging/solo6x10/solo6010-v4l2.c:440: error: too 
> few arguments to function 'videobuf_queue_dma_contig_init'
> make[3]: [drivers/staging/solo6x10/solo6010-v4l2.o] Error 
> 1 (ignored)
>    CC [M]  drivers/staging/solo6x10/solo6010-tw28.o
>    CC [M]  drivers/staging/solo6x10/solo6010-gpio.o
>    CC [M]  drivers/staging/solo6x10/solo6010-disp.o
>    CC [M]  drivers/staging/solo6x10/solo6010-enc.o
>    CC [M]  drivers/staging/solo6x10/solo6010-v4l2-enc.o
> drivers/staging/solo6x10/solo6010-v4l2-enc.c: In function 
> 'solo_enc_open':
> drivers/staging/solo6x10/solo6010-v4l2-enc.c:769: error: 
> too few arguments to function 
> 'videobuf_queue_dma_contig_init'
> make[3]: [drivers/staging/solo6x10/solo6010-v4l2-enc.o] 
> Error 1 (ignored)
>    CC [M]  drivers/staging/solo6x10/solo6010-g723.o
>    LD [M]  drivers/staging/solo6x10/solo6x10.o
> ld: drivers/staging/solo6x10/solo6010-v4l2.o: No such 
> file: No such file or directory
> make[3]: [drivers/staging/solo6x10/solo6x10.o] Error 1 
> (ignored)
> 
> ===============================
> 
>    CC [M]  fs/logfs/compr.o
> In file included from fs/logfs/compr.c:8:

[snip huge list of messages]

Fixed by today's commit:

commit e99d11d19977c74b18411cdb59cdebb788237a6e
Author: Paul Mundt <lethal@linux-sh.org>
Date:   Tue Nov 2 05:29:21 2010 +0900
    fs: logfs: Fix up MTD=y build.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
