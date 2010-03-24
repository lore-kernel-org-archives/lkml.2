Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab0CXAgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 20:36:43 -0400
Received: from relay1.sgi.com ([192.48.179.29]:40187 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab0CXAgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 20:36:24 -0400
Message-Id: <20100324003608.811051277@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 23 Mar 2010 19:36:08 -0500
From: holt@sgi.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Rafael Wysocki <rjw@novell.com>
Subject: [patch 0/2] x86,pat: Reduce contention on the memtype_lock -V4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tracking memtype on x86 uses a single global spin_lock for either reading
or changing the memory type.  This includes changes made to page flags
which is perfectly parallel.

Part one of the patchset makes the page-based tracking use cmpxchg
without a need for a lock.

Part two of the patchset converts the spin_lock into a read/write lock.


To: Ingo Molnar <mingo@redhat.com>
To: H. Peter Anvin <hpa@zytor.com>
To: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Cc: Rafael Wysocki <rjw@novell.com>

---

 arch/x86/include/asm/cacheflush.h |   44 +++++++++++++++++++++-----------------
 arch/x86/mm/pat.c                 |   30 +++++++++----------------
 2 files changed, 36 insertions(+), 38 deletions(-)

