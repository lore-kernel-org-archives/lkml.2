Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161105Ab1FAIGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:06:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:43020 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933260Ab1FAIGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:06:25 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:02:28 2011
Message-Id: <20110601080227.610371509@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:58:58 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [002/146] kmemleak: Initialise kmemleak after debug_objects_mem_init()
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

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
@@ -668,8 +668,8 @@ asmlinkage void __init start_kernel(void
 #endif
 	page_cgroup_init();
 	enable_debug_pagealloc();
-	kmemleak_init();
 	debug_objects_mem_init();
+	kmemleak_init();
 	setup_per_cpu_pageset();
 	numa_policy_init();
 	if (late_time_init)


