Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab2CURz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:55:59 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60787 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759187Ab2CURz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:55:56 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <kgdb-bugreport@lists.sourceforge.net>, <masami.hiramatsu.pt@hitachi.com>,
        <tim.bird@am.sony.com>
Subject: [PATCH 0/2] Fix KGDB to work with CONFIG_DEBUG_RODATA using kprobe API
Date: Wed, 21 Mar 2012 12:55:34 -0500
Message-ID: <1332352536-29186-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inability to use software breakpoints on a kernel built with
CONFIG_DEBUG_RODATA has been a problem for quite a few years.  The
kprobes API has been working around this limitation for a long
time. This patch set changes the debug_core to use the kprobe
breakpoint API directly for a kernel compiled with CONFIG_DEBUG_RODATA.

Comments are welcome of course.

Thanks,
Jason.

---
Jason Wessel (2):
      kgdb,debug_core: pass the breakpoint struct instead of address and memory
      kgdb,debug_core,kgdbts: End DEBUG_RODATA limitation using kprobe breakpoints

 drivers/misc/kgdbts.c     |   13 ------
 include/linux/kgdb.h      |    7 ++-
 kernel/debug/debug_core.c |   93 ++++++++++++++++++++++++++++++--------------
 3 files changed, 67 insertions(+), 46 deletions(-)
