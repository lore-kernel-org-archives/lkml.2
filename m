Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1B1Xsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:48:51 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:55277 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab1B1XsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:48:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references; q=dns; s=sasl; b=
	VlukoCmsKQACYfGhb8eiWjxWSYHG3p2T6Z95dqoHxW5RxTkNDYBCkyM7Yc6DggVC
	SxEVH9FRHWy1ZOcF6nlXAMaJE5fKcfQNiq7w6AgXd891Jba6ydqGXpo1pgkaB3gl
	MicqRzyVZR9eIJpVbZTwIHwNL9XIL9S6AsZaJfb2ouo=
From: ntl@pobox.com
To: linux-kernel@vger.kernel.org
Cc: containers@lists.linux-foundation.org, Oren Laadan <orenl@cs.columbia.edu>
Subject: [PATCH 09/10] Add generic '->checkpoint()' f_op to simple char
 devices
Date: Mon, 28 Feb 2011 17:40:31 -0600
Message-Id: <1298936432-29607-10-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298936432-29607-1-git-send-email-ntl@pobox.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
X-Pobox-Relay-ID: 7169B704-4394-11E0-B7C2-AF401E47CF6F-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oren Laadan <orenl@cs.columbia.edu>

* /dev/null
* /dev/zero
* /dev/random
* /dev/urandom

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 drivers/char/mem.c    |    6 ++++++
 drivers/char/random.c |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 1256454..3452d1f 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -767,6 +767,9 @@ static const struct file_operations null_fops = {
 	.read		= read_null,
 	.write		= write_null,
 	.splice_write	= splice_write_null,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint	= generic_file_checkpoint,
+#endif
 };
 
 #ifdef CONFIG_DEVPORT
@@ -783,6 +786,9 @@ static const struct file_operations zero_fops = {
 	.read		= read_zero,
 	.write		= write_zero,
 	.mmap		= mmap_zero,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint	= generic_file_checkpoint,
+#endif
 };
 
 /*
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5a1aa64..67d00b8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1166,6 +1166,9 @@ const struct file_operations random_fops = {
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint = generic_file_checkpoint,
+#endif
 };
 
 const struct file_operations urandom_fops = {
@@ -1174,6 +1177,9 @@ const struct file_operations urandom_fops = {
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint = generic_file_checkpoint,
+#endif
 };
 
 /***************************************************************
-- 
1.7.4

