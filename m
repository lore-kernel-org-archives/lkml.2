Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab0GVPTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 11:19:41 -0400
Received: from mail4.comsite.net ([205.238.176.238]:2340 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0GVPTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 11:19:39 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=74.61.84.126;
From: Milton Miller <miltonm@bga.com>
Subject: [PATCH] setlocalversion: fix version for untaged nontip mercurial revs
To: Michal Marek <mmarek@suse.cz>, <gentoo@mgorny.alt.pl>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Message-Id: <fix-hg-id-resend1@mdm.bga.com>
Date: Thu, 22 Jul 2010 10:19:38 -0500
X-Originating-IP: 74.61.84.126
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The manpage for cut says it will return all lines without the delimiter
unless -s is specified.

When I backed up my mecurial tree to generate modules, I found that the
scm part of localversion was turning up blank.

Signed-off-by: Milton Miller <miltonm@bga.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: "Michał Górny" <gentoo@mgorny.alt.pl>

---
This version is against linux next-20100721.  The diff against 35-rc
would be shifted left one tab stop and have different line numbers, should
this be sent to stable.

Resend without 8-bit characters (maintainers name) in header
Added linux-kbuild@vger.kernel.org which get-maintainer did not

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index a7b9f76..872312f 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -86,7 +86,7 @@ scm_version()
 
 	# Check for mercurial and a mercurial repo.
 	if hgid=`hg id 2>/dev/null`; then
-		tag=`printf '%s' "$hgid" | cut -d' ' -f2`
+		tag=`printf '%s' "$hgid" | cut -s -d' ' -f2`
 
 		# Do we have an untagged version?
 		if [ -z "$tag" -o "$tag" = tip ]; then
