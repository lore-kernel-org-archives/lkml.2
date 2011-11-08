Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab1KHUAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 15:00:18 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10838 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab1KHUAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 15:00:17 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="135833425"
Date: Tue, 8 Nov 2011 11:59:56 -0800
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Nicolas Pitre <nico@fluxnic.net>, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 2/2] msm: Support DEBUG_LL on MSM8660 and MSM8960
Message-ID: <20111108195956.GA13998@huya.qualcomm.com>
References: <1320777184-22446-1-git-send-email-sboyd@codeaurora.org>
 <1320777184-22446-3-git-send-email-sboyd@codeaurora.org>
 <alpine.LFD.2.02.1111081406220.3307@xanadu.home>
 <4EB97F83.3070509@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB97F83.3070509@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 11:14:11AM -0800, Stephen Boyd wrote:
> On 11/08/11 11:08, Nicolas Pitre wrote:
> > Independently from this patch, I was wondering about this code:
> >
> >> +	.macro	senduart, rd, rx
> >> +#ifdef CONFIG_MSM_HAS_DEBUG_UART_HS
> >> +	@ Write the 1 character to UARTDM_TF
> >> +	str	\rd, [\rx, #0x70]
> >> +#else
> >>  	teq	\rx, #0
> >>  	strne	\rd, [\rx, #0x0C]
> >> +#endif
> >>  	.endm
> > Why testing for zero in the #else part?  The upper level code should 
> > never call this macro with a null byte.
> 
> I was wondering the same thing, I don't know why that test for null is
> there. I will dust off the old 7201a (literally) and see what I can find
> out. It certainly looks unnecessary.

Perhaps this is a better fix?  Google removed the 7201a code from
their tree quite a while back.  I don't have any more working hardware
to test things with.

David

>From b4a76f1561d35d043f9266f8fe47725389ea7ba9 Mon Sep 17 00:00:00 2001
From: David Brown <davidb@codeaurora.org>
Date: Tue, 8 Nov 2011 11:44:05 -0800
Subject: [PATCH] ARM: msm: Mark 720x targets as broken

The 720x code is bitrotting.  These have only been compile tested for
quite some time.  Mark as broken now so they can be removed after a
while.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 000ddf0..0ce4b33 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -81,6 +81,7 @@ menu "Qualcomm MSM Board Type"
 config MACH_HALIBUT
 	depends on ARCH_MSM
 	depends on ARCH_MSM7X00A
+	depends on BROKEN
 	bool "Halibut Board (QCT SURF7201A)"
 	help
 	  Support for the Qualcomm SURF7201A eval board.
@@ -88,6 +89,7 @@ config MACH_HALIBUT
 config MACH_TROUT
 	depends on ARCH_MSM
 	depends on ARCH_MSM7X00A
+	depends on BROKEN
 	bool "HTC Dream (aka trout)"
 	help
 	  Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
