Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2LEPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:25:58 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64374 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab2LEPZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:25:57 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [BUGFIX PATCH] rtc: eliminate extra call of ida_simple_remove()
Date: Wed,  5 Dec 2012 16:25:31 +0100
Message-Id: <1354721131-31177-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unbinding an RTC chip driver from its device leads to the error
message:
|ida_remove called for id=0 which is not allocated.

This is caused by a redundant call to ida_simple_remove() in
rtc_device_unregister().
Eliminate the call in rtc_device_unregister() and only call the
function in rtc_device_release().

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/rtc/class.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index f8a0aab..5143629 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -244,7 +244,6 @@ void rtc_device_unregister(struct rtc_device *rtc)
 		rtc_proc_del_device(rtc);
 		device_unregister(&rtc->dev);
 		rtc->ops = NULL;
-		ida_simple_remove(&rtc_ida, rtc->id);
 		mutex_unlock(&rtc->ops_lock);
 		put_device(&rtc->dev);
 	}
-- 
1.7.2.5

