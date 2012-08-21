Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab2HUPIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:08:47 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:4416 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636Ab2HUPIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:08:46 -0400
Message-ID: <1345561720.4564.22.camel@x61.thuisdomein>
Subject: [PATCH 1/2] drb: remove note about "ramdisk" kernel parameter
From: Paul Bolle <pebolle@tiscali.nl>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 21 Aug 2012 17:08:40 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 21 Aug 2012 15:08:40.0902 (UTC) FILETIME=[D938AE60:01CD7FAE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ramdisk kernel parameter was finally removed in commit
1adbee50fd6fce5af4feb34d2db93cfe4d2066a4 ("ramdisk: remove
long-deprecated "ramdisk=" boot-time parameter"). It had been marked as
deprecated since v1.3.96! Remove this note from its Kconfig entry.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) The ramdisk kernel parameter was rather stubborn. It had to be
removed from the tree three times:
- in release v1.3.48 - re-added in v1.3.96;
- in v2.6.24, with commit fac8b209b1084bc85748bd54e13d00c1262b220f
("Remove final traces of long-deprecated "ramdisk" kernel parm") -
re-added in v2.6.25, with commit
9db5579be4bb5320c3248f6acf807aedf05ae143 ("rewrite rd);
- in v2.6.31, with commit 1adbee50fd6fce5af4feb34d2db93cfe4d2066a4 (see
above).

1) But references to it still get added to command lines in defconfig
files and device tree sources, all in arch/arm. As recently as v3.6-rc1!
I guess it is now (silently?) ignored if used in one of those command
lines. Or does arm use some obscure trick to still handle this kernel
parameter?

 drivers/block/Kconfig |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index a796407..2fd52ef 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -375,9 +375,6 @@ config BLK_DEV_RAM
 	  store a copy of a minimal root file system off of a floppy into RAM
 	  during the initial install of Linux.
 
-	  Note that the kernel command line option "ramdisk=XX" is now obsolete.
-	  For details, read <file:Documentation/blockdev/ramdisk.txt>.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called rd.
 
-- 
1.7.7.6

