Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2HUPKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:10:42 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:3397 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511Ab2HUPKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:10:38 -0400
Message-ID: <1345561837.4564.24.camel@x61.thuisdomein>
Subject: [PATCH 2/2] brd: RAM block module is called 'brd'
From: Paul Bolle <pebolle@tiscali.nl>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 21 Aug 2012 17:10:37 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 21 Aug 2012 15:10:37.0512 (UTC) FILETIME=[1EB9F480:01CD7FAF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RAM block module is called 'brd' ever since commit
9db5579be4bb5320c3248f6acf807aedf05ae143 ("rewrite rd"). Update its
Kconfig entry accordingly.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Of course this driver does have an 'rd' alias, see commit
efedf51c866130945b5db755cb58670e60205d83 ("Add 'rd' alias to new brd
ramdisk driver"). But its name is 'brd'.

1) "modprobe rd" doesn't work anymore under Fedora 16, because of
dracut:
    brd: Unknown parameter `md'

See man 7 dracut.cmdline for all cmdline parameters that can trigger
this error.

2) "modinfo rd" doesn't work. Apparently one needs to feed modinfo the
actual module name and not an alias. Is that by design?

 drivers/block/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 2fd52ef..0899d5a 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -376,7 +376,7 @@ config BLK_DEV_RAM
 	  during the initial install of Linux.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called rd.
+	  module will be called brd.
 
 	  Most normal users won't need the RAM disk functionality, and can
 	  thus say N here.
-- 
1.7.7.6

