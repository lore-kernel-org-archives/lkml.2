Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1G0VwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:52:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:51521 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab1G0Vtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32274977"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: hpa@zytor.com, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [99/99] x86: Make Dell Latitude E6420 use reboot=pci
Message-Id: <20110727214939.178132403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: H. Peter Anvin <hpa@zytor.com>

[ upstream commit a536877e77f73ea22d12d94a019fedd9671b6acd ]

Yet another variant of the Dell Latitude series which requires
reboot=pci.

>From the E5420 bug report by Daniel J Blueman:

> The E6420 is affected also (same platform, different casing and
> features), which provides an external confirmation of the issue; I can
> submit a patch for that later or include it if you prefer:
> http://linux.koolsolutions.com/2009/08/04/howto-fix-linux-hangfreeze-during-reboots-and-restarts/

Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/arch/x86/kernel/reboot.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/reboot.c
+++ linux-2.6.35.y/arch/x86/kernel/reboot.c
@@ -485,6 +485,14 @@ static struct dmi_system_id __initdata p
 			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5420"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Latitude E6420. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E6420",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
+		},
+	},
 	{ }
 };
 
