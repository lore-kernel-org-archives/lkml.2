Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2KLL22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:28:28 -0500
Received: from ns.iliad.fr ([212.27.33.1]:56130 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab2KLL21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:28:27 -0500
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Nov 2012 06:28:27 EST
Message-ID: <1352719094.10405.18.camel@sakura.staff.proxad.net>
Subject: Re: [RFC] MIPS: BCM63XX: add initial Device Tree support
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Jonas Gorski <jonas.gorski@gmail.com>
Cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        John Crispin <blogic@openwrt.org>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Nov 2012 12:18:14 +0100
In-Reply-To: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
Organization: Freebox
Content-Type: text/plain; charset="ANSI_X3.4-1968"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-11-11 at 13:50 +0100, Jonas Gorski wrote:

> This patch series adds initial Device Tree support to BCM63XX by adding
> bindings for interrupts, GPIOs and clocks to Device Tree. Finally it adds
> one "real" user, the serial driver, to the device tree boards.

>  51 files changed, 1993 insertions(+), 392 deletions(-)

I've already said what I think privately to you but I will do it again

The bcm63xx code base is IMO quite clean. It does not suffer from code
duplication, and god it would have taken far less time to write it the
"bad" way.

We have only *one* register file for all the SOCs, only the different
bits are visible.

We can even build a single kernel that support all SOCs/boards.

So what's the *point* of this ?

You *cannot* abstract hardware, you just can't guess now what the next
SOC peculiarity will be.

Quoting your patch "BCM63XX: switch to common clock and Device Tree"

+Required properties:
+- compatible: one of
+  a) "brcm,bcm63xx-clock"
+  Standard BCM63XX clock.

cool a nice abstraction, one register bit = one clock

+  b) "brcm,bcm63xx-sar-clock"
+  SAR/ATM clock, which requires a reset of the SAR/ATM block.
+  c) "brcm,bcm63xx-enetsw-clock"
+  Generic ethernet switch clock, which requires a reset of the block.
+  d) "brcm,bcm6368-enetsw-clock"
+  BCM6368 ethernet switch clock, which requires additional clocks to be
+  enabled during reset.

oops that abstraction did not fly because after enabling this particular
clock on this SOC you also need to toggle other bits.

that list is going to get longer and longer and at the end won't mean anything.

and this is supposed to be a *STABLE* API

We don't add syscall everyday, because we have to support them forever.
Why would it be ok to add such abstractions that prevent further code
refactoring because they are fixed in stone ?

-- 
Maxime



