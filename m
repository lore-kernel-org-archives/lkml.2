Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab1LAHSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:18:35 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59526 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1LAHSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:18:34 -0500
From: Xi Wang <xi.wang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] audit: signedness bug in audit_log_execve_info()
Date: Thu, 1 Dec 2011 02:18:30 -0500
Message-Id: <13112F4F-1C37-45DA-8032-CC58DB6BFD50@gmail.com>
Cc: linux-kernel@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_log_single_execve_arg() returns an int.  "len" should also be
int for the error handling to work.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 kernel/auditsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 47b7fc1..5b118d8 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1166,8 +1166,8 @@ static void audit_log_execve_info(struct audit_context *context,
 				  struct audit_buffer **ab,
 				  struct audit_aux_data_execve *axi)
 {
-	int i;
-	size_t len, len_sent = 0;
+	int i, len;
+	size_t len_sent = 0;
 	const char __user *p;
 	char *buf;
 
-- 
1.7.5.4


