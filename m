Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab0FBOo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:44:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55967 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab0FBOoy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:44:54 -0400
From: Thomas Weber <weber@corscience.de>
To: zippel@linux-m68k.org
Cc: Thomas Weber <weber@corscience.de>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] scripts: confdata: Fix fwrite warning
Date: Wed,  2 Jun 2010 16:44:19 +0200
Message-Id: <1275489859-31874-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1+b5DuLAlwTGcRgl8sWyOfZvhDcrMn3fRAEwHi
 smyhixEH/0HwOS1CcZupJIyN+vUWmM04wcqfwnbhgjCYkrvQ9m
 FG7WDQsjHjEGFY4g9gRAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get for:
scripts/kconfig/confdata.c:508
scripts/kconfig/confdata.c:759
scripts/kconfig/confdata.c:760

warning: ignoring return value of ‘fwrite’, declared with attribute warn_unused_result

So check the return value and handle the error.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 scripts/kconfig/confdata.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index c4dec80..4741fea 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -505,7 +505,10 @@ int conf_write(const char *name)
 				while (1) {
 					l = strcspn(str, "\"\\");
 					if (l) {
-						fwrite(str, l, 1, out);
+						if (fwrite(str, l, 1, out) != 1) {
+							fprintf(stderr, "write str failed\n");
+							return 1;
+						}
 						str += l;
 					}
 					if (!*str)
@@ -756,8 +759,14 @@ int conf_write_autoconf(void)
 			while (1) {
 				l = strcspn(str, "\"\\");
 				if (l) {
-					fwrite(str, l, 1, out);
-					fwrite(str, l, 1, out_h);
+					if (fwrite(str, l, 1, out) != 1) {
+						fprintf(stderr, "write str failed\n");
+						return 1;
+					}
+					if (fwrite(str, l, 1, out_h) != 1) {
+						fprintf(stderr, "write str failed\n");
+						return 1;
+					}
 					str += l;
 				}
 				if (!*str)
-- 
1.7.1

