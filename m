Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0K3QWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:22:13 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:45829 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0K3QWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:22:12 -0500
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-kernel@vger.kernel.org
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, WANG Cong <amwang@redhat.com>
Subject: [PATCH] headers_check: better search for functions in headers
Date: Tue, 30 Nov 2010 18:21:59 +0200
Message-Id: <1291134119-12903-1-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.1.45.gb66c2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some headers don't bother with "extern" in function prototypes,
which results in said prototypes being unnoticed and exported
to userland.

This patch slightly improves detection of such cases by checking
for C type names as well in the beginning of a line.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Stephen Hemminger <shemminger@vyatta.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Marek <mmarek@suse.cz>
CC: WANG Cong <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org
---
 scripts/headers_check.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 50d6cfd..e0e25a1 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -64,7 +64,7 @@ sub check_include
 
 sub check_declarations
 {
-	if ($line =~m/^\s*extern\b/) {
+	if ($line =~m/^(\s*extern|unsigned|char|short|int|long|void)\b/) {
 		printf STDERR "$filename:$lineno: " .
 		              "userspace cannot call function or variable " .
 		              "defined in the kernel\n";
-- 
1.7.2.1.45.gb66c2

