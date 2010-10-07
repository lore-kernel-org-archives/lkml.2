Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597Ab0JGBBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 21:01:38 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:58183 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0JGBBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 21:01:37 -0400
Subject: [PATCH] IPC: Initialize structure memory to zero for
 compat_sys_mq_*
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 21:01:34 -0400
Message-ID: <1286413294.4645.128.camel@Dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "reserved" member should be zeroed before copying back to userspace
to avoid leaking uninitialized kernel stack memory.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>

--- linux-2.6.35.5.orig/ipc/compat_mq.c	2010-09-20 16:59:09.000000000 -0400
+++ linux-2.6.35.5/ipc/compat_mq.c	2010-10-06 20:55:08.000000000 -0400
@@ -52,7 +52,7 @@ asmlinkage long compat_sys_mq_open(const
 {
 	void __user *p = NULL;
 	if (u_attr && oflag & O_CREAT) {
-		struct mq_attr attr;
+		struct mq_attr attr = {};
 		p = compat_alloc_user_space(sizeof(attr));
 		if (get_compat_mq_attr(&attr, u_attr) ||
 		    copy_to_user(p, &attr, sizeof(attr)))
@@ -123,7 +123,7 @@ asmlinkage long compat_sys_mq_getsetattr
 			const struct compat_mq_attr __user *u_mqstat,
 			struct compat_mq_attr __user *u_omqstat)
 {
-	struct mq_attr mqstat;
+	struct mq_attr mqstat = {};
 	struct mq_attr __user *p = compat_alloc_user_space(2 * sizeof(*p));
 	long ret;
 


