Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1ISWzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:55:12 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43490 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1ISWzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:55:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6474"; a="119756704"
Message-ID: <4E77C84E.9040202@codeaurora.org>
Date: Mon, 19 Sep 2011 15:55:10 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: debug: Add CLSP711X_UART1 config choice
References: <20110916114140.GA31334@e102144-lin.cambridge.arm.com> <1316455300-5752-1-git-send-email-sboyd@codeaurora.org> <20110919212502.GB23613@e102144-lin.cambridge.arm.com> <4E77BE34.6070702@codeaurora.org> <20110919224151.GB28237@n2100.arm.linux.org.uk>
In-Reply-To: <20110919224151.GB28237@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/11 15:41, Russell King - ARM Linux wrote:
> On Mon, Sep 19, 2011 at 03:12:04PM -0700, Stephen Boyd wrote:
>> On 09/19/11 14:25, Will Deacon wrote:
>>> Thanks for cooking the patch, it was somewhere on my list of things to do
>>> this week! I think we also need to fix the DEBUG_DC21285_PORT option as that
>>> has a similar `if not selected then use a different UART' behaviour. It can be
>>> fixed in the same way as you have done in this patch.'
>> Ah my eyes glossed over the DC21285 one. Here's one on top of patch 2.
>> Feel free to squash, etc.
> Err, the DC21285 only has one serial port.
>
> Some footbridge platforms expose the DC21285 to the outside world, others
> don't.  Some footbridge platforms have a separate 8250 UART at the standard
> PCI COM1 address, others don't.
>
> What DEBUG_DC21285_PORT is selecting between is whether to use the DC21285
> port (when set) or the 8250 at PCI COM1 (when unset).

Ah ok. How about this instead?

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 9661c51..31896f4 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -93,14 +93,19 @@ choice
                  It does include a timeout to ensure that the system does not
                  totally freeze when there is nothing connected to read.
 
+       config DEBUG_FOOTBRIDGE_COM1
+               bool "Kernel low-level debugging messages via footbridge 8250 at PCI COM1"
+               depends on FOOTBRIDGE
+               help
+                 Say Y here if you want the debug print routines to direct
+                 their output to the 8250 at PCI COM1.
+
        config DEBUG_DC21285_PORT
                bool "Kernel low-level debugging messages via footbridge serial port"
                depends on FOOTBRIDGE
                help
                  Say Y here if you want the debug print routines to direct
                  their output to the serial port in the DC21285 (Footbridge).
-                 Saying N will cause the debug messages to appear on the first
-                 16550 serial port.
 
        config DEBUG_CLPS711X_UART1
                bool "Kernel low-level debugging messages via UART1"



-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

