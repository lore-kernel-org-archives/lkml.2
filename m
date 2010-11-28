Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab0K1VyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:54:25 -0500
Received: from liberdade2.minaslivre.org ([74.50.53.203]:39536 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab0K1VyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:54:23 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Nov 2010 16:54:22 EST
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, carlos@strangeworlds.co.uk,
        stable@kernel.org, ceolin@ulevel.com,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] wmi: use memcmp instead of strncmp to compare GUIDs
Date: Sun, 28 Nov 2010 19:46:50 -0200
Message-Id: <1290980810-5903-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking for the duplicates in /sys/class/wmi/, I couldn't find
them. The code that looks for duplicates uses strncmp in a binary GUID,
which may contain zero bytes. The right function is memcmp, which is
also used in another section of wmi code.

It was finding 49142400-C6A3-40FA-BADB-8A2652834100 as a duplicate of
39142400-C6A3-40FA-BADB-8A2652834100. Since the first byte is the fourth
printed, they were found as equal by strncmp.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/platform/x86/wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 104b77c..aecd9a9 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -755,7 +755,7 @@ static bool guid_already_parsed(const char *guid_string)
 	struct wmi_block *wblock;
 
 	list_for_each_entry(wblock, &wmi_block_list, list)
-		if (strncmp(wblock->gblock.guid, guid_string, 16) == 0)
+		if (memcmp(wblock->gblock.guid, guid_string, 16) == 0)
 			return true;
 
 	return false;
-- 
1.7.2.3

