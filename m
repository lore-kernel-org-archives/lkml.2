Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1G1G5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 02:57:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43820 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab1G1G5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 02:57:12 -0400
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Thu, 28 Jul 2011 14:56:31 +0800
Message-ID: <CANFwon10jhjR2_D+M-8SE65jQ-O-XydYtyoQt-bvVAdhS_Q5wA@mail.gmail.com>
Subject: [PATCH] Fix a argument WARN bug of scripts/checkpatch.pl
To: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get following error with a patch that have min_t error:
Use of uninitialized value in concatenation (.) or string at
scripts/checkpatch.pl line 1256.
WARNING:
This is because:
				}
				WARN("$call() should probably be ${call}_t($cast, $arg1, $arg2)\n"
. $herecurr);
			}
It lost the first argument.
So make a patch to fix it.

Signed-off-by: Hui Zhu <teawater@gmail.com>
---
 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2574,7 +2574,8 @@ sub process {
 				} else {
 					$cast = $cast2;
 				}
-				WARN("$call() should probably be ${call}_t($cast, $arg1,
$arg2)\n" . $herecurr);
+				WARN("MINMAX",
+				     "$call() should probably be ${call}_t($cast, $arg1,
$arg2)\n" . $herecurr);
 			}
 		}
