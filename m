Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab1IBCvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 22:51:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57998 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071Ab1IBCvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 22:51:12 -0400
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jayeeta Banerjee <jayeeta.banerjee@stericsson.com>,
        Harvey Yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 2/2] drivers/input: Fix section mismatch warning in tc3589x-keypad.c
Date: Fri,  2 Sep 2011 10:50:07 +0800
Message-Id: <1314931807-3171-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: drivers/input/keyboard/built-in.o(.text+0xb55b): Section mismatch in reference from the function tc3589x_keypad_open() to the function .devinit.text:tc3589x_keypad_init_key_hardware()
The function tc3589x_keypad_open() references
the function __devinit tc3589x_keypad_init_key_hardware().
This is often because tc3589x_keypad_open lacks a __devinit
annotation or the annotation of tc3589x_keypad_init_key_hardware is wrong.

Signed-off-by: Harvey Yang <harvey.huawei.yang@gmail.com>
---
 drivers/input/keyboard/tc3589x-keypad.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tc3589x-keypad.c
index 99122f5..f60c9e8 100644
--- a/drivers/input/keyboard/tc3589x-keypad.c
+++ b/drivers/input/keyboard/tc3589x-keypad.c
@@ -90,7 +90,7 @@ struct tc_keypad {
 	bool keypad_stopped;
 };
 
-static int __devinit tc3589x_keypad_init_key_hardware(struct tc_keypad *keypad)
+static int tc3589x_keypad_init_key_hardware(struct tc_keypad *keypad)
 {
 	int ret;
 	struct tc3589x *tc3589x = keypad->tc3589x;
-- 
1.7.2.5

