Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab2DIVtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:49:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab2DIVtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:49:40 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mjg@redhat.com
Subject: [PATCH] intel_ips: Hush the i915 symbols message
Date: Mon,  9 Apr 2012 17:49:36 -0400
Message-Id: <1334008176-1142-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't control order here, and getting it inverted is harmless.  So
turn this down to dev_info() and leave a note about how to fix it in
case userspace is insufficiently automagic.

Bugzilla: https://bugzilla.redhat.com/794953
Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/platform/x86/intel_ips.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index f7ba316..0ffdb3c 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -1565,7 +1565,7 @@ static int ips_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		ips->poll_turbo_status = true;
 
 	if (!ips_get_i915_syms(ips)) {
-		dev_err(&dev->dev, "failed to get i915 symbols, graphics turbo disabled\n");
+		dev_info(&dev->dev, "failed to get i915 symbols, graphics turbo disabled until i915 loads\n");
 		ips->gpu_turbo_enabled = false;
 	} else {
 		dev_dbg(&dev->dev, "graphics turbo enabled\n");
-- 
1.7.7.6

