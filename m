Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab2KQLSG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 06:18:06 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1682 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab2KQLSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 06:18:04 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <1353151057.14327.18.camel@lb-tlvb-eilong.il.broadcom.com>
Subject: [PATCH v2] checkpatch: add double empty line check
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Andy Whitcroft" <apw@canonical.com>
cc: "Joe Perches" <joe@perches.com>, "David Rientjes" <rientjes@google.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Date: Sat, 17 Nov 2012 13:17:37 +0200
Organization: Broadcom
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-Version: 1.0
X-WSS-ID: 7CB9AEE43P84215914-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from previous attempt:
- Use CHK instead of WARN
- Issue only one warning per empty lines block

Signed-off-by: Eilon Greenstein <eilong@broadcom.com>
---
 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 21a9f5d..13d264f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3579,6 +3579,14 @@ sub process {
 			WARN("EXPORTED_WORLD_WRITABLE",
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
+
+# check for double empty lines
+		if ($line =~ /^\+\s*$/ &&
+		    ($rawlines[$linenr] =~ /^\s*$/ ||
+		     $prevline =~ /^\+?\s*$/ && $rawlines[$linenr] !~ /^\+\s*$/)) {
+			CHK("DOUBLE_EMPTY_LINE",
+			    "One empty line should be sufficient. Consider removing this one.\n" . $herecurr);
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
-- 
1.7.9.5




