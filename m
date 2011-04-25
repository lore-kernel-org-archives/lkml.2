Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab1DYU2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:28:07 -0400
Received: from 1wt.eu ([62.212.114.60]:34674 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555Ab1DYU2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:28:04 -0400
Message-Id: <20110425200236.514993869@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Kamal Mostafa <kamal@canonical.com>, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 081/173] x86: Fix panic when handling "mem={invalid}" param
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kamal Mostafa <kamal@canonical.com>

commit 77eed821accf5dd962b1f13bed0680e217e49112 upstream.

Avoid removing all of memory and panicing when "mem={invalid}"
is specified, e.g. mem=blahblah, mem=0, or mem=nopentium (on
platforms other than x86_32).

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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

Index: longterm-2.6.27/arch/x86/kernel/e820.c
===================================================================
--- longterm-2.6.27.orig/arch/x86/kernel/e820.c	2011-01-23 10:52:13.265064331 +0100
+++ longterm-2.6.27/arch/x86/kernel/e820.c	2011-04-25 15:37:16.046278520 +0200
@@ -1189,6 +1189,9 @@
 
 	userdef = 1;
 	mem_size = memparse(p, &p);
+	/* don't remove all of memory when handling "mem={invalid}" param */
+	if (mem_size == 0)
+		return -EINVAL;
 	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
 	return 0;


