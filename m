Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab0IKWzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 18:55:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21745 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab0IKWzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 18:55:52 -0400
Date: Sat, 11 Sep 2010 15:55:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] kernel-doc: ignore case when stripping attributes
Message-Id: <20100911155512.06af075d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---

 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2636-rc2-docs.orig/scripts/kernel-doc
+++ lnx-2636-rc2-docs/scripts/kernel-doc
@@ -1679,7 +1679,7 @@ sub check_sections($$$$$$) {
 		foreach $px (0 .. $#prms) {
 			$prm_clean = $prms[$px];
 			$prm_clean =~ s/\[.*\]//;
-			$prm_clean =~ s/__attribute__\s*\(\([a-z,_\*\s\(\)]*\)\)//;
+			$prm_clean =~ s/__attribute__\s*\(\([a-z,_\*\s\(\)]*\)\)//i;
 			# ignore array size in a parameter string;
 			# however, the original param string may contain
 			# spaces, e.g.:  addr[6 + 2]
