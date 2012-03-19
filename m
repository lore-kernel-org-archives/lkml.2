Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab2CSUhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:37:20 -0400
Received: from mga07.intel.com ([143.182.124.22]:48897 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409Ab2CSUhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:37:17 -0400
From: William Douglas <william.douglas@intel.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH] Don't show error if Acer WMI is not found.
Date: Mon, 19 Mar 2012 13:39:21 -0700
Message-ID: <8762e0mikm.fsf@intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 486df5137ae34a4057d604e2b645d7b3848a562f Mon Sep 17 00:00:00 2001
From: William Douglas <william.douglas@intel.com>
Date: Mon, 28 Nov 2011 11:30:26 -0800
Subject: [PATCH] Don't show error if Acer WMI is not found.

This patch initiated by Pascal seemed to get left out when switching
to pr_<level>. I've updated the patch and am resubmitting it as it
reduces unnecessary boot noise.

Signed-off-by: William Douglas <william.douglas@intel.com>
Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
---
 drivers/platform/x86/acer-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index b848277..607af16 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1946,7 +1946,7 @@ static int __init acer_wmi_init(void)
 		AMW0_find_mailled();

 	if (!interface) {
-		pr_err("No or unsupported WMI interface, unable to load\n");
+		pr_info("No or unsupported WMI interface, unable to load\n");
 		return -ENODEV;
 	}

--
1.7.7.4

--
William Douglas, Intel Open Source Technology Center
