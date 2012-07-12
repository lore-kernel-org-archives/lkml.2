Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161943Ab2GLXbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:31:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161853Ab2GLWk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>
Subject: [ 087/187] stable: Allow merging of backports for serious user-visible performance issues
Date: Thu, 12 Jul 2012 15:34:03 -0700
Message-Id: <20120712191530.464556981@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 Documentation/stable_kernel_rules.txt |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -12,6 +12,12 @@ Rules on what kind of patches are accept
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


