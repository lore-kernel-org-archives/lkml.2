Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1COWyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:54:14 -0400
Received: from shutemov.name ([188.40.19.243]:49812 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab1COWx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:53:29 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 10/13] clockevent: use list_move() instead of list_del()/list_add() combination
Date: Wed, 16 Mar 2011 00:53:22 +0200
Message-Id: <1300229605-14499-10-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clockevents.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index d7395fd..b1fa45d 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -168,8 +168,7 @@ static void clockevents_notify_released(void)
 	while (!list_empty(&clockevents_released)) {
 		dev = list_entry(clockevents_released.next,
 				 struct clock_event_device, list);
-		list_del(&dev->list);
-		list_add(&dev->list, &clockevent_devices);
+		list_move(&dev->list, &clockevent_devices);
 		clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
 	}
 }
@@ -221,8 +220,7 @@ void clockevents_exchange_device(struct clock_event_device *old,
 	 */
 	if (old) {
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
-		list_del(&old->list);
-		list_add(&old->list, &clockevents_released);
+		list_move(&old->list, &clockevents_released);
 	}
 
 	if (new) {
-- 
1.7.4.1

