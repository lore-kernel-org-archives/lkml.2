Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab2EUXGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:06:47 -0400
Received: from mail.openrapids.net ([64.15.138.104]:52674 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932507Ab2EUXGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:06:44 -0400
Date: Mon, 21 May 2012 19:06:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: [RELEASE] Userspace RCU 0.7.0
Message-ID: <20120521230640.GA18601@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library. This
data synchronization library provides read-side access which scales
linearly with the number of cores. It does so by allowing multiples
copies of a given data structure to live at the same time, and by
monitoring the data structure accesses to detect grace periods after
which memory reclamation is possible.

liburcu-cds (cds: concurrent data structures) provides efficient data
containers based on RCU and lock-free algorithms. Those structures
include hash tables, queues, stacks, and doubly-linked lists.


* New in this release:

The major feature added in this release is the RCU Lock-Free Resizable
Hash Table (API: urcu/rculfhash.h). This hash table scales very well to
many cores for updates on different keys, is cache-efficient, uses RCU
for lookups and traversals, provides ordering guarantees for updates vs
reads, and uniqueness guarantees for uniquify and replace operations vs
RCU traversals. It automatically resizes when the hash chains become too
dense. For more information, please refer to the slides of the following
presentation: http://www.efficios.com/lpc2011-urcu . The source code
also contains extensive explanation of the hash table architecture.

Also new in this release: a fallback for compilers that do not support
__thread TLS has been implemented, which should enable support for
Android, NetBSD, Darwin, and OpenBSD. (Feedback about your experience
with userspace RCU on those platforms is welcome. Following sufficient
positive feedback, I will consider adding those to the list of supported
OS in the README.)


Changelog:
2012-05-21 Userspace RCU 0.7.0
        * Cleanup: header comments coding style
        * Document uatomic operations
        * Update return value of "set" operations
        * Fix mremap wrapper for NetBSD 5
        * Use urcu/tls-compat.h
        * Implement urcu/tls-compat.h
        * Add TLS detection m4 macro
        * document concurrent data structures
        * documentation: refer to rcu-api.txt
        * Move API.txt to doc/rcu-api.txt, install in system doc/
        * rculfhash: document implied memory barriers
        * rculfhash: Ensure future-proof memory barrier semantic consistency
        * API cleanup: use "uatomic_*" in cmm_smp_mb__ API
        * uatomic: add memory barrier API for and/or/add/sub/inc/sub
        * rculfhash: add runhash.sh test script
        * rculfhash tests: add missing check
        * rculfhash: fix: race between replace and del operations
        * rculfhash: replace unneeded rcu_dereference by CMM_LOAD_SHARED
        * rculfhash: use do {} while (0) for dbg_printf()
        * rculfhash: cleanup typo
        * rculfhash: update API comments
        * rculfhash: update comments in implementation
        * rculfhash tests: add long hash chains tests
        * rculfhash tests: add uniqueness test
        * rculfhash test: print test name
        * rculfhash: stress requirement in documentation
        * rculfhash: fix typo
        * rculfhash tests: use array of callbacks to modularize
        * rculfhash tests: modularize tests
        * rculfhash: document ordering guarantees
        * rculfhash: document linearizability guarantees
        * rculfhash: update removal comment
        * Add missing files to .gitignore
        * Fix out-of-tree build
        * rculfhash: check malloc NULL pointer
        * Fix uatomic sign cast
        * Remove unused jhash.h file
        * Fix: use known license text, fix incorrect FSF address
        * Fix: add missing sched.h include in rculfhash.c
        * Allow tests to run on architectures without per-cpu call_rcu support
        * Hash table test: FreeBSD compatibility fix
        * tests: define _GNU_SOURCE instead of __USE_GNU
        * RCU lock-free hash table: implement cds_lfht_is_node_deleted()
        * Define _GNU_SOURCE to access CPU_ZERO() macro in uClibc
        * Install ChangeLog and README into system's doc
        * Fix AC_LANG_SOURCE usage: only takes one parameter
        * Fix autoconf futex check
        * configure.ac: Use AC_LANG_SOURCE for if else macros
        * Refresh autoconf files
        * Update gitignore
        * rculfhash: add comment about hash seed randomness within test program
        * readme: state correct GCC dependency for ARM
        * rculfhash: remove an invocation of bit_reverse_ulong() when adding
        * rculfhash: remove unneeded conversion
        * rculfhash: remove unneeded clear_flag()
        * cds_lfht_replace: add checks for old/new node hash/value match
        * rculfhash: use node instead of iter argument for deletion
        * rculfhash: number of logically removed nodes should not appear in API
        * Document that flags could be represented on 2 bits
        * Add missing REMOVAL_OWNER_FLAG comment to cds_lfht_node comment
        * _cds_lfht_del is not used for buckets anymore, remove parameter
        * rculfhash: Relax atomicity guarantees required by removal operation
        * remove unneeded "return;"
        * simplify the deletion for bucket node
        * Remove unneeded code
        * Cleanup DEFINE_RCU_FLAVOR()
        * Add cds_lfht_ prefix to fls_ulong, get_count_order_ulong, get_count_order_u32
        * Merge RCU Lock-Free Resizable Hash Table

Project website: http://lttng.org/urcu
Download link: http://lttng.org/files/urcu/

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
