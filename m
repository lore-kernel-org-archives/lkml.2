Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1BQBwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:52:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:48606 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1BQBwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:52:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=ATpB7zygEmp3EevGoGvcDNe/bFRxYzJpIekBonhBXAiqvXinxLSq10w+v+gumCgag
	/V6nLA/fiJh2WbhnVGnQA==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Jiri Kosina <jkosina@suse.cz>, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH] memcg: clarify use_hierarchy documentation
Date: Wed, 16 Feb 2011 17:51:23 -0800
Message-Id: <1297907483-3672-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memcg code does not allow changing memory.use_hierarchy if the
parent cgroup has enabled use_hierarchy.  Update documentation to match
the code.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 Documentation/cgroups/memory.txt |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 7781857..b6ed61c 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -485,8 +485,9 @@ The feature can be disabled by
 
 # echo 0 > memory.use_hierarchy
 
-NOTE1: Enabling/disabling will fail if the cgroup already has other
-       cgroups created below it.
+NOTE1: Enabling/disabling will fail if either the cgroup already has other
+       cgroups created below it, or if the parent cgroup has use_hierarchy
+       enabled.
 
 NOTE2: When panic_on_oom is set to "2", the whole system will panic in
        case of an OOM event in any cgroup.
-- 
1.7.3.1

