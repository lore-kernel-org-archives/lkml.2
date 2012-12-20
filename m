Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab2LTTur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:50:47 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27235 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751060Ab2LTTum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:50:42 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX182VWd0YBjpeaoIe+hBards
Date: Thu, 20 Dec 2012 11:50:34 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        maxime.ripard@free-electrons.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] ARM: OMAP2+: Trivial fix for IOMMU merge issue (Re: [GIT
 PULL v2] ARM: arm-soc fixes for 3.8)
Message-ID: <20121220195033.GI21056@atomide.com>
References: <20121220163814.GA29557@quad.lixom.net>
 <20121220175639.GA14363@n2100.arm.linux.org.uk>
 <CAOesGMgxXmXUW2RP_5AxJ6Z5sRBhFJ2CQz4S12MwXAb3=ibYOA@mail.gmail.com>
 <20121220184525.GC21056@atomide.com>
 <CA+55aFyiRPk0Qta35PBqMFqn+GkKaugqKJM3WHCT0JEJ1YohWw@mail.gmail.com>
 <20121220190847.GF21056@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121220190847.GF21056@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 787314c3 (Merge tag 'iommu-updates-v3.8' of
git://git./linux/kernel/git/joro/iommu) did not account
for the changed header location.

The headers were made local to mach-omap2 as they
are specific to omap2+ only, and we wanted to get
most of the #include <plat/*.h> headers fixed up
anyways for the ARM multiplatform support.

We attempted to avoid this kind of merge conflict
early on by setting up a minimal git branch shared by
the arm-soc tree and the iommu tree, but looks like
we still hit a merge issue there as the branches got
merged as various topic branches.

Cc: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>

---

Found one more merge issue with the recent IOMMU merge.

Linus, maybe apply this fix directly as Olof's branch
is based on an earlier commit?

--- a/arch/arm/mach-omap2/omap-iommu.c
+++ b/arch/arm/mach-omap2/omap-iommu.c
@@ -16,8 +16,8 @@
 #include <linux/slab.h>
 
 #include <linux/platform_data/iommu-omap.h>
-#include <plat/omap_hwmod.h>
-#include <plat/omap_device.h>
+#include "omap_hwmod.h"
+#include "omap_device.h"
 
 static int __init omap_iommu_dev_init(struct omap_hwmod *oh, void *unused)
 {
