Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab0EaPDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 11:03:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43159 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab0EaPDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 11:03:41 -0400
Date: Mon, 31 May 2010 17:03:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: apw@canonical.com, linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: don't warn for space after for_each_* macros
Message-ID: <20100531150332.GA18341@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch: don't warn for space after for_each_* macros

for_each_possible_cpu and similar macros act like loops and it's natural
for them to be written like while () with a space before the paren.

Unfortunately checkpatch.pl warns about this:

WARNING: space prohibited between function name and open parenthesis '('
+       for_each_possible_cpu (cpu) {

Don't warn for all function names matching a reasonable for_each pattern.
    
 Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd88f11..c35eda2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1906,6 +1906,7 @@ sub process {
 				if|for|while|switch|return|case|
 				volatile|__volatile__|
 				__attribute__|format|__extension__|
+				([a-z]+_)?for_each_[a-z_]+|
 				asm|__asm__)$/x)
 			{
 
