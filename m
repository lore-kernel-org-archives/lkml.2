Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042Ab1KHFAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 00:00:37 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15455 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1KHFAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 00:00:32 -0500
X-AuditID: cbfee61b-b7b7fae000005864-78-4eb8b76f5fb7
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Alan Cox'" <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1320426984-17525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CAJuYYwQakbLqM46gVexB4Evby-aHA11hAx4N4Nw4mdYXp_yEOQ@mail.gmail.com>
In-reply-to: <CAJuYYwQakbLqM46gVexB4Evby-aHA11hAx4N4Nw4mdYXp_yEOQ@mail.gmail.com>
Subject: RE: [PATCH] serial: samsung: Fix build for non-Exynos4210 devices
Date: Tue, 08 Nov 2011 14:00:31 +0900
Message-id: <04ea01cc9dd3$5725b110$05711330$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcycnxCm5dnRW3r3SEuvexsljveI9QBGO2jA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Abraham wrote:
> 
> Hi Mark,
> 
> On 4 November 2011 22:46, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > exynos4120_serial_drv_data is only defined when building with support
> > for Exynos4210 so use the already provided define to ensure that we
> > don't reference it when building for other SoCs.
> >
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> I missed that one. Thanks for the fix.
> 
> The Samsung device tree patches will not be merged in v3.2 merge
> window. So should this fix be merged into the uart dt support patch or
> should this be a separate patch?
> 

Hi all,

Okay, I will pick this up on 'next-samung-dt' tree which will be sent to
upstream in next time.

As a note, I need to sort out the tree based on v3.2-rc1 then will apply
this.

If any problems, please let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
> 
> > ---
> >  drivers/tty/serial/samsung.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> > index efe3756..7272eee 100644
> > --- a/drivers/tty/serial/samsung.c
> > +++ b/drivers/tty/serial/samsung.c
> > @@ -1649,7 +1649,7 @@ MODULE_DEVICE_TABLE(platform,
> s3c24xx_serial_driver_ids);
> >  #ifdef CONFIG_OF
> >  static const struct of_device_id s3c24xx_uart_dt_match[] = {
> >        { .compatible = "samsung,exynos4210-uart",
> > -               .data = &exynos4210_serial_drv_data },
> > +               .data = EXYNOS4210_SERIAL_DRV_DATA },
> >        {},
> >  };
> >  MODULE_DEVICE_TABLE(of, s3c24xx_uart_dt_match);
> > --
> > 1.7.7.1
> >
> >

