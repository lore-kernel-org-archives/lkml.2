Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161882Ab1FAJMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:12:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161858Ab1FAIP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:15:27 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:10:50 2011
Message-Id: <20110601081049.690549456@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:34 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [004/165] kmemleak: Initialise kmemleak after debug_objects_mem_init()
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1022
Lines: 32

From: Catalin Marinas <catalin.marinas@arm.com>

commit 9b090f2da85bd0df5e1a1ecfe4120b7b50358f48 upstream.

Kmemleak frees objects via RCU and when CONFIG_DEBUG_OBJECTS_RCU_HEAD
is enabled, the RCU callback triggers a call to free_object() in
lib/debugobjects.c. Since kmemleak is initialised before debug objects
initialisation, it may result in a kernel panic during booting. This
patch moves the kmemleak_init() call after debug_objects_mem_init().

Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Tested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c
+++ b/init/main.c
@@ -580,8 +580,8 @@ asmlinkage void __init start_kernel(void
 #endif
 	page_cgroup_init();
 	enable_debug_pagealloc();
-	kmemleak_init();
 	debug_objects_mem_init();
+	kmemleak_init();
 	setup_per_cpu_pageset();
 	numa_policy_init();
 	if (late_time_init)


