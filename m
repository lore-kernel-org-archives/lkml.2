Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab1JGN1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 09:27:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43788 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1JGN1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 09:27:20 -0400
MIME-Version: 1.0
In-Reply-To: <20111007115047.GC24534@sirena.org.uk>
References: <20110929125035.GA2085@sirena.org.uk>
	<20111007115047.GC24534@sirena.org.uk>
Date: Fri, 7 Oct 2011 18:57:19 +0530
Message-ID: <CAJuYYwTeAwZ-zRDyQwB73bHWn+NkoT2zxmuJkFW6Oph1CUijqA@mail.gmail.com>
Subject: Re: Long stalls during boot with -next
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 7 October 2011 17:20, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Sep 29, 2011 at 01:50:36PM +0100, Mark Brown wrote:
>> Since Tuesday I've been experiencing stalls on boot with -next kernels.
>> The boot appears to proceed normally but there appears to be a good ten
>> second delay somewhere around the late_initcall() stage with no
>> indication in the logs:
>
> I identified the problem here, the behaviour of LL_DEBUG was changed to
> make it select DEBUG_ICEDCC by default which is unfortunate if one
> doesn't have an EmbeddedICE connected.

Thanks for your suggestion. The long stall during boot problem occurs
on Samsung boards as well with linux-next. As per your suggestion, the
following diff fixes this issue.

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 65cf8c6..035f5cd 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -120,6 +120,15 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to the second serial port on these devices.

+	config DEBUG_SAMSUNG_UART
+		bool "Kernel low-level debugging messages via samsung serial port"
+		depends on PLAT_SAMSUNG
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to the serial port for Samsung platforms. Choose
+		  the uart port with the "S3C UART to use for low-level debug"
+		  config option.
+
 endchoice

 config EARLY_PRINTK
@@ -139,7 +148,7 @@ config OC_ETM
 	  kernel code.

 config DEBUG_S3C_UART
-	depends on PLAT_SAMSUNG
+	depends on DEBUG_SAMSUNG_UART
 	int "S3C UART to use for low-level debug"
 	default "0"
 	help


Thanks,
Thomas.
