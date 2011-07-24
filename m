Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab1GXVeh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 17:34:37 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58197 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab1GXVef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 17:34:35 -0400
MIME-Version: 1.0
Date: Sun, 24 Jul 2011 17:34:34 -0400
Message-ID: <CACqU3MU=HKcFdC_B3x-APeJE_8SMLifmSUG22SrUw2GE-HHaSg@mail.gmail.com>
Subject: Re: linux-next: Tree for July 22 (arm-davinci Kconfig warnings)
From: Arnaud Lacombe <lacombar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The arm-davinci tree has 2 Kconfig warning, but also present in v3.0:

arch/arm/mach-davinci/Kconfig:195:warning: config symbol defined without type
arch/arm/mach-davinci/Kconfig:198:warning: config symbol defined without type

This concerns GPIO_PCA953X and KEYBOARD_GPIO_POLLED. In both case,
symbols are re-defined later on in `drivers/gpio/Kconfig' respectively
in `arch/arm/mach-davinci/Kconfig' and
`drivers/input/keyboard/Kconfig'.

Is there any reason not to select those from MACH_DAVINCI_DA850_EVM
definition, ala:

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index c0deaca..cec22e2 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -163,6 +163,8 @@ config MACH_DAVINCI_DA850_EVM
        bool "TI DA850/OMAP-L138/AM18x Reference Platform"
        default ARCH_DAVINCI_DA850
        depends on ARCH_DAVINCI_DA850
+       select GPIO_PCA953X
+       select KEYBOARD_GPIO_POLLED
        help
          Say Y here to select the TI DA850/OMAP-L138/AM18x Evaluation Module.

@@ -192,12 +194,6 @@ config DA850_UI_RMII

 endchoice

-config GPIO_PCA953X
-       default MACH_DAVINCI_DA850_EVM
-
-config KEYBOARD_GPIO_POLLED
-       default MACH_DAVINCI_DA850_EVM
-
 config MACH_TNETV107X
        bool "TI TNETV107X Reference Platform"
        default ARCH_DAVINCI_TNETV107X

Thanks,
 - Arnaud

On Fri, Jul 22, 2011 at 2:42 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
> [...]
