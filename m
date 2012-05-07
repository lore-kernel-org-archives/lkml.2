Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab2EGSg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:36:29 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:55003 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab2EGSg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 14:36:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120507175039.GA6423@phenom.dumpdata.com>
References: <20120507135238.GC361@phenom.dumpdata.com>
	<CAF1ivSZNH3R-U=d=yBW4m9PO8TQSbSP=dHR3okdsO7EkOm2RMQ@mail.gmail.com>
	<20120507175039.GA6423@phenom.dumpdata.com>
Date: Mon, 7 May 2012 20:36:26 +0200
X-Google-Sender-Auth: 1tnnmSeMsuQaB2k7qJP8A3kfV8k
Message-ID: <CAMuHMdWJAkS2_DuLdfZQA6ZQGAycrr5w5egfaeaQsMJsTVEWRQ@mail.gmail.com>
Subject: Re: Regression introduced by 6f381fa344911d5a234b13574433cf23036f9467
 [[SCSI] scsi_lib: use correct DMA device in __scsi_alloc_queue]
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Lin Ming <ming.m.lin@intel.com>, JBottomley@parallels.com,
        joerg@alea.gnuu.de, linux-kernel@vger.kernel.org,
        scsi <linux-scsi@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 7:50 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> > reverting above mentioned git commit fixes the issue.
>>
>> Does Jame's below patch help?
>>
>> http://www.spinics.net/lists/linux-scsi/msg59106.html
>
> Yes.  please add Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> on the latter part of that patch:

Same issue here with Atari NCR5380 SCSI on ARAnyM.
After the fix below, v3.4-rc6 boots, so

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

BTW, any git tree that has the original patch, so I don't have to commit the
HTML-mangled version from spinics to the m68k tree?

> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 351dc0b..a3a056a 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -218,6 +218,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>
>        if (!shost->shost_gendev.parent)
>                shost->shost_gendev.parent = dev ? dev : &platform_bus;
> +       if (!dma_dev)
> +               dma_dev = shost->shost_gendev.parent;
> +
>        shost->dma_dev = dma_dev;
>
>        error = device_add(&shost->shost_gendev);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
