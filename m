Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab2FREIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:08:53 -0400
Received: from mail-gh0-f202.google.com ([209.85.160.202]:44674 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab2FREIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:08:47 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 05/22 v4] Input: atmel_mxt_ts - don't read T5 when dumping objects
Date: Mon, 18 Jun 2012 12:08:25 +0800
Message-Id: <1339992522-22073-6-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

T5 is the message processor object.  Reading it will only have two
outcomes, neither of which is particularly useful:
 1) the message count decrements, and a valid message will be lost
 2) an invalid message will be read (reportid == 0xff)

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 0c49a1e..5eee68d 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -262,7 +262,6 @@ struct mxt_data {
 static bool mxt_object_readable(unsigned int type)
 {
 	switch (type) {
-	case MXT_GEN_MESSAGE_T5:
 	case MXT_GEN_COMMAND_T6:
 	case MXT_GEN_POWER_T7:
 	case MXT_GEN_ACQUIRE_T8:
-- 
1.7.7.3

