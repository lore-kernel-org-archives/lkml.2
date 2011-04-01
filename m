Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab1DAPIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:08:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1DAPIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:08:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=VVROYlRL4Vkth/4c4+4AODTXXmGoFFCmc5HW72Q+SUTMJRkFJozgHLMMDam0rxK/m6
         6aAdEE+oQJ0e8InjpFsSdXt1Sa6P6Bcz0WakK9GewN1qJ/oO/4sLbDce7EinYCJtei5k
         Cq2zD8qyHnxK4119kYJdvXDvCXa9aopuxkA7c=
Subject: [PATCH] Input: twl4030_keypad - fix potential NULL dereference in
 twl4030_kp_probe()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 23:08:03 +0800
Message-ID: <1301670483.6013.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should first check whether platform data is NULL or not, before
dereferencing it to get the keymap.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/keyboard/twl4030_keypad.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/twl4030_keypad.c b/drivers/input/keyboard/twl4030_keypad.c
index 09bef79..d02811c 100644
--- a/drivers/input/keyboard/twl4030_keypad.c
+++ b/drivers/input/keyboard/twl4030_keypad.c
@@ -332,7 +332,7 @@ static int __devinit twl4030_kp_program(struct twl4030_keypad *kp)
 static int __devinit twl4030_kp_probe(struct platform_device *pdev)
 {
 	struct twl4030_keypad_data *pdata = pdev->dev.platform_data;
-	const struct matrix_keymap_data *keymap_data = pdata->keymap_data;
+	const struct matrix_keymap_data *keymap_data;
 	struct twl4030_keypad *kp;
 	struct input_dev *input;
 	u8 reg;
@@ -344,6 +344,8 @@ static int __devinit twl4030_kp_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	keymap_data = pdata->keymap_data;
+
 	kp = kzalloc(sizeof(*kp), GFP_KERNEL);
 	input = input_allocate_device();
 	if (!kp || !input) {
-- 
1.7.1



