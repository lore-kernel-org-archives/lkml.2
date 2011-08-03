Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab1HCCg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 22:36:28 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61682 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab1HCCgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 22:36:21 -0400
Message-ID: <4E38B41F.9070807@gmail.com>
Date: Wed, 03 Aug 2011 10:36:15 +0800
From: Hui Zhu <teawater@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, "Joe Perches joe"@perches.com
CC: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix a argument WARN bug of scripts/checkpatch.pl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Thanks for your help.

Best,
Hui

The following part is the original patch:

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
Acked-by: Joe Perches <joe@perches.com>
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
