Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab1BDMXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:23:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1BDMXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:23:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=pAxWnmsNTsfEr+mmZZUb5wPbyztRGfT6okZ0GV++yec+ffyN4Kn8uMBz82vXg5YYHk
         RN9e6ZA27kmlk4Fkdks9UlEnNpXYE3YnMyQuFJvXUF6w8EdCxNYJ0KHm4Fap+AKJQ8BN
         0+6w2lPBzP96aIsNkrHauYww+mE+NlLOmB5tk=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 08/20] mfd: ab3100: world-writable debugfs *_priv files
Date: Fri,  4 Feb 2011 15:23:36 +0300
Message-Id: <b5dceec3591728e7dfa4d9fb2e978780e55420c5.1296818921.git.segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow everybody to change device hardware registers.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/mfd/ab3100-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 4193af5..1707d22 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -613,7 +613,7 @@ static void ab3100_setup_debugfs(struct ab3100 *ab3100)
 	ab3100_get_priv.ab3100 = ab3100;
 	ab3100_get_priv.mode = false;
 	ab3100_get_reg_file = debugfs_create_file("get_reg",
-				S_IWUGO, ab3100_dir, &ab3100_get_priv,
+				S_IWUSR, ab3100_dir, &ab3100_get_priv,
 				&ab3100_get_set_reg_fops);
 	if (!ab3100_get_reg_file) {
 		err = -ENOMEM;
@@ -623,7 +623,7 @@ static void ab3100_setup_debugfs(struct ab3100 *ab3100)
 	ab3100_set_priv.ab3100 = ab3100;
 	ab3100_set_priv.mode = true;
 	ab3100_set_reg_file = debugfs_create_file("set_reg",
-				S_IWUGO, ab3100_dir, &ab3100_set_priv,
+				S_IWUSR, ab3100_dir, &ab3100_set_priv,
 				&ab3100_get_set_reg_fops);
 	if (!ab3100_set_reg_file) {
 		err = -ENOMEM;
-- 
1.7.0.4

