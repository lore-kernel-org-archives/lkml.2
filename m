Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab0CSPXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:23:01 -0400
Received: from kroah.org ([198.145.64.141]:45873 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab0CSPSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:18:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Fang Wenqi <anton.fang@gmail.com>, Fang Wenqi <antonf@turbolinux.com.cn>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/7] tty_buffer: Fix distinct type warning
Date: Fri, 19 Mar 2010 08:18:34 -0700
Message-Id: <1269011916-8836-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151326.GC8541@kroah.com>
References: <20100319151326.GC8541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fang Wenqi <anton.fang@gmail.com>

CC      drivers/char/tty_buffer.o
drivers/char/tty_buffer.c: In function ‘tty_insert_flip_string_fixed_flag’:
drivers/char/tty_buffer.c:251: warning: comparison of distinct pointer types lacks a cast
drivers/char/tty_buffer.c: In function ‘tty_insert_flip_string_flags’:
drivers/char/tty_buffer.c:288: warning: comparison of distinct pointer types lacks a cast

Fix it by replacing min() with min_t() in tty_insert_flip_string_flags and
					  tty_insert_flip_string_fixed_flag().

Signed-off-by: Fang Wenqi <antonf@turbolinux.com.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_buffer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index af8d977..7ee5216 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -248,7 +248,7 @@ int tty_insert_flip_string_fixed_flag(struct tty_struct *tty,
 {
 	int copied = 0;
 	do {
-		int goal = min(size - copied, TTY_BUFFER_PAGE);
+		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
 		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
@@ -285,7 +285,7 @@ int tty_insert_flip_string_flags(struct tty_struct *tty,
 {
 	int copied = 0;
 	do {
-		int goal = min(size - copied, TTY_BUFFER_PAGE);
+		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
 		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
-- 
1.7.0.2

