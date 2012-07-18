Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab2GRAOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:14:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39263 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab2GRANI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:13:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [ 14/23] ntp: Correct TAI offset during leap second
Date: Tue, 17 Jul 2012 17:12:07 -0700
Message-Id: <20120717232330.388270313@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232329.276003806@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232329.276003806@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Richard Cochran <richardcochran@gmail.com>

This is a backport of dd48d708ff3e917f6d6b6c2b696c3f18c019feed

When repeating a UTC time value during a leap second (when the UTC
time should be 23:59:60), the TAI timescale should not stop. The kernel
NTP code increments the TAI offset one second too late. This patch fixes
the issue by incrementing the offset during the leap second itself.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/ntp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -378,6 +378,7 @@ int second_overflow(unsigned long secs)
 		if (secs % 86400 == 0) {
 			leap = -1;
 			time_state = TIME_OOP;
+			time_tai++;
 			printk(KERN_NOTICE
 				"Clock: inserting leap second 23:59:60 UTC\n");
 		}
@@ -392,7 +393,6 @@ int second_overflow(unsigned long secs)
 		}
 		break;
 	case TIME_OOP:
-		time_tai++;
 		time_state = TIME_WAIT;
 		break;
 


