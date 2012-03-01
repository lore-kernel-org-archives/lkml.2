Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab2CAMob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:44:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50814 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759204Ab2CAMo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:44:29 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 3/5] checkpatch: handle string concatenation in simple #defines
Date: Thu,  1 Mar 2012 12:44:08 +0000
Message-Id: <1330605850-7873-4-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330605850-7873-1-git-send-email-apw@canonical.com>
References: <1330605850-7873-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjacent strings indicate concatentation, therefore look at identifiers
directly adjacent to literal strings as strings too.  This allows us to
better detect the form below and accept it as a simple constant:

    #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ff8a84f..35189de 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2828,6 +2828,12 @@ sub process {
 			{
 			}
 
+			# Flatten any obvious string concatentation.
+			while ($dstat =~ s/("X*")\s*$Ident/$1/ ||
+			       $dstat =~ s/$Ident\s*("X*")/$1/)
+			{
+			}
+
 			my $exceptions = qr{
 				$Declare|
 				module_param_named|
-- 
1.7.9

