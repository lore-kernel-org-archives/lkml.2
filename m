Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0HSONq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:13:46 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:52954 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0HSONn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:13:43 -0400
Subject: [PATCH] kernel-doc: be case insensitive when removing attributes
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 16:13:42 +0200
Message-ID: <1282227222.4507.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There are valid attributes that could have upper
case letters, but we still want to remove, like
for example
	__attribute__((aligned(NETDEV_ALIGN)))
as encountered in the wireless code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I thought we did this before? Bit confused now :)

 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/scripts/kernel-doc	2010-08-19 16:11:40.000000000 +0200
+++ wireless-testing/scripts/kernel-doc	2010-08-19 16:11:45.000000000 +0200
@@ -1679,7 +1679,7 @@ sub check_sections($$$$$$) {
 		foreach $px (0 .. $#prms) {
 			$prm_clean = $prms[$px];
 			$prm_clean =~ s/\[.*\]//;
-			$prm_clean =~ s/__attribute__\s*\(\([a-z,_\*\s\(\)]*\)\)//;
+			$prm_clean =~ s/__attribute__\s*\(\([a-z,_\*\s\(\)]*\)\)//i;
 			# ignore array size in a parameter string;
 			# however, the original param string may contain
 			# spaces, e.g.:  addr[6 + 2]


