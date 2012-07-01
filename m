Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab2GASY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:24:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46981 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932297Ab2GASQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:38 -0400
Message-Id: <20120701172012.497088271@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 41/48] stable: Allow merging of backports for serious user-visible
 performance issues
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/stable_kernel_rules.txt |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index f0ab5cf..4a7b54b 100644
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


