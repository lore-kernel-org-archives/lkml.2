Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186Ab2IGLbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:31:51 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:56977 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760506Ab2IGLbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:31:48 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 2/2] checksyscalls: ignore kcmp system call
Date: Fri,  7 Sep 2012 13:31:31 +0200
Message-Id: <1347017491-11354-2-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347017491-11354-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1347017491-11354-1-git-send-email-heiko.carstens@de.ibm.com>
x-cbid: 12090711-0542-0000-0000-000002F2E20D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the checksyscalls script works again it will warn about the missing
"kcmp" system call on all architectures but x86.
Since according to git commit d97b46a6 "syscalls, x86: add __NR_kcmp syscall"
only x86 is currently supported don't emit any warning for this system call.

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 scripts/checksyscalls.sh |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index fd8fa9a..c7cda79 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -194,6 +194,9 @@ cat << EOF
 #define __IGNORE_getpmsg
 #define __IGNORE_putpmsg
 #define __IGNORE_vserver
+
+/* kcmp is currently x86 only */
+#define __IGNORE_kcmp
 EOF
 }
 
-- 
1.7.10.4

