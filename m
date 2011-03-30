Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965083Ab1C3VaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:30:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:51305 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965034Ab1C3VI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238208"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: kamal@canonical.com, ak@linux.intel.com, yinghai@kernel.org,
        len.brown@intel.com, rjw@sisk.pl, mingo@elte.hu, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [190/275] x86: Fix panic when handling "mem={invalid}" param
Message-Id: <20110330210713.BC6583E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Kamal Mostafa <kamal@canonical.com>

commit 77eed821accf5dd962b1f13bed0680e217e49112 upstream.

Avoid removing all of memory and panicing when "mem={invalid}"
is specified, e.g. mem=blahblah, mem=0, or mem=nopentium (on
platforms other than x86_32).

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
BugLink: http://bugs.launchpad.net/bugs/553464
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
LKML-Reference: <1296783486-23033-1-git-send-email-kamal@canonical.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/e820.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.35.y/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/e820.c	2011-03-29 22:50:45.435095848 -0700
+++ linux-2.6.35.y/arch/x86/kernel/e820.c	2011-03-29 23:54:16.526579552 -0700
@@ -989,6 +989,9 @@
 
 	userdef = 1;
 	mem_size = memparse(p, &p);
+	/* don't remove all of memory when handling "mem={invalid}" param */
+	if (mem_size == 0)
+		return -EINVAL;
 	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
 	return 0;
