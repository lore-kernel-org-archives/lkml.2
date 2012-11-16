Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2KPTmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:42:31 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:2566 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab2KPTma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:42:30 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <1353094919.14327.4.camel@lb-tlvb-eilong.il.broadcom.com>
Subject: [PATCH] checkpatch: add double empty line check
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Andy Whitcroft" <apw@canonical.com>, linux-kernel@vger.kernel.org
cc: "Joe Perches" <joe@perches.com>, netdev <netdev@vger.kernel.org>
Date: Fri, 16 Nov 2012 21:41:59 +0200
Organization: Broadcom
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-Version: 1.0
X-WSS-ID: 7CB849211QK3671414-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eilon Greenstein <eilong@broadcom.com>
---
 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 21a9f5d..7a9c153 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3579,6 +3579,13 @@ sub process {
 			WARN("EXPORTED_WORLD_WRITABLE",
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
+
+# check for double empty lines
+		if ($line =~ /^\+\s*$/ &&
+		    ($prevline =~ /^\+?\s*$/ || $rawlines[$linenr] =~ /^\s*$/)) {
+			WARN("DOUBLE_EMPTY_LINE",
+			     "One empty line should be sufficient. Consider removing this one.\n" . $herecurr);
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
-- 
1.7.9.5




