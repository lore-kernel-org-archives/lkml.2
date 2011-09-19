Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab1ISWaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:30:39 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29156 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1ISWai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:30:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6474"; a="119915351"
Message-ID: <4E77BE34.6070702@codeaurora.org>
Date: Mon, 19 Sep 2011 15:12:04 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] ARM: debug: Add CLSP711X_UART1 config choice
References: <20110916114140.GA31334@e102144-lin.cambridge.arm.com> <1316455300-5752-1-git-send-email-sboyd@codeaurora.org> <20110919212502.GB23613@e102144-lin.cambridge.arm.com>
In-Reply-To: <20110919212502.GB23613@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/11 14:25, Will Deacon wrote:
> Hi Stephen,
>
> On Mon, Sep 19, 2011 at 07:01:39PM +0100, Stephen Boyd wrote:
>> ARM patch 7072/1 (debug: use kconfig choice for selecting
>> DEBUG_LL UART) only allowed CLSP711X_UART2 to be selected because
>> there is no NONE option in a choice menu. Add a UART1 choice so
>> that users can still choose UART1 explicitly.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>
>> On 09/16/11 04:41, Will Deacon wrote:
>>> Ah yes. This will need to be added as part of the platform updates to go via
>>> Arnd. It should be easy enough just to have a DEBUG_CLPS711X_UART1 option,
>>> for example, and the platform code will fall back to the first UART.
>> I couldn't find these patches applied in Arnd's tree so I based it off of
>> Russell's for-next branch.
> Thanks for cooking the patch, it was somewhere on my list of things to do
> this week! I think we also need to fix the DEBUG_DC21285_PORT option as that
> has a similar `if not selected then use a different UART' behaviour. It can be
> fixed in the same way as you have done in this patch.'

Ah my eyes glossed over the DC21285 one. Here's one on top of patch 2.
Feel free to squash, etc.


diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 9661c51..b976e04 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -93,14 +93,19 @@ choice
                  It does include a timeout to ensure that the system does not
                  totally freeze when there is nothing connected to read.
 
+       config DEBUG_DC21285_PORT1
+               bool "Kernel low-level debugging messages via footbridge serial port 1"
+               depends on FOOTBRIDGE
+               help
+                 Say Y here if you want the debug print routines to direct
+                 their output to the first serial port in the DC21285.
+
        config DEBUG_DC21285_PORT
-               bool "Kernel low-level debugging messages via footbridge serial port"
+               bool "Kernel low-level debugging messages via footbridge serial port 2"
                depends on FOOTBRIDGE
                help
                  Say Y here if you want the debug print routines to direct
-                 their output to the serial port in the DC21285 (Footbridge).
-                 Saying N will cause the debug messages to appear on the first
-                 16550 serial port.
+                 their output to the second serial port in the DC21285.
 
        config DEBUG_CLPS711X_UART1
                bool "Kernel low-level debugging messages via UART1"



>
> Would you like me to take the three patches in with the ones I currently
> have for other platforms (Realview, Samsung, imx) or would you prefer to
> handle these separately? I was planning to send all of the platform bits to
> Arnd once I've got my branches sorted out (been on holiday for the past two
> weeks).
>

If you want to handle them that sounds fine. I can't figure out who is
coordinating the DEBUG_LL changes. It seems that Russell has at least
applied the initial DEBUG_LL patches, so his tree will have some
breakage without this fixup patch.

I have some more patches on top of this one for MSM DEBUG_LL support
too. Hopefully I can send them out in a little bit.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

