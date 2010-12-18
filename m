Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab0LRTdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 14:33:44 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:47301 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757057Ab0LRTdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 14:33:43 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        stable@kernel.org
Subject: [PATCH] Input: Fix double equality sign in uevent
Date: Sat, 18 Dec 2010 20:31:57 +0100
Message-Id: <1292700717-1610-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.2.3
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PU2WQ-0002gg-8q.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PU2WQ-0002gg-8q a31110d03fa140785defa1e285ab7c18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at the uevent stream for input devices, all properties
are on the form "A=B" except the bitmap values, which are on the
form "A==B". Remedied with this patch.

Cc: stable@kernel.org
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Dmitry,

Unless the input bitmap properties should really behave differently,
this patch ought to be a candidate for 2.6.37.

Thanks,
Henrik

 drivers/input/input.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index c3e5fc7..bed725f 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1471,7 +1471,7 @@ static int input_add_uevent_bm_var(struct kobj_uevent_env *env,
 {
 	int len;
 
-	if (add_uevent_var(env, "%s=", name))
+	if (add_uevent_var(env, "%s", name))
 		return -ENOMEM;
 
 	len = input_print_bitmap(&env->buf[env->buflen - 1],
-- 
1.7.2.3

