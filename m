Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369Ab1CDPLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:11:41 -0500
Received: from asset.uwaterloo.ca ([129.97.92.29]:37286 "EHLO
	asset.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1CDPLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:11:40 -0500
Date: Fri, 4 Mar 2011 10:11:37 -0500
From: chenliu@asset.uwaterloo.ca
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2]early: fix possible overlapping data buffer
Message-ID: <20110304151137.GB30600@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bugzilla #12965:
https://bugzilla.kernel.org/show_bug.cgi?id=12965

The original code contains dangerous uses of sprintf functions like sprintf(defsys_cmd, "%s EW MINSIZE=%.7iK PARMREGS=0-13", defsys_cmd, min_size), where defsys_cmd is defined as
 a fixed length buffer. Replace them with snprintf can fix such issues.

Signed-off-by: Chen Liu <chenliunju@gmail.com>
---
 arch/s390/kernel/early.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c

--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -138,8 +138,8 @@ static noinline __init void create_kerne
 	}
 #endif
 
-	sprintf(defsys_cmd, "%s EW MINSIZE=%.7iK PARMREGS=0-13",
-		defsys_cmd, min_size);
+	snprintf(defsys_cmd, sizeof(defsys_cmd),
+		 "%s EW MINSIZE=%.7iK PARMREGS=0-13", defsys_cmd, min_size);
 	sprintf(savesys_cmd, "SAVESYS %s \n IPL %s",
 		kernel_nss_name, kernel_nss_name);
 

