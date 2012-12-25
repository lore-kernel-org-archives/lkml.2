Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab2LYQXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 11:23:45 -0500
Received: from re04.intra2net.com ([82.165.46.26]:54091 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2LYQXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 11:23:43 -0500
Message-ID: <50D9D30B.8090002@intra2net.com>
Date: Tue, 25 Dec 2012 17:23:39 +0100
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org
Subject: [perf PATCH] Fix possible (unlikely) buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck reported:
[tools/perf/util/sysfs.c:50]: (error) Width 4096 given in format string
(no. 1) is larger than destination buffer 'sysfs_mountpoint[4096]',
use %4095s to prevent overflowing it

-> All other places in the kernel that use STR(PATH_MAX)
   have a buffer size of PATH_MAX+1.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 tools/perf/util/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sysfs.c b/tools/perf/util/sysfs.c
index 48c6902..606f884 100644
--- a/tools/perf/util/sysfs.c
+++ b/tools/perf/util/sysfs.c
@@ -8,7 +8,7 @@ static const char * const sysfs_known_mountpoints[] = {
 };
 
 static int sysfs_found;
-char sysfs_mountpoint[PATH_MAX];
+char sysfs_mountpoint[PATH_MAX+1];
 
 static int sysfs_valid_mountpoint(const char *sysfs)
 {
-- 
1.7.11.7

