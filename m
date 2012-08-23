Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934372Ab2HWUuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:50:04 -0400
Received: from mail.lippert-at.com ([62.80.22.186]:6058 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934288Ab2HWUt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:49:58 -0400
Message-ID: <5036976D.5030105@LiPPERTembedded.de>
Date: Thu, 23 Aug 2012 22:49:49 +0200
From: Jens Rottmann <JRottmann@LiPPERTembedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: rootwait does not work if root=devicenumber
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Aug 2012 20:49:54.0093 (UTC) FILETIME=[D90535D0:01CD8170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation: rootwait does not work if root=devicenumber

This makes it a bit tricky to use with LILO: Typing "root=/dev/... rootwait"
directly on LILO's prompt boots fine, but putting
root = /dev/...
append = "rootwait"
in lilo.conf fails, "rootwait" is silently ignored.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTembedded.de>
---

Cost me 4 hours of my life.  If anyone feels up to fixing it init/do_mounts.c
instead of just documenting it, feel free.  :-)

Cheers,
Jens

--- linux-3.5.2/Documentation/kernel-parameters.txt
+++ rootwait_and_LILO/Documentation/kernel-parameters.txt
@@ -2530,7 +2530,9 @@
 
 	rootwait	[KNL] Wait (indefinitely) for root device to show up.
 			Useful for devices that are detected asynchronously
-			(e.g. USB and MMC devices).
+			(e.g. USB and MMC devices).  root must be specified as
+			/dev/devicename, not as (hex) device number
+			(LILO: use append = "root=/dev/...").
 
 	rw		[KNL] Mount root device read-write on boot
 
_
