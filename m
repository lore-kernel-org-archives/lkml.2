Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303Ab2BNTbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 14:31:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759855Ab2BNTbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:31:11 -0500
From: Bill Nottingham <notting@redhat.com>
To: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
Subject: [PATCH] Make 'Thermal Table has changed' a debug message.
Date: Tue, 14 Feb 2012 14:30:29 -0500
Message-Id: <1329247829-28099-1-git-send-email-notting@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the recommended action is "do nothing", we shouldn't be cluttering
the logs with it.

Signed-off-by: Bill Nottingham <notting@redhat.com>
---
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index ea0c607..a96983e 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3605,7 +3605,7 @@ static bool hotkey_notify_6xxx(const u32 hkey,
 
 	switch (hkey) {
 	case TP_HKEY_EV_THM_TABLE_CHANGED:
-		pr_info("EC reports that Thermal Table has changed\n");
+		pr_debug("EC reports that Thermal Table has changed\n");
 		/* recommended action: do nothing, we don't have
 		 * Lenovo ATM information */
 		return true;
-- 
1.7.7.6

