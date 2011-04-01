Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1DABaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 21:30:18 -0400
Received: from mail.tpi.com ([70.99.223.143]:2216 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab1DABaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 21:30:16 -0400
Message-ID: <4D952A9E.6070109@canonical.com>
Date: Thu, 31 Mar 2011 19:30:06 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Dan Kegel <dank@kegel.com>
Subject: Re: [PATCH V2] Raise default hard ulimit on number of files to 4096
References: <1301606810-11001-1-git-send-email-tim.gardner@canonical.com> <20110331143512.2bd5703b.akpm@linux-foundation.org>
In-Reply-To: <20110331143512.2bd5703b.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------010904090101000308060501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010904090101000308060501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/31/2011 03:35 PM, Andrew Morton wrote:
>
> ^^ how not to write a changelog.
>

It seemed like plagiarism to just copy Dan's argument, but now here you 
have it.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------010904090101000308060501
Content-Type: text/x-patch;
 name="0001-Raise-default-hard-ulimit-on-number-of-files-to-4096.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Raise-default-hard-ulimit-on-number-of-files-to-4096.pa";
 filename*1="tch"

>From 819066637c964290fbab058b578dadbb31ae4235 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Thu, 31 Mar 2011 15:07:48 -0600
Subject: [PATCH] Raise default hard ulimit on number of files to 4096

Apps are increasingly using more than 1024 file descriptors.
See discussion in several distro bug trackers, e.g.
BugLink: http://bugs.launchpad.net/bugs/663090
https://issues.rpath.com/browse/RPL-2054

You don't want to raise the default soft limit, since that might break
apps that use select(), but it's safe to raise the default hard limit;
that way, apps that know they need lots of file descriptors can raise their
soft limit without needing root, and without user intervention.

Ubuntu is doing this with a kernel change because they have a policy
of not changing kernel defaults in userland.

While 4096 might not be enough for *all* apps, it seems to be plenty
for the apps I've seen lately that are unhappy with 1024.

Cc: Dan Kegel <dank@kegel.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 include/asm-generic/resource.h |    2 +-
 include/linux/fs.h             |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/resource.h b/include/asm-generic/resource.h
index 587566f..61fa862 100644
--- a/include/asm-generic/resource.h
+++ b/include/asm-generic/resource.h
@@ -78,7 +78,7 @@
 	[RLIMIT_CORE]		= {              0,  RLIM_INFINITY },	\
 	[RLIMIT_RSS]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
 	[RLIMIT_NPROC]		= {              0,              0 },	\
-	[RLIMIT_NOFILE]		= {       INR_OPEN,       INR_OPEN },	\
+	[RLIMIT_NOFILE]		= {   INR_OPEN_CUR,   INR_OPEN_MAX },	\
 	[RLIMIT_MEMLOCK]	= {    MLOCK_LIMIT,    MLOCK_LIMIT },	\
 	[RLIMIT_AS]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
 	[RLIMIT_LOCKS]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 52f283c..6e1e4e6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -23,7 +23,8 @@
 
 /* Fixed constants first: */
 #undef NR_OPEN
-#define INR_OPEN 1024		/* Initial setting for nfile rlimits */
+#define INR_OPEN_CUR 1024	/* Initial setting for nfile rlimits */
+#define INR_OPEN_MAX 4096	/* Hard limit for nfile rlimits */
 
 #define BLOCK_SIZE_BITS 10
 #define BLOCK_SIZE (1<<BLOCK_SIZE_BITS)
-- 
1.7.0.4


--------------010904090101000308060501--
