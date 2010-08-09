Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab0HIFNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 01:13:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:39138 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0HIFNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 01:13:15 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [RFC PATCH 0/2] RCU stall handler for kernel debugger
Date: Mon,  9 Aug 2010 00:12:10 -0500
Message-Id: <1281330732-17164-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 09 Aug 2010 05:12:47.0897 (UTC) FILETIME=[81D8D090:01CB3781]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this short series is to allow the kernel debugger to
reset the rcu stall timer when restarting the normal kernel execution
so as to prevent the rcu stall timer from issuing NMIs to print stack
traces that should be ignored because the kernel went away for a
while.

---
Jason Wessel (2):
      debug_core: move all watch dog syncs to a single function
      rcu,debug_core: allow the kernel debugger to reset the rcu stall timer

 include/linux/rcupdate.h  |    8 ++++++++
 kernel/debug/debug_core.c |   17 +++++++++++------
 kernel/rcutree.c          |    9 +++++++++
 3 files changed, 28 insertions(+), 6 deletions(-)
