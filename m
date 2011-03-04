Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab1CDPJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:09:00 -0500
Received: from asset.uwaterloo.ca ([129.97.92.29]:37280 "EHLO
	asset.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1CDPIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:08:42 -0500
X-Greylist: delayed 2954 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 10:08:41 EST
Date: Fri, 4 Mar 2011 09:19:24 -0500
From: chenliu@asset.uwaterloo.ca
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2]early: fix possible overlapping data buffer
Message-ID: <20110304141924.GD30317@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bugzilla #12965:
https://bugzilla.kernel.org/show_bug.cgi?id=12965

The original code contains dangerous uses of sprintf functions like sprintf(defsys_cmd, "%s EW MINSIZE=%.7iK PARMREGS=0-13", defsys_cmd, min_size), where defsys_cmd is defined as a fixed length buffer. Replace them with snprintf can fix such issues.

Signed-off-by: Chen Liu <chenliunju@gmail.com>
---
 arch/s390/kernel/early.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c

--- a/arch/s390/kernel/early.c	2010-09-04 23:28:51.706415118 -0400
+++ b/arch/s390/kernel/early.c	2011-03-03 23:22:53.783164331 -0500
@@ -133,8 +133,8 @@ static noinline __init void create_kerne
 		sinitrd_pfn = PFN_DOWN(__pa(INITRD_START));
 		einitrd_pfn = PFN_UP(__pa(INITRD_START + INITRD_SIZE));
 		min_size = einitrd_pfn << 2;
-		sprintf(defsys_cmd, "%s EW %.5X-%.5X", defsys_cmd,
-		sinitrd_pfn, einitrd_pfn);
+		snprintf(defsys_cmd, sizeof(defsys_cmd), "%s EW %.5X-%.5X",
+			 defsys_cmd, sinitrd_pfn, einitrd_pfn);
 	}
 #endif
