Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0JGUgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:36:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:57515 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0JGUgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:36:03 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: dmitry.torokhov@gmail.com
Cc: kgdb-bugreport@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/3] keyboard,kdb: inject SYN events in kbd_clear_keys_helper
Date: Thu,  7 Oct 2010 15:35:47 -0500
Message-Id: <1286483748-1171-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1286483748-1171-1-git-send-email-jason.wessel@windriver.com>
References: <1286483748-1171-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 07 Oct 2010 20:35:53.0018 (UTC) FILETIME=[3C52D9A0:01CB665F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Levitsky <maximlevitsky@gmail.com>

The kbd_clear_keys_helper injects the keyup events alright, but it
doesn't inject SYN events, and therefore X evdev driver doesn't pick
these injected events untill next SYN event.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/char/keyboard.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 0c6c641..7df6af5 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -368,6 +368,7 @@ static int kbd_clear_keys_helper(struct input_handle *handle, void *data)
 {
 	unsigned int *keycode = data;
 	input_inject_event(handle, EV_KEY, *keycode, 0);
+	input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
 	return 0;
 }
 
-- 
1.6.3.3

