Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560Ab2IGLbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:31:50 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:48820 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2IGLbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:31:45 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 1/2] checksyscalls: fix "here document" handling
Date: Fri,  7 Sep 2012 13:31:30 +0200
Message-Id: <1347017491-11354-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
x-cbid: 12090711-1948-0000-0000-000002E42CE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"echo" doesn't read from stdin, therefore the checksyscalls script didn't warn
about not implemented system calls anymore since 29dc54c6 "checksyscalls: Use
arch/x86/syscalls/syscall_32.tbl as source".

Use "cat" instead of "echo" which handles this correctly.

Cc: Michal Marek <mmarek@suse.cz>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 scripts/checksyscalls.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index d24810f..fd8fa9a 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -200,7 +200,7 @@ EOF
 syscall_list() {
     grep '^[0-9]' "$1" | sort -n | (
 	while read nr abi name entry ; do
-	    echo <<EOF
+	    cat <<EOF
 #if !defined(__NR_${name}) && !defined(__IGNORE_${name})
 #warning syscall ${name} not implemented
 #endif
-- 
1.7.10.4

