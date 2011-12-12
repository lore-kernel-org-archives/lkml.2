Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1LLHPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:15:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50684 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab1LLHN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:13:59 -0500
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 11/11] kvm tools: remove duplicated code
Date: Mon, 12 Dec 2011 15:15:55 +0800
Message-Id: <1323674155-17570-12-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323674155-17570-1-git-send-email-laijs@cn.fujitsu.com>
References: <1323674155-17570-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-12 15:13:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-12 15:13:23,
	Serialize complete at 2011-12-12 15:13:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple cleanup.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 tools/kvm/guest_compat.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/tools/kvm/guest_compat.c b/tools/kvm/guest_compat.c
index 8dd451b..43b9035 100644
--- a/tools/kvm/guest_compat.c
+++ b/tools/kvm/guest_compat.c
@@ -17,6 +17,13 @@ static int id;
 static DEFINE_MUTEX(compat_mtx);
 static LIST_HEAD(messages);
 
+static void compat__free(struct compat_message *msg)
+{
+	free(msg->title);
+	free(msg->desc);
+	free(msg);
+}
+
 int compat__add_message(const char *title, const char *desc)
 {
 	struct compat_message *msg;
@@ -42,22 +49,12 @@ int compat__add_message(const char *title, const char *desc)
 	return msg_id;
 
 cleanup:
-	if (msg) {
-		free(msg->title);
-		free(msg->desc);
-		free(msg);
-	}
+	if (msg)
+		compat__free(msg);
 
 	return -ENOMEM;
 }
 
-static void compat__free(struct compat_message *msg)
-{
-	free(msg->title);
-	free(msg->desc);
-	free(msg);
-}
-
 int compat__remove_message(int id)
 {
 	struct compat_message *pos, *n;
-- 
1.7.4.4

