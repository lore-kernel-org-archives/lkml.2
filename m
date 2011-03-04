Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab1CDPKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:10:15 -0500
Received: from asset.uwaterloo.ca ([129.97.92.29]:37283 "EHLO
	asset.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1CDPKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:10:13 -0500
Date: Fri, 4 Mar 2011 10:10:11 -0500
From: chenliu@asset.uwaterloo.ca
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2]early: fix possible overlapping data buffer
Message-ID: <20110304151011.GA30600@asset.uwaterloo.ca>
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

--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
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
 

