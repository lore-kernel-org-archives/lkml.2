Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1E0NwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:52:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab1E0NwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:52:07 -0400
Date: Fri, 27 May 2011 15:52:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH trivial] Use BUILD_BUG_ON for VM_STACK_FLAGS &
 VM_STACK_INCOMPLETE_SETUP
Message-ID: <20110527135205.GF4067@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a8bef8ff has introduced BUG_ON to force that VM_STACK_FLAGS and
VM_STACK_INCOMPLETE_SETUP do not overlap.
The check is compile time so BUILD_BUG_ON is more appropriate.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 fs/exec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 5e62d26..cc10876 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -272,7 +272,7 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
 	 * use STACK_TOP because that can depend on attributes which aren't
 	 * configured yet.
 	 */
-	BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
+	BUILD_BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
 	vma->vm_end = STACK_TOP_MAX;
 	vma->vm_start = vma->vm_end - PAGE_SIZE;
 	vma->vm_flags = VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
-- 
1.7.4.4

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
