Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab2JWNlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:41:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62554 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386Ab2JWNlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:41:39 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH -next] printk: fix broken 'console' kernel parameter
Date: Tue, 23 Oct 2012 21:41:18 +0800
Message-Id: <1350999678-17441-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_A11Y_BRAILLE_CONSOLE is not enabled, _braille_console_setup()
should return NULL to parse the parameter further in console_setup().

This patch fixes the broken 'console' kernel parameter, which makes the
Pandaboard not boot with 'console=ttyO2'.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Joe Perches <joe@perches.com>

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 kernel/printk/braille.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk/braille.h b/kernel/printk/braille.h
index d2e6bc3..769d771 100644
--- a/kernel/printk/braille.h
+++ b/kernel/printk/braille.h
@@ -28,7 +28,7 @@ braille_set_options(struct console_cmdline *c, char *brl_options)
 static inline char *
 _braille_console_setup(char **str, char **brl_options)
 {
-	return *str;
+	return NULL;
 }
 
 static inline int
-- 
1.7.9.5

