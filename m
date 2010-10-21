Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab0JUBml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 21:42:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51294 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab0JUBlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 21:41:45 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=6KCUiig7w68A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=llRF6dNwpvhjujKOg-UA:9 a=iWeab-onBHZ-ZIbpWHIA:7 a=uuv8k3zHl5YY4bk3J6mcxXfippIA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101021014143.581171651@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Oct 2010 21:39:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 4/8] ring-buffer: Remove ring_buffer_event_time_delta()
References: <20101021013906.507064528@goodmis.org>
Content-Disposition: inline; filename=0004-ring-buffer-Remove-ring_buffer_event_time_delta.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ring_buffer_event_time_delta() static inline function does not
have any users. Remove it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 25b4f68..8d3a248 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -62,18 +62,6 @@ enum ring_buffer_type {
 unsigned ring_buffer_event_length(struct ring_buffer_event *event);
 void *ring_buffer_event_data(struct ring_buffer_event *event);
 
-/**
- * ring_buffer_event_time_delta - return the delta timestamp of the event
- * @event: the event to get the delta timestamp of
- *
- * The delta timestamp is the 27 bit timestamp since the last event.
- */
-static inline unsigned
-ring_buffer_event_time_delta(struct ring_buffer_event *event)
-{
-	return event->time_delta;
-}
-
 /*
  * ring_buffer_discard_commit will remove an event that has not
  *   ben committed yet. If this is used, then ring_buffer_unlock_commit
-- 
1.7.1


