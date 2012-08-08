Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab2HHGag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:30:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30493 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2HHGae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:30:34 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-28-502207882d3f
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: "'Tushar Behera'" <tushar.behera@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, patches@linaro.org
References: <1344333546-16995-1-git-send-email-tushar.behera@linaro.org>
 <098f01cd7488$0d66d630$28348290$%kim@samsung.com>
 <5020F568.5020204@linaro.org>
 <0a2d01cd7500$53e26c50$fba744f0$%kim@samsung.com>
 <20120808061102.GA22417@avionic-0098.mockup.avionic-design.de>
In-reply-to: <20120808061102.GA22417@avionic-0098.mockup.avionic-design.de>
Subject: RE: [PATCH] ARM: SAMSUNG: Fix compilation error with s3c2410_defconfig
Date: Wed, 08 Aug 2012 15:30:32 +0900
Message-id: <0abe01cd752f$4f96ad80$eec40880$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac11LKFfsSY3ETgFS7mLGJSihxj6gQAAVucg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQd0OdqUAg7XXRC0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKOTF7JXLCTr+Ly/xbmBsZN3F2MHBwSAiYSh65KdTFy
	ApliEhfurWfrYuTiEBKYzijxYCeM85dR4u35zSwgVWwCGhKH3z9jB7FFBMwllizaywxSxCww
	n1Fi170HUB0TmSSaf55nAVnBKeAt8f5TIogpLOAv8aizAKSXRUBVYtr0TlYQm1fAVuL6lYts
	ELagxI/J98B2MQtoSazfeZwJwpaX2LzmLTPE0eoSj/7qQpxgJHFzUhc7RImIxL4X7xgnMArN
	QjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4IB+Jr2DcVWDxSFG
	AQ5GJR7eTamKAUKsiWXFlbmHGCU4mJVEePccBArxpiRWVqUW5ccXleakFh9ilOZgURLnNfH+
	6i8kkJ5YkpqdmlqQWgSTZeLglGpgTErPr53b+iCAX8Hb7ulyo1yxhM9L46+6xrRKV4WYXXtc
	WjN7W7Mcw13pxEt/9nSHm8hbK6x24Pm01e3z94+Wx82Xxm24u6Ql+VmqjmE239l5O698n9p8
	TfmGxZQb4g5TnYS2B14usxDRTWRVvGy9aIaR5+tLFofY96uKWPmaSMin9b/LL5qrxFKckWio
	xVxUnAgAGK3JkWQCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry Reding wrote:
> 
> On Wed, Aug 08, 2012 at 09:54:13AM +0900, Kukjin Kim wrote:
> > diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-
> samsung/Kconfig
> > index 7aca31c..dcdfb77 100644
> > --- a/arch/arm/plat-samsung/Kconfig
> > +++ b/arch/arm/plat-samsung/Kconfig
> > @@ -403,7 +403,7 @@ config S5P_DEV_USB_EHCI
> >
> >  config S3C24XX_PWM
> >  	bool "PWM device support"
> > -	select HAVE_PWM
> > +	select PWM
> >  	help
> >  	  Support for exporting the PWM timer blocks via the pwm device
> >  	  system
> 
> You could add
> 
> 	select PWM_SAMSUNG
> 
Well, the 'PWM_SAMSUNG' depends on 'PWM', so I think, it'd better to select
PWM_SAMSUNG for building pwm-samsung.c automatically when PWM is selected.

> here to side-step the issue below.
> 
> > diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> > index 8fc3808..34c8ec1 100644
> > --- a/drivers/pwm/Kconfig
> > +++ b/drivers/pwm/Kconfig
> > @@ -59,7 +59,7 @@ config PWM_PXA
> >
> >  config PWM_SAMSUNG
> >  	tristate "Samsung pwm support"
> > -	depends on PLAT_SAMSUNG
> > +	def_bool PLAT_SAMSUNG
> 
> tristate and def_bool conflict, don't they? I think the easiest way to

Yeah, your pointing out is correct, but in this case, it should be 'bool'
not 'tristate' because the PWM driver cannot support module now.

> solve this problem would be to add a default line, like so:
> 
> 	default PLAT_SAMSUNG
> 
> I've checked this with a s3c2410_defconfig and this causes PWM_SAMSUNG
> to be selected =y, which I guess is what you want.
> 
How do you think following, just adding from original one?

-	tristate "Samsung pwm support"
+	bool "SAMSUNG PWM support"

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

