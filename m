Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab1K1X0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:26:30 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38852 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755013Ab1K1X02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:26:28 -0500
X-Sasl-enc: OmPHDy/yt4EQ4smlxkcx2Xv+0j7xoaaIpPhp5BwstHO6 1322522787
Date: Tue, 29 Nov 2011 08:25:58 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.1.4
Message-ID: <20111128232558.GB21133@kroah.com>
References: <20111128232544.GA21133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128232544.GA21133@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index d614254..7f8a93b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 1
-SUBLEVEL = 3
+SUBLEVEL = 4
 EXTRAVERSION =
 NAME = "Divemaster Edition"
 
diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index afef3df..29bec34 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1480,15 +1480,10 @@ iso_stream_schedule (
 
 		/* NOTE:  assumes URB_ISO_ASAP, to limit complexity/bugs */
 
-		/* find a uframe slot with enough bandwidth.
-		 * Early uframes are more precious because full-speed
-		 * iso IN transfers can't use late uframes,
-		 * and therefore they should be allocated last.
-		 */
-		next = start;
-		start += period;
-		do {
-			start--;
+		/* find a uframe slot with enough bandwidth */
+		next = start + period;
+		for (; start < next; start++) {
+
 			/* check schedule: enough space? */
 			if (stream->highspeed) {
 				if (itd_slot_ok(ehci, mod, start,
@@ -1501,7 +1496,7 @@ iso_stream_schedule (
 						start, sched, period))
 					break;
 			}
-		} while (start > next);
+		}
 
 		/* no room in the schedule */
 		if (start == next) {
