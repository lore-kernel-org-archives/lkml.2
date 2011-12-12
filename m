Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1LLHO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:14:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60902 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab1LLHOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:14:04 -0500
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 10/11] kvm tools: protect shared global id in compat_mtx C.S.
Date: Mon, 12 Dec 2011 15:15:54 +0800
Message-Id: <1323674155-17570-11-git-send-email-laijs@cn.fujitsu.com>
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

The global id is shared, protect it when access it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 tools/kvm/guest_compat.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/kvm/guest_compat.c b/tools/kvm/guest_compat.c
index de97df5..8dd451b 100644
--- a/tools/kvm/guest_compat.c
+++ b/tools/kvm/guest_compat.c
@@ -20,6 +20,7 @@ static LIST_HEAD(messages);
 int compat__add_message(const char *title, const char *desc)
 {
 	struct compat_message *msg;
+	int msg_id;
 
 	msg = malloc(sizeof(*msg));
 	if (msg == NULL)
@@ -33,12 +34,12 @@ int compat__add_message(const char *title, const char *desc)
 
 	mutex_lock(&compat_mtx);
 
-	msg->id = id;
+	msg->id = msg_id = id++;
 	list_add_tail(&msg->list, &messages);
 
 	mutex_unlock(&compat_mtx);
 
-	return id++;
+	return msg_id;
 
 cleanup:
 	if (msg) {
-- 
1.7.4.4

