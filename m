Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1K1UAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:00:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47161 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab1K1UAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:00:36 -0500
From: William Douglas <william.r.douglas@gmail.com>
To: linux-kernel@vger.kernel.org, pascal@unilogicnetworks.net, jlee@novell.com,
        joe@perches.com
Subject: [PATCH] Don't show error if Acer WMI is not found
Date: Mon, 28 Nov 2011 12:00:31 -0800
Message-ID: <8762i4dnkw.fsf@intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
