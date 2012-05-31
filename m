Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab2EaWtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 18:49:31 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:51805 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab2EaWt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 18:49:29 -0400
X-Greylist: delayed 1507 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2012 18:49:29 EDT
Date: Fri, 1 Jun 2012 00:24:07 +0200
From: Harald Welte <laforge@gnumonks.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] List LGPL (v2 / v2.1) as GPL compatible in
 license_is_gpl_compatible()
Message-ID: <20120531222407.GB5256@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It may be a highly unusual choice to license Linux kernel drivers under
LGPL, but at least as long as LGPLv2 or LGPLv2.1 is used, this is fully
GPL compatible and shouldn't taint the kernel.

Signed-off-by: Harald Welte <laforge@gnumonks.org>
---
 include/linux/license.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

 NOTE: I've actually seen this happen in practise, where an embedded
 system ships with a LPGL licensed driver which in turn taints the
 kernel.  I suppose this was not really the intention...

diff --git a/include/linux/license.h b/include/linux/license.h
index decdbf4..9c0df0e 100644
--- a/include/linux/license.h
+++ b/include/linux/license.h
@@ -8,7 +8,10 @@ static inline int license_is_gpl_compatible(const char *license)
 		|| strcmp(license, "GPL and additional rights") == 0
 		|| strcmp(license, "Dual BSD/GPL") == 0
 		|| strcmp(license, "Dual MIT/GPL") == 0
-		|| strcmp(license, "Dual MPL/GPL") == 0);
+		|| strcmp(license, "Dual MPL/GPL") == 0
+		|| strcmp(license, "LGPL") == 0
+		|| strcmp(license, "LGPL v2") == 0
+		|| strcmp(license, "LGPL v2.1") == 0);
 }
 
 #endif
-- 
1.7.10
