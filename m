Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab0ELJYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 05:24:33 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:56815 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab0ELJYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 05:24:32 -0400
X-Greylist: delayed 2699 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2010 05:24:32 EDT
Date: Wed, 12 May 2010 10:39:29 +0200
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] sysctl: Allow non-root to read mmap_min_addr value
Message-ID: <20100512083929.GC21829@os.inf.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although /proc/sys/vm/mmap_min_addr has 644 permissions a read call returns
-EPERM. Allow any user to read the mmap_min_addr value.

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
---
 security/min_addr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/min_addr.c b/security/min_addr.c
index e86f297..f728728 100644
--- a/security/min_addr.c
+++ b/security/min_addr.c
@@ -33,7 +33,7 @@ int mmap_min_addr_handler(struct ctl_table *table, int write,
 {
 	int ret;
 
-	if (!capable(CAP_SYS_RAWIO))
+	if (write && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
 	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
-- 
1.7.1

