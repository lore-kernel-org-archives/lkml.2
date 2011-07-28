Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1G1HWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 03:22:39 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39868 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab1G1HWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 03:22:35 -0400
Message-ID: <4E310C44.9050002@gmail.com>
Date: Thu, 28 Jul 2011 15:14:12 +0800
From: gmail <teawater@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix a argument WARN bug of scripts/checkpatch.pl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry the prev patch have the format error.  So I re-send it.

Get following error with a patch that have min_t error:
Use of uninitialized value in concatenation (.) or string at
scripts/checkpatch.pl line 1256.
WARNING:
This is because:
				}
				WARN("$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
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
-				WARN("$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
+				WARN("MINMAX",
+				     "$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
 			}
 		}
 
