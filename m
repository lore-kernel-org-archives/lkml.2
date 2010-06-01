Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab0FAIBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:01:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60997 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab0FAIBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:01:46 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] Rename ramzswap to zram in documentation
Date: Tue,  1 Jun 2010 13:31:26 +0530
Message-Id: <1275379286-10453-5-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Related changes:
 - Included example to show usage as generic
(non-swap) disk with ext4 filesystem.
 - Renamed rzscontrol to zramconfig to match
with new device naming.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/zram/zram.txt |  113 ++++++++++++++++++++++------------------
 1 files changed, 62 insertions(+), 51 deletions(-)
 rewrite drivers/staging/zram/zram.txt (73%)

diff --git a/drivers/staging/zram/zram.txt b/drivers/staging/zram/zram.txt
dissimilarity index 73%
index 9694acf..520edc1 100644
--- a/drivers/staging/zram/zram.txt
+++ b/drivers/staging/zram/zram.txt
@@ -1,51 +1,62 @@
-ramzswap: Compressed RAM based swap device
--------------------------------------------
-
-Project home: http://compcache.googlecode.com/
-
-* Introduction
-
-The ramzswap module creates RAM based block devices which can (only) be used as
-swap disks. Pages swapped to these devices are compressed and stored in memory
-itself. See project home for use cases, performance numbers and a lot more.
-
-Individual ramzswap devices are configured and initialized using rzscontrol
-userspace utility as shown in examples below. See rzscontrol man page for more
-details.
-
-* Usage
-
-Following shows a typical sequence of steps for using ramzswap.
-
-1) Load Modules:
-	modprobe ramzswap num_devices=4
-	This creates 4 (uninitialized) devices: /dev/ramzswap{0,1,2,3}
-	(num_devices parameter is optional. Default: 1)
-
-2) Initialize:
-	Use rzscontrol utility to configure and initialize individual
-	ramzswap devices. Example:
-	rzscontrol /dev/ramzswap2 --init # uses default value of disksize_kb
-
-	*See rzscontrol man page for more details and examples*
-
-3) Activate:
-	swapon /dev/ramzswap2 # or any other initialized ramzswap device
-
-4) Stats:
-	rzscontrol /dev/ramzswap2 --stats
-
-5) Deactivate:
-	swapoff /dev/ramzswap2
-
-6) Reset:
-	rzscontrol /dev/ramzswap2 --reset
-	(This frees all the memory allocated for this device).
-
-
-Please report any problems at:
- - Mailing list: linux-mm-cc at laptop dot org
- - Issue tracker: http://code.google.com/p/compcache/issues/list
-
-Nitin Gupta
-ngupta@vflare.org
+zram: Compressed RAM based block devices
+----------------------------------------
+
+Project home: http://compcache.googlecode.com/
+
+* Introduction
+
+The zram module creates RAM based block devices: /dev/ramX (X = 0, 1, ...).
+Pages written to these disks are compressed and stored in memory itself.
+These disks allow very fast I/O and compression provides good amounts of
+memory savings.
+
+See project home for use cases, performance numbers and a lot more.
+
+Individual zram devices are configured and initialized using zramconfig
+userspace utility as shown in examples below. See zramconfig man page for
+more details.
+
+* Usage
+
+Following shows a typical sequence of steps for using zram.
+
+1) Load Modules:
+	modprobe zram num_devices=4
+	This creates 4 (uninitialized) devices: /dev/zram{0,1,2,3}
+	(num_devices parameter is optional. Default: 1)
+
+2) Initialize:
+	Use zramconfig utility to configure and initialize individual
+	zram devices. For example:
+	zramconfig /dev/zram0 --init # uses default value of disksize_kb
+	zramconfig /dev/zram1 --disksize_kb=102400 # 100MB /dev/zram1
+
+	*See zramconfig man page for more details and examples*
+
+3) Activate:
+	mkswap /dev/zram0
+	swapon /dev/zram0
+
+	mkfs.ext4 /dev/zram1
+	mount /dev/zram1 /tmp
+
+4) Stats:
+	zramconfig /dev/zram0 --stats
+	zramconfig /dev/zram1 --stats
+
+5) Deactivate:
+	swapoff /dev/zram0
+	umount /dev/zram1
+
+6) Reset:
+	zramconfig /dev/zram0 --reset
+	zramconfig /dev/zram1 --reset
+	(This frees memory allocated for the given device).
+
+
+Please report any problems at:
+ - Mailing list: linux-mm-cc at laptop dot org
+ - Issue tracker: http://code.google.com/p/compcache/issues/list
+
+Nitin Gupta
+ngupta@vflare.org
-- 
1.7.0.1

