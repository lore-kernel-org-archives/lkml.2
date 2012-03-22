Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353Ab2CVPaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 11:30:35 -0400
Received: from smtp.nokia.com ([147.243.1.48]:48430 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab2CVPad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 11:30:33 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: apw@canonical.com
Cc: hpa@zytor.com, ext-phil.2.carmody@nokia.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in function declarations
Date: Thu, 22 Mar 2012 17:27:18 +0200
Message-Id: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.5
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After HPA's wonderful lkml post, referenced, it seems worth trying to
detect this robomatically.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 scripts/checkpatch.pl |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a3b9782..3993011 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1881,6 +1881,10 @@ sub process {
 				substr($ctx, 0, $name_len + 1, '');
 				$ctx =~ s/\)[^\)]*$//;
 
+				if ($ctx =~ /^\s*(?:\.\.\.)?\s*$/) {
+					# HPA explains why: http://lwn.net/Articles/487493/
+					ERROR("(...) and () are not sufficiently informative function declarations\n$hereline");
+				}
 				for my $arg (split(/\s*,\s*/, $ctx)) {
 					if ($arg =~ /^(?:const\s+)?($Ident)(?:\s+$Sparse)*\s*\**\s*(:?\b$Ident)?$/s || $arg =~ /^($Ident)$/s) {
 
-- 
1.7.2.5

