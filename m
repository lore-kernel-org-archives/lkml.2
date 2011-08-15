Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab1HOXjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:39:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59001 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab1HOXjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:39:31 -0400
From: jeffbrown@android.com
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, rydberg@euromail.se,
        Jeff Brown <jeffbrown@android.com>
Subject: [PATCH] hid-debug: Show application usage for each collection.
Date: Mon, 15 Aug 2011 16:39:02 -0700
Message-Id: <1313451542-79316-1-git-send-email-jeffbrown@android.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Brown <jeffbrown@android.com>

Signed-off-by: jeffbrown@android.com
---
 drivers/hid/hid-debug.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index bae4874..9a243ca 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -450,6 +450,11 @@ void hid_dump_field(struct hid_field *field, int n, struct seq_file *f) {
 		seq_printf(f, "Logical(");
 		hid_resolv_usage(field->logical, f); seq_printf(f, ")\n");
 	}
+	if (field->application) {
+		tab(n, f);
+		seq_printf(f, "Application(");
+		hid_resolv_usage(field->application, f); seq_printf(f, ")\n");
+	}
 	tab(n, f); seq_printf(f, "Usage(%d)\n", field->maxusage);
 	for (j = 0; j < field->maxusage; j++) {
 		tab(n+2, f); hid_resolv_usage(field->usage[j].hid, f); seq_printf(f, "\n");
-- 
1.7.0.4

