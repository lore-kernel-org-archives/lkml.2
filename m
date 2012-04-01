Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab2DAUjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:39:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:54142 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2DAUjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:39:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: dhowells@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 09/11] firewire: restore the device.h include in linux/firewire.h
Date: Sun,  1 Apr 2012 16:38:45 -0400
Message-Id: <1333312727-11428-10-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 313162d0b83836e2f57e51b9b8650fb4b9c396ea

    "device.h: audit and cleanup users in main include dir"

exchanged an include <linux/device.h> for a struct *device
but in actuality I misread this file when creating 313162d
and it should have remained an include.

There were no build regressions since all consumers were
already getting device.h anyway, but make it right regardless.

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/firewire.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index 4db7b68..cdc9b71 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -2,6 +2,7 @@
 #define _LINUX_FIREWIRE_H
 
 #include <linux/completion.h>
+#include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
@@ -64,8 +65,6 @@
 #define CSR_MODEL		0x17
 #define CSR_DIRECTORY_ID	0x20
 
-struct device;
-
 struct fw_csr_iterator {
 	const u32 *p;
 	const u32 *end;
-- 
1.7.9.1

