Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab0I3GYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:24:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab0I3GYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:24:36 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kbuild@vger.kernel.org
Cc: Amerigo Wang <amwang@redhat.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Fix wrong source path in scripts/namespace.pl
Date: Thu, 30 Sep 2010 14:28:55 +0800
Message-Id: <1285828138-5873-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File::Find will do chdir automatically, so we need to get
the absolute patch with $File::Find::dir.

Reported-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Amerigo Wang <amwang@redhat.com>
---
 scripts/namespace.pl |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/namespace.pl b/scripts/namespace.pl
index 361d0f7..fb4e245 100755
--- a/scripts/namespace.pl
+++ b/scripts/namespace.pl
@@ -167,11 +167,11 @@ sub do_nm
 		printf STDERR "$fullname is not an object file\n";
 		return;
 	}
-	($source = $fullname) =~ s/\.o$//;
-	if (-e "$objtree$source.c" || -e "$objtree$source.S") {
-		$source = "$objtree$source";
+	($source = $basename) =~ s/\.o$//;
+	if (-e "$source.c" || -e "$source.S") {
+		$source = "$objtree$File::Find::dir/$source";
 	} else {
-		$source = "$srctree$source";
+		$source = "$srctree$File::Find::dir/$source";
 	}
 	if (! -e "$source.c" && ! -e "$source.S") {
 		# No obvious source, exclude the object if it is conglomerate
-- 
1.6.5.2

