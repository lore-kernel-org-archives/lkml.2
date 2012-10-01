Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab2JAXAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:00:14 -0400
Received: from 1wt.eu ([62.212.114.60]:35093 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932624Ab2JAXAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:11 -0400
Message-Id: <20121001225201.545241358@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 093/180] stable: Allow merging of backports for serious user-visible performance issues
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit eb3979f64d25120d60b9e761a4c58f70b1a02f86 upstream.

Distribution kernel maintainers routinely backport fixes for users that
were deemed important but not "something critical" as defined by the
rules. To users of these kernels they are very serious and failing to fix
them reduces the value of -stable.

The problem is that the patches fixing these issues are often subtle and
prone to regressions in other ways and need greater care and attention.
To combat this, these "serious" backports should have a higher barrier
to entry.

This patch relaxes the rules to allow a distribution maintainer to merge
to -stable a backported patch or small series that fixes a "serious"
user-visible performance issue. They should include additional information on
the user-visible bug affected and a link to the bugzilla entry if available.
The same rules about the patch being already in mainline still apply.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 Documentation/stable_kernel_rules.txt |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index e6e482f..3c9d7ac 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -12,6 +12,12 @@ Rules on what kind of patches are accepted, and which ones are not, into the
    marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
    security issue, or some "oh, that's not good" issue.  In short, something
    critical.
+ - Serious issues as reported by a user of a distribution kernel may also
+   be considered if they fix a notable performance or interactivity issue.
+   As these fixes are not as obvious and have a higher risk of a subtle
+   regression they should only be submitted by a distribution kernel
+   maintainer and include an addendum linking to a bugzilla entry if it
+   exists and additional information on the user-visible impact.
  - New device IDs and quirks are also accepted.
  - No "theoretical race condition" issues, unless an explanation of how the
    race can be exploited is also provided.
-- 
1.7.2.1.45.g54fbc



