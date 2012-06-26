Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab2FZG7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 02:59:49 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:35316 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab2FZG5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:57:20 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 05/21 v5] Input: atmel_mxt_ts - don't read T5 when dumping objects
Date: Tue, 26 Jun 2012 14:56:53 +0800
Message-Id: <1340693829-18665-6-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
References: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
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

