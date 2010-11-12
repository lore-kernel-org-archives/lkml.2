Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0KLISI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:18:08 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37000 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab0KLISH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:18:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=bEBDA46gfOfwPK4bScDWib48oUhzKX1pwndOSaxlF+7ZO67LFgqBttvp8GaFnVaXQb
         PYJ/1C2pdFXXX8LzouVW9GdfOe/0coZYBu9cuZBDnWVFoMVRk1jqoMGdQGOHLbyS8ZJ4
         2/5rlsmrN8UMydTaqYu79VdMRArXgZve01+kg=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux@arm.linux.org.uk
Cc: kgene.kim@samsung.com, kmpark@infradead.org, konkers@android.com,
        tony@atomide.com, adharmap@codeaurora.org, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org, srinidhikasagar@gmail.com,
        dwalker@codeaurora.org, santosh.shilimkar@ti.com, ccross@android.com,
        olof@lixom.net, Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 12 Nov 2010 17:20:59 +0900
Message-Id: <20101112082059.27221.52879.sendpatchset@t400s>
Subject: [PATCH 00/07] ARM: Common GIC entry macro code V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM: Common GIC entry macro code V3

[PATCH 01/07] ARM: Introduce asm/hardware/entry-macro-gic.S
[PATCH 02/07] ARM: Use shared GIC entry macros on CNS3XXX
[PATCH 03/07] ARM: Use shared GIC entry macros on Realview
[PATCH 04/07] ARM: Use shared GIC entry macros on Tegra
[PATCH 05/07] ARM: Use shared GIC entry macros on UX500
[PATCH 06/07] ARM: Use shared GIC entry macros on Vexpress
[PATCH 07/07] ARM: Use shared GIC entry macros on OMAP

Put GIC demux code in a common place to avoid duplicated code.

These patches are almost identical to 6284/1 in the RMKs
patch tracker. The main difference is that these ones require
each platform to specify base address using the macro
get_irqnr_preable. Both Tegra and OMAP are supported in V3.

The s5pv310 subarch is excluded due to the special "addne"
instruction in the get_irqnr_and_base macro.

The msm subarch is excluded as well since it treats PPIs
differently than other platforms and needs a different
version of the get_irqnr_and_base macro.

I intend to submit these patches to the RMK patch tracker
unless I hear any objections.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/include/asm/hardware/entry-macro-gic.S   |   68 +++++++++++++++
 arch/arm/mach-cns3xxx/include/mach/entry-macro.S  |   61 -------------
 arch/arm/mach-omap2/include/mach/entry-macro.S    |   92 +++++++--------------
 arch/arm/mach-realview/include/mach/entry-macro.S |   60 -------------
 arch/arm/mach-tegra/include/mach/entry-macro.S    |   64 --------------
 arch/arm/mach-ux500/include/mach/entry-macro.S    |   67 ---------------
 arch/arm/mach-vexpress/include/mach/entry-macro.S |   57 -------------
 7 files changed, 104 insertions(+), 365 deletions(-)

