Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab2BTC0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:26:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2BTC0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:26:20 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net, hjl.tools@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4/7] compat: Use COMPAT_USE_64BIT_TIME in the input subsystem
Date: Sun, 19 Feb 2012 18:22:47 -0800
Message-Id: <1329704570-3792-5-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329704570-3792-1-git-send-email-hpa@zytor.com>
References: <CA+55aFwiV3N-9-pB6ofN-5GBS0mnPTBGAdPH1M70wK8qr-=PQg@mail.gmail.com>
 <1329704570-3792-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 18:26:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. J. Lu" <hjl.tools@gmail.com>

Enable the input system to be used with a compat ABI with 64-bit time.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/input-compat.c |    4 ++--
 drivers/input/input-compat.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/input-compat.c b/drivers/input/input-compat.c
index e46a867..64ca711 100644
--- a/drivers/input/input-compat.c
+++ b/drivers/input/input-compat.c
@@ -17,7 +17,7 @@
 int input_event_from_user(const char __user *buffer,
 			  struct input_event *event)
 {
-	if (INPUT_COMPAT_TEST) {
+	if (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME) {
 		struct input_event_compat compat_event;
 
 		if (copy_from_user(&compat_event, buffer,
@@ -41,7 +41,7 @@ int input_event_from_user(const char __user *buffer,
 int input_event_to_user(char __user *buffer,
 			const struct input_event *event)
 {
-	if (INPUT_COMPAT_TEST) {
+	if (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME) {
 		struct input_event_compat compat_event;
 
 		compat_event.time.tv_sec = event->time.tv_sec;
diff --git a/drivers/input/input-compat.h b/drivers/input/input-compat.h
index 22be27b..148f66f 100644
--- a/drivers/input/input-compat.h
+++ b/drivers/input/input-compat.h
@@ -67,7 +67,7 @@ struct ff_effect_compat {
 
 static inline size_t input_event_size(void)
 {
-	return INPUT_COMPAT_TEST ?
+	return (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME) ?
 		sizeof(struct input_event_compat) : sizeof(struct input_event);
 }
 
-- 
1.7.6.5

