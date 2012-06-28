Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab2F1NIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:08:32 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40147 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab2F1NI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:08:28 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 05/23 v6] Input: atmel_mxt_ts - don't read T5 when dumping objects
Date: Thu, 28 Jun 2012 21:08:06 +0800
Message-Id: <1340888904-15620-6-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
References: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
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
index c72f595..9f8dd97 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -263,7 +263,6 @@ struct mxt_data {
 static bool mxt_object_readable(unsigned int type)
 {
 	switch (type) {
-	case MXT_GEN_MESSAGE_T5:
 	case MXT_GEN_COMMAND_T6:
 	case MXT_GEN_POWER_T7:
 	case MXT_GEN_ACQUIRE_T8:
-- 
1.7.7.3

