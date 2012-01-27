Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2A0DJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 22:09:14 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:60514 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab2A0DJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 22:09:11 -0500
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, mrubin@google.com, chavey@google.com,
        David Sharp <dhsharp@google.com>
Subject: [PATCH] trace-cmd: fix length calculation for padding events
Date: Thu, 26 Jan 2012 19:00:15 -0800
Message-Id: <1327633215-4013-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Padding events store size in bytes, not words. Usually this ends up pushing
the parser off the current page, but occasionally not, and when not,
it ends up desynchronizing the parser from the event stream. This would
manifest as a lot of "ug!" messages from trace-cmd, and kernelshark
crashing before displaying the UI.

Signed-off-by: David Sharp <dhsharp@google.com>
---
 trace-input.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/trace-input.c b/trace-input.c
index e3157a7..b6af1e6 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -1458,7 +1458,6 @@ translate_data(struct pevent *pevent,
 	switch (type_len) {
 	case RINGBUF_TYPE_PADDING:
 		*length = data2host4(pevent, *ptr);
-		*length *= 4;
 		*ptr += *length;
 		break;
 
-- 
1.7.7.3

