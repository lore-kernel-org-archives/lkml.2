Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab0LLXyD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:54:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36780 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab0LLXsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:24 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: cascardo@holoscopio.com, mjg@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [196/223] wmi: use memcmp instead of strncmp to compare GUIDs
Message-Id: <20101212234822.84B04B27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

commit 8b14d7b22c61f17ccb869e0047d9df6dd9f50a9f upstream.

While looking for the duplicates in /sys/class/wmi/, I couldn't find
them. The code that looks for duplicates uses strncmp in a binary GUID,
which may contain zero bytes. The right function is memcmp, which is
also used in another section of wmi code.

It was finding 49142400-C6A3-40FA-BADB-8A2652834100 as a duplicate of
39142400-C6A3-40FA-BADB-8A2652834100. Since the first byte is the fourth
printed, they were found as equal by strncmp.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/platform/x86/wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/platform/x86/wmi.c
===================================================================
--- linux.orig/drivers/platform/x86/wmi.c
+++ linux/drivers/platform/x86/wmi.c
@@ -795,7 +795,7 @@ static bool guid_already_parsed(const ch
 		wblock = list_entry(p, struct wmi_block, list);
 		gblock = &wblock->gblock;
 
-		if (strncmp(gblock->guid, guid_string, 16) == 0)
+		if (memcmp(gblock->guid, guid_string, 16) == 0)
 			return true;
 	}
 	return false;
