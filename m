Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0DIGxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:53:16 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:33510 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806Ab0DIGxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:53:15 -0400
Message-ID: <4BBECED7.4010004@st.com>
Date: Fri, 09 Apr 2010 08:53:11 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: re-adding clocksource_get_next ?
X-Enigmail-Version: 0.96.0
Content-Type: multipart/mixed;
 boundary="------------090707060902010107000608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090707060902010107000608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello!
this function was removed in the past but I've not clear all the details.
While testing LLTng, I wrote the patch, in attachment, that re-adds it
again.
The clocksource_get_next returns the first clock source available
(without looking at the rating).
In my environment, a clock source is a TMU channel (e.g. TMU1) and,
indeed, clocksource_get_next works fine.

Let me know if it makes sense or if I'm missing something.

Best Regards,
Giuseppe

--------------090707060902010107000608
Content-Type: text/x-patch;
 name="0001-add-clocksource_get_next.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-add-clocksource_get_next.patch"

>From d05e9a31e4d697b704a1d9170aeee7235ffffb0f Mon Sep 17 00:00:00 2001
From: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Date: Tue, 6 Apr 2010 16:04:46 +0200
Subject: [PATCH] add clocksource_get_next

Added the clocksource_get_next function, it returns a source clock.
The clocksource_get_next function has been used for testing LTT
and implementing trace clock definitions on ST platforms.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 kernel/time/clocksource.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 0e98497..c9e8f56 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -613,6 +613,23 @@ static void clocksource_enqueue(struct clocksource *cs)
 	list_add(&cs->list, entry);
 }
 
+/*
+ * Return a clocksource if available
+ */
+struct clocksource *clocksource_get_next(void)
+{
+	struct clocksource *clock = NULL;
+
+	mutex_lock(&clocksource_mutex);
+	if (!list_empty(&clocksource_list)) {
+		struct list_head *list = clocksource_list.next;
+		clock = container_of(list, struct clocksource, list);
+	}
+	mutex_unlock(&clocksource_mutex);
+
+	return clock;
+}
+
 /**
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
-- 
1.6.0.4


--------------090707060902010107000608--
