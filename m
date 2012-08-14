Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab2HNPVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:21:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:16720 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab2HNPVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:21:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,766,1336374000"; 
   d="scan'208";a="200761812"
Date: Tue, 14 Aug 2012 23:21:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH] h8300: select generic atomic64_t support
Message-ID: <20120814152146.GA17979@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rationals from Eric:

So I just looked a little deeper and it appears architectures that do
not support atomic64_t are broken.

The generic atomic64 support came in 2009 to support the perf subsystem
with the expectation that all architectures would implement atomic64
support.

Furthermore upon inspection of the kernel atomic64_t is used in a fair
number of places beyond the performance counters:

block/blk-cgroup.c
drivers/acpi/apei/
drivers/block/rbd.c
drivers/crypto/nx/nx.h
drivers/gpu/drm/radeon/radeon.h
drivers/infiniband/hw/ipath/
drivers/infiniband/hw/qib/
drivers/staging/octeon/
fs/xfs/
include/linux/perf_event.h
include/net/netfilter/nf_conntrack_acct.h
kernel/events/
kernel/trace/
net/mac80211/key.h
net/rds/

The block control group, infiniband, xfs, crypto, 802.11, netfilter.
Nothing quite so fundamental as fs/namespace.c but definitely in
multiplatform-code that should work, and is already broken on those
architecutres.

Looking at the implementation of atomic64_add_return in lib/atomic64.c
the code looks as efficient as these kinds of things get.

Which leads me to the conclusion that we need atomic64 support on all
architectures.

CC: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/h8300/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux.orig/arch/h8300/Kconfig	2012-08-03 15:36:21.379560778 +0800
+++ linux/arch/h8300/Kconfig	2012-08-14 22:52:50.931795265 +0800
@@ -6,6 +6,7 @@ config H8300
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
+	select GENERIC_ATOMIC64
 
 config SYMBOL_PREFIX
 	string
