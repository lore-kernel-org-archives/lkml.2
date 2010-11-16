Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360Ab0KPMNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 07:13:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34257 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934350Ab0KPMNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:13:31 -0500
From: Dave Martin <dave.martin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Dave Martin <dave.martin@linaro.org>, Andy Whitcroft <apw@canonical.com>
Subject: [PATCH] checkpatch: Allow space before [ in the case of inline asm constraints
Date: Tue, 16 Nov 2010 12:13:16 +0000
Message-Id: <1289909596-7317-1-git-send-email-dave.martin@linaro.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the customary syntax for declaring named arguments,
such as:

    asm ("mov %[out],%[in]" : [out] "=r" (x) : [in] "r" (y));

Since :[ is comple-error-inducingly invalid syntax in other cases,
this won't create unintentional leniency for normal uses of [

Signed-off-by: Dave Martin <dave.martin@linaro.org>
---
 scripts/checkpatch.pl |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3c7fc0..2c2fa51 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1988,11 +1988,13 @@ sub process {
 #  1. with a type on the left -- int [] a;
 #  2. at the beginning of a line for slice initialisers -- [0...10] = 5,
 #  3. inside a curly brace -- = { [0...10] = 5 }
+#  4. after a colon for inline asm -- asm ("..." : [name] "constraint" (arg))
 		while ($line =~ /(.*?\s)\[/g) {
 			my ($where, $prefix) = ($-[1], $1);
 			if ($prefix !~ /$Type\s+$/ &&
 			    ($where != 0 || $prefix !~ /^.\s+$/) &&
-			    $prefix !~ /{\s+$/) {
+			    $prefix !~ /{\s+$/ &&
+			    $prefix !~ /:\s+$/) {
 				ERROR("space prohibited before open square bracket '['\n" . $herecurr);
 			}
 		}
-- 
1.7.1

