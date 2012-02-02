Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab2BBC25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:28:57 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:48646 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab2BBC2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:28:55 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM/Freezer/Docs: Document the beauty of freeze/thaw semantics
To: rjw@sisk.pl
Cc: tj@kernel.org, pavel@ucw.cz, len.brown@intel.com, rdunlap@xenotime.net,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 02 Feb 2012 07:58:33 +0530
Message-ID: <20120202022829.13341.64259.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12020116-1618-0000-0000-000000AFE747
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way the different freeze/thaw functions encapsulate each other are quite
lovely from a design point of view. And as a side-effect, the way in which
they are invoked (cleaning up on failure for example) differs significantly
from how usual functions are dealt with. This is because of the underlying
semantics that govern the freezing and thawing of various tasks.

This subtle aspect that differentiates these functions from the rest, is
worth documenting.

Many thanks to Tejun Heo for providing enlightenment on this topic.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 Documentation/power/freezing-of-tasks.txt |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/freezing-of-tasks.txt b/Documentation/power/freezing-of-tasks.txt
index ebd7490..ec715cd 100644
--- a/Documentation/power/freezing-of-tasks.txt
+++ b/Documentation/power/freezing-of-tasks.txt
@@ -63,6 +63,27 @@ devices have been reinitialized, the function thaw_processes() is called in
 order to clear the PF_FROZEN flag for each frozen task.  Then, the tasks that
 have been frozen leave __refrigerator() and continue running.
 
+
+Rationale behind the functions dealing with freezing and thawing of tasks:
+-------------------------------------------------------------------------
+
+freeze_processes():
+  - freezes only userspace tasks
+
+freeze_kernel_threads():
+  - freezes all tasks (including kernel threads) because we can't freeze
+    kernel threads without freezing userspace tasks
+
+thaw_kernel_threads():
+  - thaws only kernel threads; this is particularly useful if we need to do
+    anything special in between thawing of kernel threads and thawing of
+    userspace tasks, or if we want to postpone the thawing of userspace tasks
+
+thaw_processes():
+  - thaws all tasks (including kernel threads) because we can't thaw userspace
+    tasks without thawing kernel threads
+
+
 III. Which kernel threads are freezable?
 
 Kernel threads are not freezable by default.  However, a kernel thread may clear

