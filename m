Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab1I2WW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:22:58 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53367 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753285Ab1I2WW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:22:56 -0400
Date: Thu, 29 Sep 2011 18:22:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
        rp@svcs.cs.pdx.edu
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [RELEASE] Userspace RCU 0.6.5
Message-ID: <20110929222253.GA14132@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:12:40 up 310 days,  3:15,  6 users,  load average: 0.07, 0.02,
	0.00
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

Special thanks to Paolo Bonzini, Lai Jiangshan, and Paul E. McKenney for
their very significant contribution to this release.

Changelog:
	* call_rcu: Document call_rcu requirements
	* call_rcu: fix error handling of malloc error
	* urcu call_rcu: Use RCU read-side protection for per-cpu call_rcu data
	* urcu,call_rcu: Cleanup call_rcu_data pointers before use in child
	* urcu,call_rcu: avoid create call_rcu_data for child when unneed
	* urcu,defer_rcu: Make defer_rcu encoding more compact for marker
	* urcu_defer: Use cancellation flag instead of pthread_cancel()
	* urcu,call_rcu: protects call_rcu_data_list when remove node
	* Create default call rcu data upon per-cpu call-rcu teardown
	* powerpc: use __NO_LWSYNC__ check to use appropriate lwsync/sync opcode
	* cmm: provide lightweight smp_rmb/smp_wmb on PPC
	* atomic: provide seq_cst semantics on powerpc
	* avoid leaking crdp for failed path
	* Return -EEXIST when the old cpu call_rcu_data has not been removed
	* protect writing to per_cpu_call_rcu_data[*]
	* wake up default call_rcu thread after we move the leftover callbacks
	* avoid memory leak in call_rcu_data_free()
	* urcu call_rcu: fix use after free()
	* use get_cpu_call_rcu_data() for get_call_rcu_data()
	* init maxcpus before use
	* call_rcu implementation: add missing static
	* Document QSBR interaction with mutexes
	* urcu-pointer: implement URCU_FORCE_CAST for C++ compatibility of urcu-pointer.h
	* urcu-qsbr: use rcu_thread_offline/rcu_thread_online instead of inlining them
	* Pair all_cpu call_rcu create with free
	* QSBR: add missing wakeups in synchronize_rcu code
	* cmm: do not generate code for smp_rmb/smp_wmb on x86_64
	* cmm: let per-arch files provide cmm_smp_* barriers
	* Optimize caa_get_cycles() for PowerPC64
	* lfq/lfs tests: use call_rcu
	* list: Add cds_list_first_entry
	* rculfstack/queue: define _LGPL_SOURCE around static header include
	* Add __rcu annotation (unimplemented)
	* Fix incorrect fsf address in header files
	* wfstack: push returns prior stack emptiness state
	* Make lf stack push return if the stack was empty
	* Document caa_container_of
	* urcu-bp: do not call munmap for NULL registry at exit
	* urcu libraries can directly use the _LGPL_SOURCE wfqueue
	* rculfstack: document "push"
	* Add runall.sh to tarball
	* Fix build order of liburcu-cds-common
	* Fix missing check for SYS_membarrier in map header
	* urcu-qsbr: avoid useless futex wakeups and burning CPU for long grace periods
	* api: reimplement BUILD_BUG_ON in compiler.h
	* test api cleanup: remove unused primitives
	* put thread offline while waiting for the init flag
	* urcu: move private definitions to .c file
	* urcu-bp: move private definitions to .c file
	* urcu-qsbr: move private definitions to .c file
	* rcutorture: fix rcutorture-qsbr
	* wfqueue: fix type-incorrect assignment
	* Fix tests Makefile EXTRA_DIST to use api.h
	* Fix choice of default flavour in urcu/map/urcu.h
	* api: remove list/hlist
	* api: remove arch-specific files
	* api: make api_gcc.h a superset of the other headers
	* tests api: remove atomics
	* put thread offline while waiting for the init flag
	* urcu: move private definitions to .c file
	* urcu-bp: move private definitions to .c file
	* urcu-qsbr: move private definitions to .c file
	* rcutorture: fix rcutorture-qsbr
	* wfqueue: fix type-incorrect assignment
	* Use caa_ prefix for min() and max()

Project website: http://lttng.org/urcu
Download link: http://lttng.org/files/urcu/

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
