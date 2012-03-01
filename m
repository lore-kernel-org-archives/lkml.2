Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab2CAUDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:03:16 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15921 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab2CAUDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:03:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 01 Mar 2012 12:02:43 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Alan Ott <alan@signal11.us>, Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 1 Mar 2012 12:02:42 -0800
Subject: RE: [PATCH 5/8] ARM: tegra: work around tegra THUMB2_KERNEL bug
Thread-Topic: [PATCH 5/8] ARM: tegra: work around tegra THUMB2_KERNEL bug
Thread-Index: Acz34VoR388E2/ETRGil4izKt/+9mgABJsvw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BE861726@HQMAIL01.nvidia.com>
References: <1330630010-11241-1-git-send-email-alan@signal11.us>
 <1330630010-11241-6-git-send-email-alan@signal11.us>
In-Reply-To: <1330630010-11241-6-git-send-email-alan@signal11.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Ott wrote at Thursday, March 01, 2012 12:27 PM:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The tegra smp code cannot currently be built for t2, so
> disable that combination for now, as a workaround.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

At least in next-20120229 with the .config I'm using, everything appears
to compile fine. The link step does fail, but the error messages I get
don't appear to be Tegra specific:

xxx/kernel/sched/clock.c:334: relocation truncated to fit: R_ARM_THM_JUMP11 against symbol `sched_clock' defined in .text section in arch/arm/kernel/built-in.o
kernel/built-in.o: In function `post_relocation':
xxx/kernel/module.c:2860: relocation truncated to fit: R_ARM_THM_JUMP11 against symbol `module_finalize' defined in .text section in arch/arm/kernel/built-in.o
kernel/built-in.o: In function `show_interrupts':
xxx/kernel/irq/proc.c:431: relocation truncated to fit: R_ARM_THM_JUMP11 against symbol `arch_show_interrupts' defined in .text section in arch/arm/kernel/built-in.o
drivers/built-in.o: In function `pci_set_master':
xxx/drivers/pci/pci.c:2674: relocation truncated to fit: R_ARM_THM_JUMP11 against symbol `pcibios_set_master' defined in .text section in arch/arm/kernel/built-in.o

What failure does this solve, and how do I trigger it?

-- 
nvpublic

