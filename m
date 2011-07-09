Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1GIVky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 17:40:54 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:42829 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754874Ab1GIVkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 17:40:52 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: dilinger@queued.net
Cc: linux-acpi@vger.kernel.org
Subject: [PATCH] x86, olpc-xo15-sci: enable EC wakeup capability
Message-Id: <20110709211603.996869D401C@zog.reactivated.net>
Date: Sat,  9 Jul 2011 22:16:03 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=_-Kf4x3jdLYA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=aj1OkgN8WNMVO4dtLEQA:9 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some recent changes to the way that ACPI handles wakeup flags means
that the XO15EC ACPI device is not wakeup-capable by default so
device_set_wakeup_enable() does nothing.

Use device_init_wakeup() to mark the device as wakeup capable, and to
enable wakeups.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/platform/olpc/olpc-xo15-sci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo15-sci.c b/arch/x86/platform/olpc/olpc-xo15-sci.c
index a5990eb..2b235b7 100644
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -120,7 +120,7 @@ static int xo15_sci_add(struct acpi_device *device)
 
 	/* Enable wake-on-EC */
 	if (device->wakeup.flags.valid)
-		device_set_wakeup_enable(&device->dev, true);
+		device_init_wakeup(&device->dev, true);
 
 	return 0;
 }
-- 
1.7.5.4

