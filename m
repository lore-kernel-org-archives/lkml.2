Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1BBAm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:42:27 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:53794 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab1BBAm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:42:26 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/checkpatch.pl: reset rpt_cleaners warnings
Date: Tue,  1 Feb 2011 19:42:39 -0500
Message-Id: <1296607359-19332-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1294656834-6293-1-git-send-email-vapier@gentoo.org>
References: <1294656834-6293-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you run checkpatch against multiple patches, and one of them has a
whitespace issue which can be helped via a script (rpt_cleaners), you
will see the same NOTE over and over for all subsequent patches.  It
makes it seem like those patches also have whitespace problems when in
reality, there's only one or two bad apples.

So reset rpt_cleaners back to 0 after we've issued the note so that it
only shows up near the patch with the actual problems.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
Andrew: could you pick this up ?  was sent out a few weeks ago ...

 scripts/checkpatch.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3c7fc0..94aba76 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2934,6 +2934,7 @@ sub process {
 		if ($rpt_cleaners) {
 			print "NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or\n";
 			print "      scripts/cleanfile\n\n";
+			$rpt_cleaners = 0;
 		}
 	}
 
-- 
1.7.4

