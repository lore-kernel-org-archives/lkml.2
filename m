Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab2HHKZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 06:25:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37009 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2HHKZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 06:25:19 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-e6-50223e8d9863
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: "'Tushar Behera'" <tushar.behera@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, patches@linaro.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1344333546-16995-1-git-send-email-tushar.behera@linaro.org>
 <098f01cd7488$0d66d630$28348290$%kim@samsung.com>
 <5020F568.5020204@linaro.org>
 <0a2d01cd7500$53e26c50$fba744f0$%kim@samsung.com>
 <20120808061102.GA22417@avionic-0098.mockup.avionic-design.de>
 <0abe01cd752f$4f96ad80$eec40880$%kim@samsung.com>
 <20120808065046.GA30832@avionic-0098.mockup.avionic-design.de>
In-reply-to: <20120808065046.GA30832@avionic-0098.mockup.avionic-design.de>
Subject: RE: [PATCH] ARM: SAMSUNG: Fix compilation error with s3c2410_defconfig
Date: Wed, 08 Aug 2012 19:25:17 +0900
Message-id: <0af001cd7550$1af66040$50e320c0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac11MiaZdi3s362VSqSYklyLRdwjMAAG9irA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jAd1eO6UAg9bdyhaXd81hs5hxfh+T
	A5PH501yAYxRXDYpqTmZZalF+nYJXBl7dj9gKlgkWtHT+5+lgfGgQBcjJ4eEgInEpINrWCBs
	MYkL99azdTFycQgJLGKUuHn+GjtIQkjgL6PE6lcqIDabgIbE4ffPwOIiAuYSSxbtZQZpYBY4
	zChxY+oUJoiGNmaJT58VQWxOAW+Jp9cWATVwcAgL+Es86iwACbMIqEr8b9nLBBLmFbCVeD3d
	BiTMKyAo8WPyPbB7mAW0JNbvPM4EYctLbF7zlhmkXEJAXeLRX12IC4wkNm6cwAxRIiKx78U7
	xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4nJ9J72Bc
	1WBxiFGAg1GJh3dTqmKAEGtiWXFl7iFGCQ5mJRHePQeBQrwpiZVVqUX58UWlOanFhxilOViU
	xHlNvL/6CwmkJ5akZqemFqQWwWSZODilGhijqnRFGk7tMMvvrTxzdB/DpbWe7sWs8SUcDixM
	uvrbQ2xCnosFnPIrUO/efszNRO/mi4Jn3jO/utU3dxddSY3ZtsTMwTjG4KMD21yGr2tmBGzu
	f8Kdzbt5wtPNcls3hPMV2h8JLz7W9IV1+vzqsz85bRzn8dQlPVzH3Ls538RmZmE2v4nQayWW
	4oxEQy3mouJEAFYyYXZjAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry Reding wrote:
> 
> On Wed, Aug 08, 2012 at 03:30:32PM +0900, Kukjin Kim wrote:

[...]

> > Yeah, your pointing out is correct, but in this case, it should be
> 'bool'
> > not 'tristate' because the PWM driver cannot support module now.
> 
> Is there any reason why that is so?

I mean, current pwm-samsung.c does not support module, as you know, the
pwm_init() of pwm-samsung is called by arch_initcall().

> Looking at the driver it seems like
> it should be easy to turn it into a module.

Yeah, I know :)

> I know that Jingoo (Cc'ed)
> has been working on the driver and I've asked him the same question
> already.
> 
I didn't know, would be helpful to me if you could add me in Cc for
discussion of pwm-samsung. And he is my team member, so I will talk to him
about the plan.

> Anyway I don't want to force the issue, I just think you should consider
> it.
> 
Thanks.

> > > solve this problem would be to add a default line, like so:
> > >
> > > 	default PLAT_SAMSUNG
> > >
> > > I've checked this with a s3c2410_defconfig and this causes PWM_SAMSUNG
> > > to be selected =y, which I guess is what you want.
> > >
> > How do you think following, just adding from original one?
> >
> > -	tristate "Samsung pwm support"
> > +	bool "SAMSUNG PWM support"
> >
> > Thanks.
> 
> If you convert this to bool anyway, then maybe you can still use
> def_bool:
> 
> 	config PWM_SAMSUNG
> 		prompt "SAMSUNG PWM support" if PLAT_SAMSUNG
> 		def_bool PLAT_SAMSUNG
> 
> Any particular reason why you want "SAMSUNG" capitalized?
> 
No, there is no reason, just because...

So, how about following? If PWM is selected on Samsung SoCs, the PWM_SAMSUNG
will be selected automatically. Of course, it can be de-selected in kernel
menuconfig. Note that, I think, using 'bool <expr>' and 'depends on <expr>'
is more clear than 'prompt <prompt> ["if" <expr>]'. However if any your
preference here, please kindly let me know.

---
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 8fc3808..c74d055 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -58,14 +58,12 @@ config PWM_PXA
 	will be called pwm-pxa.

 config PWM_SAMSUNG
-	tristate "Samsung pwm support"
+	bool "Samsung PWM support"
 	depends on PLAT_SAMSUNG
+	default y
 	help
 	  Generic PWM framework driver for Samsung.
 
-	  To compile this driver as a module, choose M here: the module
-	  will be called pwm-samsung.
-
 config PWM_TEGRA
 	tristate "NVIDIA Tegra PWM support"
 	depends on ARCH_TEGRA
---

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

