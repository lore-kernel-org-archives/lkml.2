Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab2CSPXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:23:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51316 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab2CSPXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:23:23 -0400
Date: Mon, 19 Mar 2012 16:23:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.4
Message-ID: <20120319152317.GA3932@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

   HEAD: bdd4431c8d071491a68a65d9457996f222b5ecd3 Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      rcu: Improve synchronize_rcu() diagnostics

Heiko Carstens (1):
      rcu: Convert WARN_ON_ONCE() in rcu_lock_acquire() to lockdep

Hugh Dickins (1):
      rcu: Stop spurious warnings from synchronize_sched_expedited

Julia Lawall (1):
      PTR_ERR should be called before its argument is cleared.

Paul E. McKenney (44):
      rcu: Bring RTFP.txt up to date.
      rcu: Add lockdep-RCU checks for simple self-deadlock
      rcu: Add diagnostic for misaligned rcu_head structures
      rcu: Avoid waking up CPUs having only kfree_rcu() callbacks
      rcu: Move RCU_TRACE to lib/Kconfig.debug
      s390: Convert call_rcu() to kfree_rcu(), drop ext_int_hash_update()
      tcm_fc: Convert call_rcu() to kfree_rcu(), drop ft_tport_rcu_free()
      ipv4: Convert call_rcu() to kfree_rcu(), drop opt_kfree_rcu()
      ipv4: Convert call_rcu() to kfree_rcu(), drop opt_kfree_rcu
      mac80211: Convert call_rcu() to kfree_rcu(), drop mesh_gate_node_reclaim()
      rcu: Simplify offline processing
      rcu: Make rcutorture flag online/offline failures
      rcu: Limit lazy-callback duration
      rcu: Check for callback invocation from offline CPUs
      rcu: Don't make callbacks go through second full grace period
      rcu: Remove single-rcu_node optimization in rcu_start_gp()
      rcu: Protect __rcu_read_unlock() against scheduler-using irq handlers
      rcu: Streamline code produced by __rcu_read_unlock()
      rcu: Prevent RCU callbacks from executing before scheduler initialized
      rcu: Inform RCU of irq_exit() activity
      rcu: Simplify unboosting checks
      rcu: Clean up straggling rcu_preempt_needs_cpu() name
      rcu: Check for idle-loop entry while in RCU read-side critical section
      rcu: Make rcu_sleep_check() also check rcu_lock_map
      rcu: Note that rcu_access_pointer() can be used for teardown
      rcu: Remove #ifdef CONFIG_SMP from TREE_RCU
      rcu: Set RCU CPU stall times via sysfs
      rcu: Print scheduling-clock information on RCU CPU stall-warning messages
      rcutorture: Permit holding off CPU-hotplug operations during boot
      rcu: Make documentation give more realistic rcutorture duration
      rcu: Add CPU-stall capability to rcutorture
      rcu: Update stall-warning documentation
      rcu: Check for illegal use of RCU from offlined CPUs
      rcu: Move synchronize_sched_expedited() to rcutree.c
      rcu: No interrupt disabling for rcu_prepare_for_idle()
      lockdep: Add CPU-idle/offline warning to lockdep-RCU splat
      rcu: Rework detection of use of RCU by offline CPUs
      rcu: Call out dangers of expedited RCU primitives
      rcu: Trace only after NULL-pointer check
      rcu: Remove redundant check for rcu_head misalignment
      rcu: Allow nesting of rcu_idle_enter() and rcu_idle_exit()
      rcu: Add RCU_NONIDLE() for idle-loop RCU read-side critical sections
      rcu: Eliminate softirq-mediated RCU_FAST_NO_HZ idle-entry loop
      rcu: Hold off RCU_FAST_NO_HZ after timer posted


 Documentation/RCU/RTFP.txt       | 1902 ++++++++++++++++++++++++++++++++++----
 Documentation/RCU/checklist.txt  |   14 +
 Documentation/RCU/stallwarn.txt  |   87 ++-
 Documentation/RCU/torture.txt    |   33 +-
 Documentation/RCU/trace.txt      |   36 +-
 arch/s390/kernel/irq.c           |    9 +-
 drivers/target/tcm_fc/tfc_sess.c |   12 +-
 include/linux/rcupdate.h         |   83 ++-
 include/linux/rcutiny.h          |   10 +-
 include/linux/rcutree.h          |   19 +
 include/linux/sched.h            |    3 +-
 include/linux/srcu.h             |   15 +-
 include/trace/events/rcu.h       |   63 +-
 init/Kconfig                     |    9 -
 kernel/lockdep.c                 |    8 +-
 kernel/rcu.h                     |   26 +-
 kernel/rcupdate.c                |    5 +
 kernel/rcutiny.c                 |   26 +-
 kernel/rcutiny_plugin.h          |   77 ++-
 kernel/rcutorture.c              |   91 ++-
 kernel/rcutree.c                 |  507 ++++++++---
 kernel/rcutree.h                 |   27 +-
 kernel/rcutree_plugin.h          |  450 ++++++----
 kernel/rcutree_trace.c           |   12 +-
 kernel/srcu.c                    |   33 +-
 lib/Kconfig.debug                |   24 +
 net/ipv4/cipso_ipv4.c            |   11 +-
 net/ipv4/ip_sockglue.c           |    7 +-
 net/mac80211/mesh_pathtbl.c      |    8 +-
 29 files changed, 2965 insertions(+), 642 deletions(-)

diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
index c43460d..7c1dfb1 100644
--- a/Documentation/RCU/RTFP.txt
+++ b/Documentation/RCU/RTFP.txt
@@ -1,9 +1,10 @@
-Read the F-ing Papers!
+Read the Fscking Papers!
 
 
 This document describes RCU-related publications, and is followed by
 the corresponding bibtex entries.  A number of the publications may
-be found at http://www.rdrop.com/users/paulmck/RCU/.
+be found at http://www.rdrop.com/users/paulmck/RCU/.  For others, browsers
+and search engines will usually find what you are looking for.
 
 The first thing resembling RCU was published in 1980, when Kung and Lehman
 [Kung80] recommended use of a garbage collector to defer destruction
@@ -160,7 +161,26 @@ which Mathieu Desnoyers is now maintaining [MathieuDesnoyers2009URCU]
 [MathieuDesnoyersPhD].  TINY_RCU [PaulEMcKenney2009BloatWatchRCU] made
 its appearance, as did expedited RCU [PaulEMcKenney2009expeditedRCU].
 The problem of resizeable RCU-protected hash tables may now be on a path
-to a solution [JoshTriplett2009RPHash].
+to a solution [JoshTriplett2009RPHash].  A few academic researchers are now
+using RCU to solve their parallel problems [HariKannan2009DynamicAnalysisRCU].
+
+2010 produced a simpler preemptible-RCU implementation
+based on TREE_RCU [PaulEMcKenney2010SimpleOptRCU], lockdep-RCU
+[PaulEMcKenney2010LockdepRCU], another resizeable RCU-protected hash
+table [HerbertXu2010RCUResizeHash] (this one consuming more memory,
+but allowing arbitrary changes in hash function, as required for DoS
+avoidance in the networking code), realization of the 2009 RCU-protected
+hash table with atomic node move [JoshTriplett2010RPHash], an update on
+the RCU API [PaulEMcKenney2010RCUAPI].
+
+2011 marked the inclusion of Nick Piggin's fully lockless dentry search
+[LinusTorvalds2011Linux2:6:38:rc1:NPigginVFS], an RCU-protected red-black
+tree using software transactional memory to protect concurrent updates
+(strange, but true!) [PhilHoward2011RCUTMRBTree], yet another variant of
+RCU-protected resizeable hash tables [Triplett:2011:RPHash], the 3.0 RCU
+trainwreck [PaulEMcKenney2011RCU3.0trainwreck], and Neil Brown's "Meet the
+Lockers" LWN article [NeilBrown2011MeetTheLockers].
+
 
 Bibtex Entries
 
@@ -173,6 +193,14 @@ Bibtex Entries
 ,volume="5"
 ,number="3"
 ,pages="354-382"
+,note="Available:
+\url{http://portal.acm.org/citation.cfm?id=320619&dl=GUIDE,}
+[Viewed December 3, 2007]"
+,annotation={
+	Use garbage collector to clean up data after everyone is done with it.
+	.
+	Oldest use of something vaguely resembling RCU that I have found.
+}
 }
 
 @techreport{Manber82
@@ -184,6 +212,31 @@ Bibtex Entries
 ,number="82-01-01"
 ,month="January"
 ,pages="28"
+,annotation={
+	.
+	Superseded by Manber84.
+	.
+	Describes concurrent AVL tree implementation.  Uses a
+	garbage-collection mechanism to handle concurrent use and deletion
+	of nodes in the tree, but lacks the summary-of-execution-history
+	concept of read-copy locking.
+	.
+	Keeps full list of processes that were active when a given
+	node was to be deleted, and waits until all such processes have
+	-terminated- before allowing this node to be reused.  This is
+	not described in great detail -- one could imagine using process
+	IDs for this if the ID space was large enough that overlapping
+	never occurred.
+	.
+	This restriction makes this algorithm unsuitable for use in
+	systems comprised of long-lived processes.  It also produces
+	completely unacceptable overhead in systems with large numbers
+	of processes.  Finally, it is specific to AVL trees.
+	.
+	Cites Kung80, so not an independent invention, but the first
+	RCU-like usage that does not rely on an automatic garbage
+	collector.
+}
 }
 
 @article{Manber84
@@ -195,6 +248,74 @@ Bibtex Entries
 ,volume="9"
 ,number="3"
 ,pages="439-455"
+,annotation={
+	Describes concurrent AVL tree implementation.  Uses a
+	garbage-collection mechanism to handle concurrent use and deletion
+	of nodes in the tree, but lacks the summary-of-execution-history
+	concept of read-copy locking.
+	.
+	Keeps full list of processes that were active when a given
+	node was to be deleted, and waits until all such processes have
+	-terminated- before allowing this node to be reused.  This is
+	not described in great detail -- one could imagine using process
+	IDs for this if the ID space was large enough that overlapping
+	never occurred.
+	.
+	This restriction makes this algorithm unsuitable for use in
+	systems comprised of long-lived processes.  It also produces
+	completely unacceptable overhead in systems with large numbers
+	of processes.  Finally, it is specific to AVL trees.
+}
+}
+
+@Conference{RichardRashid87a
+,Author="Richard Rashid and Avadis Tevanian and Michael Young and
+David Golub and Robert Baron and David Black and William Bolosky and
+Jonathan Chew"
+,Title="Machine-Independent Virtual Memory Management for Paged
+Uniprocessor and Multiprocessor Architectures"
+,Booktitle="{2\textsuperscript{nd} Symposium on Architectural Support
+for Programming Languages and Operating Systems}"
+,Publisher="Association for Computing Machinery"
+,Month="October"
+,Year="1987"
+,pages="31-39"
+,Address="Palo Alto, CA"
+,note="Available:
+\url{http://www.cse.ucsc.edu/~randal/221/rashid-machvm.pdf}
+[Viewed February 17, 2005]"
+,annotation={
+	Describes lazy TLB flush, where one waits for each CPU to pass
+	through a scheduling-clock interrupt before reusing a given range
+	of virtual address.  Does not describe how one determines that
+	all CPUs have in fact taken such an interrupt, though there are
+	no shortage of straightforward methods for accomplishing this.
+	.
+	Note that it does not make sense to just wait a fixed amount of
+	time, since a given CPU might have interrupts disabled for an
+	extended amount of time.
+}
+}
+
+@article{BarbaraLiskov1988ArgusCACM
+,author = {Barbara Liskov}
+,title = {Distributed programming in {Argus}}
+,journal = {Commun. ACM}
+,volume = {31}
+,number = {3}
+,year = {1988}
+,issn = {0001-0782}
+,pages = {300--312}
+,doi = {http://doi.acm.org/10.1145/42392.42399}
+,publisher = {ACM}
+,address = {New York, NY, USA}
+,annotation= {
+	At the top of page 307: "Conflicts with deposits and withdrawals
+	are necessary if the reported total is to be up to date.  They
+	could be avoided by having total return a sum that is slightly
+	out of date."  Relies on semantics -- approximate numerical
+	values sometimes OK.
+}
 }
 
 @techreport{Hennessy89
@@ -216,6 +337,13 @@ Bibtex Entries
 ,year="1990"
 ,number="CS-TR-2222.1"
 ,month="June"
+,annotation={
+	Concurrent access to skip lists.  Has both weak and strong search.
+	Uses concept of ``garbage queue'', but has no real way of cleaning
+	the garbage efficiently.
+	.
+	Appears to be an independent invention of an RCU-like mechanism.
+}
 }
 
 @Book{Adams91
@@ -223,20 +351,15 @@ Bibtex Entries
 ,title="Concurrent Programming, Principles, and Practices"
 ,Publisher="Benjamin Cummins"
 ,Year="1991"
+,annotation={
+	Has a few paragraphs describing ``chaotic relaxation'', a
+	numerical analysis technique that allows multiprocessors to
+	avoid synchronization overhead by using possibly-stale data.
+	.
+	Seems like this is descended from yet another independent
+	invention of RCU-like function -- but this is restricted
+	in that reclamation is not necessary.
 }
-
-@phdthesis{HMassalinPhD
-,author="H. Massalin"
-,title="Synthesis: An Efficient Implementation of Fundamental Operating
-System Services"
-,school="Columbia University"
-,address="New York, NY"
-,year="1992"
-,annotation="
-	Mondo optimizing compiler.
-	Wait-free stuff.
-	Good advice: defer work to avoid synchronization.
-"
 }
 
 @unpublished{Jacobson93
@@ -244,7 +367,13 @@ System Services"
 ,title="Avoid Read-Side Locking Via Delayed Free"
 ,year="1993"
 ,month="September"
-,note="Verbal discussion"
+,note="private communication"
+,annotation={
+	Use fixed time delay to approximate grace period.  Very simple,
+	but subject to random memory corruption under heavy load.
+	.
+	Independent invention of RCU-like mechanism.
+}
 }
 
 @Conference{AjuJohn95
@@ -256,6 +385,17 @@ System Services"
 ,Year="1995"
 ,pages="11-23"
 ,Address="New Orleans, LA"
+,note="Available:
+\url{https://www.usenix.org/publications/library/proceedings/neworl/full_papers/john.a}
+[Viewed October 1, 2010]"
+,annotation={
+	Age vnodes out of the cache, and have a fixed time set by a kernel
+	parameter.  Not clear that all races were in fact correctly handled.
+	Used a 20-minute time by default, which would most definitely not
+	be suitable during DoS attacks or virus scans.
+	.
+	Apparently independent invention of RCU-like mechanism.
+}
 }
 
 @conference{Pu95a,
@@ -301,31 +441,47 @@ Utilizing Execution History and Thread Monitoring"
 ,institution="US Patent and Trademark Office"
 ,address="Washington, DC"
 ,year="1995"
-,number="US Patent 5,442,758 (contributed under GPL)"
+,number="US Patent 5,442,758"
 ,month="August"
+,annotation={
+	Describes the parallel RCU infrastructure.  Includes NUMA aspect
+	(structure of bitmap can reflect bus structure of computer system).
+	.
+	Another independent invention of an RCU-like mechanism, but the
+	"real" RCU this time!
+}
 }
 
 @techreport{Slingwine97
 ,author="John D. Slingwine and Paul E. McKenney"
-,title="Method for maintaining data coherency using thread
-activity summaries in a multicomputer system"
+,title="Method for Maintaining Data Coherency Using Thread Activity
+Summaries in a Multicomputer System"
 ,institution="US Patent and Trademark Office"
 ,address="Washington, DC"
 ,year="1997"
-,number="US Patent 5,608,893 (contributed under GPL)"
+,number="US Patent 5,608,893"
 ,month="March"
+,pages="19"
+,annotation={
+	Describes use of RCU to synchronize data between a pair of
+	SMP/NUMA computer systems.
+}
 }
 
 @techreport{Slingwine98
 ,author="John D. Slingwine and Paul E. McKenney"
-,title="Apparatus and method for achieving reduced overhead
-mutual exclusion and maintaining coherency in a multiprocessor
-system utilizing execution history and thread monitoring"
+,title="Apparatus and Method for Achieving Reduced Overhead Mutual
+Exclusion and Maintaining Coherency in a Multiprocessor System
+Utilizing Execution History and Thread Monitoring"
 ,institution="US Patent and Trademark Office"
 ,address="Washington, DC"
 ,year="1998"
-,number="US Patent 5,727,209 (contributed under GPL)"
+,number="US Patent 5,727,209"
 ,month="March"
+,annotation={
+	Describes doing an atomic update by copying the data item and
+	then substituting it into the data structure.
+}
 }
 
 @Conference{McKenney98
@@ -337,6 +493,15 @@ Problems"
 ,Year="1998"
 ,pages="509-518"
 ,Address="Las Vegas, NV"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/RCU/rclockpdcsproof.pdf}
+[Viewed December 3, 2007]"
+,annotation={
+	Describes and analyzes RCU mechanism in DYNIX/ptx.  Describes
+	application to linked list update and log-buffer flushing.
+	Defines 'quiescent state'.  Includes both measured and analytic
+	evaluation.
+}
 }
 
 @Conference{Gamsa99
@@ -349,18 +514,76 @@ Operating System Design and Implementation}"
 ,Year="1999"
 ,pages="87-100"
 ,Address="New Orleans, LA"
+,note="Available:
+\url{http://www.usenix.org/events/osdi99/full_papers/gamsa/gamsa.pdf}
+[Viewed August 30, 2006]"
+,annotation={
+	Use of RCU-like facility in K42/Tornado.  Another independent
+	invention of RCU.
+	See especially pages 7-9 (Section 5).
+}
+}
+
+@unpublished{RustyRussell2000a
+,Author="Rusty Russell"
+,Title="Re: modular net drivers"
+,month="June"
+,year="2000"
+,day="23"
+,note="Available:
+\url{http://oss.sgi.com/projects/netdev/archive/2000-06/msg00250.html}
+[Viewed April 10, 2006]"
+,annotation={
+	Proto-RCU proposal from Phil Rumpf and Rusty Russell.
+	Yet another independent invention of RCU.
+	Outline of algorithm to unload modules...
+	.
+	Appeared on net-dev mailing list.
+}
+}
+
+@unpublished{RustyRussell2000b
+,Author="Rusty Russell"
+,Title="Re: modular net drivers"
+,month="June"
+,year="2000"
+,day="24"
+,note="Available:
+\url{http://oss.sgi.com/projects/netdev/archive/2000-06/msg00254.html}
+[Viewed April 10, 2006]"
+,annotation={
+	Proto-RCU proposal from Phil Rumpf and Rusty Russell.
+	.
+	Appeared on net-dev mailing list.
+}
+}
+
+@unpublished{McKenney01b
+,Author="Paul E. McKenney and Dipankar Sarma"
+,Title="Read-Copy Update Mutual Exclusion in {Linux}"
+,month="February"
+,year="2001"
+,note="Available:
+\url{http://lse.sourceforge.net/locking/rcu/rcupdate_doc.html}
+[Viewed October 18, 2004]"
+,annotation={
+	Prototypical Linux documentation for RCU.
+}
 }
 
 @techreport{Slingwine01
 ,author="John D. Slingwine and Paul E. McKenney"
-,title="Apparatus and method for achieving reduced overhead
-mutual exclusion and maintaining coherency in a multiprocessor
-system utilizing execution history and thread monitoring"
+,title="Apparatus and Method for Achieving Reduced Overhead Mutual
+Exclusion and Maintaining Coherency in a Multiprocessor System
+Utilizing Execution History and Thread Monitoring"
 ,institution="US Patent and Trademark Office"
 ,address="Washington, DC"
 ,year="2001"
-,number="US Patent 5,219,690 (contributed under GPL)"
+,number="US Patent 6,219,690"
 ,month="April"
+,annotation={
+	'Change in mode' aspect of RCU.  Can be thought of as a lazy barrier.
+}
 }
 
 @Conference{McKenney01a
@@ -372,14 +595,61 @@ Orran Krieger and Rusty Russell and Dipankar Sarma and Maneesh Soni"
 ,Year="2001"
 ,note="Available:
 \url{http://www.linuxsymposium.org/2001/abstracts/readcopy.php}
-\url{http://www.rdrop.com/users/paulmck/rclock/rclock_OLS.2001.05.01c.pdf}
+\url{http://www.rdrop.com/users/paulmck/RCU/rclock_OLS.2001.05.01c.pdf}
 [Viewed June 23, 2004]"
-annotation="
-Described RCU, and presented some patches implementing and using it in
-the Linux kernel.
+,annotation={
+	Described RCU, and presented some patches implementing and using
+	it in the Linux kernel.
+}
+}
+
+@unpublished{McKenney01f
+,Author="Paul E. McKenney"
+,Title="{RFC:} patch to allow lock-free traversal of lists with insertion"
+,month="October"
+,year="2001"
+,note="Available:
+\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=100259266316456&w=2}
+[Viewed June 23, 2004]"
+,annotation="
+	Memory-barrier and Alpha thread.  100 messages, not too bad...
+"
+}
+
+@unpublished{Spraul01
+,Author="Manfred Spraul"
+,Title="Re: {RFC:} patch to allow lock-free traversal of lists with insertion"
+,month="October"
+,year="2001"
+,note="Available:
+\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=100264675012867&w=2}
+[Viewed June 23, 2004]"
+,annotation="
+	Suggested burying memory barriers in Linux's list-manipulation
+	primitives.
 "
 }
 
+@unpublished{LinusTorvalds2001a
+,Author="Linus Torvalds"
+,Title="{Re:} {[Lse-tech]} {Re:} {RFC:} patch to allow lock-free traversal of lists with insertion"
+,month="October"
+,year="2001"
+,note="Available:
+\url{http://lkml.org/lkml/2001/10/13/105}
+[Viewed August 21, 2004]"
+}
+
+@unpublished{Blanchard02a
+,Author="Anton Blanchard"
+,Title="some RCU dcache and ratcache results"
+,month="March"
+,year="2002"
+,note="Available:
+\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=101637107412972&w=2}
+[Viewed October 18, 2004]"
+}
+
 @Conference{Linder02a
 ,Author="Hanna Linder and Dipankar Sarma and Maneesh Soni"
 ,Title="Scalability of the Directory Entry Cache"
@@ -387,6 +657,10 @@ the Linux kernel.
 ,Month="June"
 ,Year="2002"
 ,pages="289-300"
+,annotation="
+	Measured scalability of Linux 2.4 kernel's directory-entry cache
+	(dcache), and measured some scalability enhancements.
+"
 }
 
 @Conference{McKenney02a
@@ -400,49 +674,76 @@ Andrea Arcangeli and Andi Kleen and Orran Krieger and Rusty Russell"
 ,note="Available:
 \url{http://www.linux.org.uk/~ajh/ols2002_proceedings.pdf.gz}
 [Viewed June 23, 2004]"
+,annotation="
+	Presented and compared a number of RCU implementations for the
+	Linux kernel.
+"
 }
 
-@conference{Michael02a
-,author="Maged M. Michael"
-,title="Safe Memory Reclamation for Dynamic Lock-Free Objects Using Atomic
-Reads and Writes"
-,Year="2002"
-,Month="August"
-,booktitle="{Proceedings of the 21\textsuperscript{st} Annual ACM
-Symposium on Principles of Distributed Computing}"
-,pages="21-30"
+@unpublished{Sarma02a
+,Author="Dipankar Sarma"
+,Title="specweb99: dcache scalability results"
+,month="July"
+,year="2002"
+,note="Available:
+\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=102645767914212&w=2}
+[Viewed June 23, 2004]"
 ,annotation="
-	Each thread keeps an array of pointers to items that it is
-	currently referencing.	Sort of an inside-out garbage collection
-	mechanism, but one that requires the accessing code to explicitly
-	state its needs.  Also requires read-side memory barriers on
-	most architectures.
+	Compare fastwalk and RCU for dcache.  RCU won.
 "
 }
 
-@conference{Michael02b
-,author="Maged M. Michael"
-,title="High Performance Dynamic Lock-Free Hash Tables and List-Based Sets"
-,Year="2002"
-,Month="August"
-,booktitle="{Proceedings of the 14\textsuperscript{th} Annual ACM
-Symposium on Parallel
-Algorithms and Architecture}"
-,pages="73-82"
+@unpublished{Barbieri02
+,Author="Luca Barbieri"
+,Title="Re: {[PATCH]} Initial support for struct {vfs\_cred}"
+,month="August"
+,year="2002"
+,note="Available:
+\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=103082050621241&w=2}
+[Viewed: June 23, 2004]"
 ,annotation="
-	Like the title says...
+	Suggested RCU for vfs\_shared\_cred.
 "
 }
 
-@InProceedings{HerlihyLM02
-,author={Maurice Herlihy and Victor Luchangco and Mark Moir}
-,title="The Repeat Offender Problem: A Mechanism for Supporting Dynamic-Sized,
-Lock-Free Data Structures"
-,booktitle={Proceedings of 16\textsuperscript{th} International
-Symposium on Distributed Computing}
-,year=2002
+@unpublished{Dickins02a
+,author="Hugh Dickins"
+,title="Use RCU for System-V IPC"
+,year="2002"
+,month="October"
+,note="private communication"
+}
+
+@unpublished{Sarma02b
+,Author="Dipankar Sarma"
+,Title="Some dcache\_rcu benchmark numbers"
 ,month="October"
-,pages="339-353"
+,year="2002"
+,note="Available:
+\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=103462075416638&w=2}
+[Viewed June 23, 2004]"
+,annotation="
+	Performance of dcache RCU on kernbench for 16x NUMA-Q and 1x,
+	2x, and 4x systems.  RCU does no harm, and helps on 16x.
+"
+}
+
+@unpublished{LinusTorvalds2003a
+,Author="Linus Torvalds"
+,Title="Re: {[PATCH]} small fixes in brlock.h"
+,month="March"
+,year="2003"
+,note="Available:
+\url{http://lkml.org/lkml/2003/3/9/205}
+[Viewed March 13, 2006]"
+,annotation="
+	Linus suggests replacing brlock with RCU and/or seqlocks:
+	.
+	'It's entirely possible that the current user could be replaced
+	by RCU and/or seqlocks, and we could get rid of brlocks entirely.'
+	.
+	Steve Hemminger responds by replacing them with RCU.
+"
 }
 
 @article{Appavoo03a
@@ -457,6 +758,20 @@ B. Rosenburg and M. Stumm and J. Xenidis"
 ,volume="42"
 ,number="1"
 ,pages="60-76"
+,annotation="
+	Use of RCU to enable hot-swapping for autonomic behavior in K42.
+"
+}
+
+@unpublished{Seigh03
+,author="Joseph W. {Seigh II}"
+,title="Read Copy Update"
+,Year="2003"
+,Month="March"
+,note="email correspondence"
+,annotation="
+	Described the relationship of the VM/XA passive serialization to RCU.
+"
 }
 
 @Conference{Arcangeli03
@@ -470,6 +785,27 @@ Dipankar Sarma"
 ,year="2003"
 ,month="June"
 ,pages="297-310"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/RCU/rcu.FREENIX.2003.06.14.pdf}
+[Viewed November 21, 2007]"
+,annotation="
+	Compared updated RCU implementations for the Linux kernel, and
+	described System V IPC use of RCU, including order-of-magnitude
+	performance improvements.
+"
+}
+
+@Conference{Soules03a
+,Author="Craig A. N. Soules and Jonathan Appavoo and Kevin Hui and
+Dilma {Da Silva} and Gregory R. Ganger and Orran Krieger and
+Michael Stumm and Robert W. Wisniewski and Marc Auslander and
+Michal Ostrowski and Bryan Rosenburg and Jimi Xenidis"
+,Title="System Support for Online Reconfiguration"
+,Booktitle="Proceedings of the 2003 USENIX Annual Technical Conference"
+,Publisher="USENIX Association"
+,year="2003"
+,month="June"
+,pages="141-154"
 }
 
 @article{McKenney03a
@@ -481,6 +817,22 @@ Dipankar Sarma"
 ,volume="1"
 ,number="114"
 ,pages="18-26"
+,note="Available:
+\url{http://www.linuxjournal.com/article/6993}
+[Viewed November 14, 2007]"
+,annotation="
+	Reader-friendly intro to RCU, with the infamous old-man-and-brat
+	cartoon.
+"
+}
+
+@unpublished{Sarma03a
+,Author="Dipankar Sarma"
+,Title="RCU low latency patches"
+,month="December"
+,year="2003"
+,note="Message ID: 20031222180114.GA2248@in.ibm.com"
+,annotation="dipankar/ct.2004.03.27/RCUll.2003.12.22.patch"
 }
 
 @techreport{Friedberg03a
@@ -489,9 +841,14 @@ Dipankar Sarma"
 ,institution="US Patent and Trademark Office"
 ,address="Washington, DC"
 ,year="2003"
-,number="US Patent 6,662,184 (contributed under GPL)"
+,number="US Patent 6,662,184"
 ,month="December"
 ,pages="112"
+,annotation="
+	Applies RCU to a wildcard-search Patricia tree in order to permit
+	synchronization-free lookup.  RCU is used to retain removed nodes
+	for a grace period before freeing them.
+"
 }
 
 @article{McKenney04a
@@ -503,6 +860,12 @@ Dipankar Sarma"
 ,volume="1"
 ,number="118"
 ,pages="38-46"
+,note="Available:
+\url{http://www.linuxjournal.com/node/7124}
+[Viewed December 26, 2010]"
+,annotation="
+	Reader friendly intro to dcache and RCU.
+"
 }
 
 @Conference{McKenney04b
@@ -514,152 +877,824 @@ Dipankar Sarma"
 ,Address="Adelaide, Australia"
 ,note="Available:
 \url{http://www.linux.org.au/conf/2004/abstracts.html#90}
-\url{http://www.rdrop.com/users/paulmck/rclock/lockperf.2004.01.17a.pdf}
+\url{http://www.rdrop.com/users/paulmck/RCU/lockperf.2004.01.17a.pdf}
 [Viewed June 23, 2004]"
+,annotation="
+	Compares performance of RCU to that of other locking primitives
+	over a number of CPUs (x86, Opteron, Itanium, and PPC).
+"
 }
 
-@phdthesis{PaulEdwardMcKenneyPhD
-,author="Paul E. McKenney"
-,title="Exploiting Deferred Destruction:
-An Analysis of Read-Copy-Update Techniques
-in Operating System Kernels"
-,school="OGI School of Science and Engineering at
-Oregon Health and Sciences University"
+@unpublished{Sarma04a
+,Author="Dipankar Sarma"
+,Title="{[PATCH]} {RCU} for low latency (experimental)"
+,month="March"
+,year="2004"
+,note="\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=108003746402892&w=2}"
+,annotation="Head of thread: dipankar/2004.03.23/rcu-low-lat.1.patch"
+}
+
+@unpublished{Sarma04b
+,Author="Dipankar Sarma"
+,Title="Re: {[PATCH]} {RCU} for low latency (experimental)"
+,month="March"
+,year="2004"
+,note="\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=108016474829546&w=2}"
+,annotation="dipankar/rcuth.2004.03.24/rcu-throttle.patch"
+}
+
+@unpublished{Spraul04a
+,Author="Manfred Spraul"
+,Title="[RFC] 0/5 rcu lock update"
+,month="May"
 ,year="2004"
 ,note="Available:
-\url{http://www.rdrop.com/users/paulmck/RCU/RCUdissertation.2004.07.14e1.pdf}
-[Viewed October 15, 2004]"
+\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=108546407726602&w=2}
+[Viewed June 23, 2004]"
+,annotation="
+	Hierarchical-bitmap patch for RCU infrastructure.
+"
+}
+
+@unpublished{Steiner04a
+,Author="Jack Steiner"
+,Title="Re: [Lse-tech] [RFC, PATCH] 1/5 rcu lock update:
+Add per-cpu batch counter"
+,month="May"
+,year="2004"
+,note="Available:
+\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=108551764515332&w=2}
+[Viewed June 23, 2004]"
+,annotation={
+	RCU runs reasonably on a 512-CPU SGI using Manfred Spraul's patches,
+	which may be found at:
+	https://lkml.org/lkml/2004/5/20/49 (split vars into cachelines)
+	https://lkml.org/lkml/2004/5/22/114 (cpu_quiet() patch)
+	https://lkml.org/lkml/2004/5/25/24 (0/5)
+	https://lkml.org/lkml/2004/5/25/23 (1/5)
+		https://lkml.org/lkml/2004/5/25/265 (works for Jack)
+	https://lkml.org/lkml/2004/5/25/20 (2/5)
+	https://lkml.org/lkml/2004/5/25/22 (3/5)
+	https://lkml.org/lkml/2004/5/25/19 (4/5)
+	https://lkml.org/lkml/2004/5/25/21 (5/5)
+}
 }
 
 @Conference{Sarma04c
 ,Author="Dipankar Sarma and Paul E. McKenney"
-,Title="Making RCU Safe for Deep Sub-Millisecond Response Realtime Applications"
+,Title="Making {RCU} Safe for Deep Sub-Millisecond Response
+Realtime Applications"
 ,Booktitle="Proceedings of the 2004 USENIX Annual Technical Conference
 (FREENIX Track)"
 ,Publisher="USENIX Association"
 ,year="2004"
 ,month="June"
 ,pages="182-191"
+,annotation="
+	Describes and compares a number of modifications to the Linux RCU
+	implementation that make it friendly to realtime applications.
+"
 }
 
-@unpublished{JamesMorris04b
-,Author="James Morris"
-,Title="Recent Developments in {SELinux} Kernel Performance"
-,month="December"
+@phdthesis{PaulEdwardMcKenneyPhD
+,author="Paul E. McKenney"
+,title="Exploiting Deferred Destruction:
+An Analysis of Read-Copy-Update Techniques
+in Operating System Kernels"
+,school="OGI School of Science and Engineering at
+Oregon Health and Sciences University"
 ,year="2004"
 ,note="Available:
-\url{http://www.livejournal.com/users/james_morris/2153.html}
-[Viewed December 10, 2004]"
+\url{http://www.rdrop.com/users/paulmck/RCU/RCUdissertation.2004.07.14e1.pdf}
+[Viewed October 15, 2004]"
+,annotation="
+	Describes RCU implementations and presents design patterns
+	corresponding to common uses of RCU in several operating-system
+	kernels.
+"
 }
 
-@unpublished{PaulMcKenney05a
-,Author="Paul E. McKenney"
-,Title="{[RFC]} {RCU} and {CONFIG\_PREEMPT\_RT} progress"
-,month="May"
-,year="2005"
+@unpublished{PaulEMcKenney2004rcu:dereference
+,Author="Dipankar Sarma"
+,Title="{Re: RCU : Abstracted RCU dereferencing [5/5]}"
+,month="August"
+,year="2004"
 ,note="Available:
-\url{http://lkml.org/lkml/2005/5/9/185}
-[Viewed May 13, 2005]"
+\url{http://lkml.org/lkml/2004/8/6/237}
+[Viewed June 8, 2010]"
 ,annotation="
-	First publication of working lock-based deferred free patches
-	for the CONFIG_PREEMPT_RT environment.
+	Introduce rcu_dereference().
 "
 }
 
-@conference{PaulMcKenney05b
-,Author="Paul E. McKenney and Dipankar Sarma"
-,Title="Towards Hard Realtime Response from the Linux Kernel on SMP Hardware"
-,Booktitle="linux.conf.au 2005"
-,month="April"
-,year="2005"
-,address="Canberra, Australia"
+@unpublished{JimHouston04a
+,Author="Jim Houston"
+,Title="{[RFC\&PATCH] Alternative {RCU} implementation}"
+,month="August"
+,year="2004"
 ,note="Available:
-\url{http://www.rdrop.com/users/paulmck/RCU/realtimeRCU.2005.04.23a.pdf}
-[Viewed May 13, 2005]"
+\url{http://lkml.org/lkml/2004/8/30/87}
+[Viewed February 17, 2005]"
 ,annotation="
-	Realtime turns into making RCU yet more realtime friendly.
+	Uses active code in rcu_read_lock() and rcu_read_unlock() to
+	make RCU happen, allowing RCU to function on CPUs that do not
+	receive a scheduling-clock interrupt.
 "
 }
 
-@conference{ThomasEHart2006a
-,Author="Thomas E. Hart and Paul E. McKenney and Angela Demke Brown"
-,Title="Making Lockless Synchronization Fast: Performance Implications
-of Memory Reclamation"
-,Booktitle="20\textsuperscript{th} {IEEE} International Parallel and
-Distributed Processing Symposium"
-,month="April"
-,year="2006"
-,day="25-29"
-,address="Rhodes, Greece"
+@unpublished{TomHart04a
+,Author="Thomas E. Hart"
+,Title="Master's Thesis: Applying Lock-free Techniques to the {Linux} Kernel"
+,month="October"
+,year="2004"
+,note="Available:
+\url{http://www.cs.toronto.edu/~tomhart/masters_thesis.html}
+[Viewed October 15, 2004]"
 ,annotation="
-	Compares QSBR (AKA "classic RCU"), HPBR, EBR, and lock-free
-	reference counting.
+	Proposes comparing RCU to lock-free methods for the Linux kernel.
 "
 }
 
-@Conference{PaulEMcKenney2006b
-,Author="Paul E. McKenney and Dipankar Sarma and Ingo Molnar and
-Suparna Bhattacharya"
-,Title="Extending RCU for Realtime and Embedded Workloads"
-,Booktitle="{Ottawa Linux Symposium}"
-,Month="July"
-,Year="2006"
-,pages="v2 123-138"
+@unpublished{Vaddagiri04a
+,Author="Srivatsa Vaddagiri"
+,Title="Subject: [RFC] Use RCU for tcp\_ehash lookup"
+,month="October"
+,year="2004"
 ,note="Available:
-\url{http://www.linuxsymposium.org/2006/index_2006.php}
-\url{http://www.rdrop.com/users/paulmck/RCU/OLSrtRCU.2006.08.11a.pdf}
-[Viewed January 1, 2007]"
+\url{http://marc.theaimsgroup.com/?t=109395731700004&r=1&w=2}
+[Viewed October 18, 2004]"
 ,annotation="
-	Described how to improve the -rt implementation of realtime RCU.
+	Srivatsa's RCU patch for tcp_ehash lookup.
 "
 }
 
-@unpublished{PaulEMcKenney2006c
-,Author="Paul E. McKenney"
-,Title="Sleepable {RCU}"
+@unpublished{Thirumalai04a
+,Author="Ravikiran Thirumalai"
+,Title="Subject: [patchset] Lockfree fd lookup 0 of 5"
 ,month="October"
-,day="9"
-,year="2006"
+,year="2004"
 ,note="Available:
-\url{http://lwn.net/Articles/202847/}
-Revised:
-\url{http://www.rdrop.com/users/paulmck/RCU/srcu.2007.01.14a.pdf}
-[Viewed August 21, 2006]"
+\url{http://marc.theaimsgroup.com/?t=109144217400003&r=1&w=2}
+[Viewed October 18, 2004]"
 ,annotation="
-	LWN article introducing SRCU.
+	Ravikiran's lockfree FD patch.
+"
+}
+
+@unpublished{Thirumalai04b
+,Author="Ravikiran Thirumalai"
+,Title="Subject: Re: [patchset] Lockfree fd lookup 0 of 5"
+,month="October"
+,year="2004"
+,note="Available:
+\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=109152521410459&w=2}
+[Viewed October 18, 2004]"
+,annotation="
+	Ravikiran's lockfree FD patch.
+"
+}
+
+@unpublished{PaulEMcKenney2004rcu:assign:pointer
+,Author="Paul E. McKenney"
+,Title="{[PATCH 1/3] RCU: \url{rcu_assign_pointer()} removal of memory barriers}"
+,month="October"
+,year="2004"
+,note="Available:
+\url{http://lkml.org/lkml/2004/10/23/241}
+[Viewed June 8, 2010]"
+,annotation="
+	Introduce rcu_assign_pointer().
+"
+}
+
+@unpublished{JamesMorris04a
+,Author="James Morris"
+,Title="{[PATCH 2/3] SELinux} scalability - convert {AVC} to {RCU}"
+,day="15"
+,month="November"
+,year="2004"
+,note="Available:
+\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=110054979416004&w=2}
+[Viewed December 10, 2004]"
+,annotation="
+	James Morris posts Kaigai Kohei's patch to LKML.
+"
+}
+
+@unpublished{JamesMorris04b
+,Author="James Morris"
+,Title="Recent Developments in {SELinux} Kernel Performance"
+,month="December"
+,year="2004"
+,note="Available:
+\url{http://www.livejournal.com/users/james_morris/2153.html}
+[Viewed December 10, 2004]"
+,annotation="
+	RCU helps SELinux performance.  ;-)  Made LWN.
+"
+}
+
+@unpublished{PaulMcKenney2005RCUSemantics
+,Author="Paul E. McKenney and Jonathan Walpole"
+,Title="{RCU} Semantics: A First Attempt"
+,month="January"
+,year="2005"
+,day="30"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/RCU/rcu-semantics.2005.01.30a.pdf}
+[Viewed December 6, 2009]"
+,annotation="
+	Early derivation of RCU semantics.
+"
+}
+
+@unpublished{PaulMcKenney2005e
+,Author="Paul E. McKenney"
+,Title="Real-Time Preemption and {RCU}"
+,month="March"
+,year="2005"
+,day="17"
+,note="Available:
+\url{http://lkml.org/lkml/2005/3/17/199}
+[Viewed September 5, 2005]"
+,annotation="
+	First posting showing how RCU can be safely adapted for
+	preemptable RCU read side critical sections.
+"
+}
+
+@unpublished{EsbenNeilsen2005a
+,Author="Esben Neilsen"
+,Title="Re: Real-Time Preemption and {RCU}"
+,month="March"
+,year="2005"
+,day="18"
+,note="Available:
+\url{http://lkml.org/lkml/2005/3/18/122}
+[Viewed March 30, 2006]"
+,annotation="
+	Esben Neilsen suggests read-side suppression of grace-period
+	processing for crude-but-workable realtime RCU.  The downside
+	is indefinite grace periods...But this is OK for experimentation
+	and testing.
+"
+}
+
+@unpublished{TomHart05a
+,Author="Thomas E. Hart and Paul E. McKenney and Angela Demke Brown"
+,Title="Efficient Memory Reclamation is Necessary for Fast Lock-Free
+Data Structures"
+,month="March"
+,year="2005"
+,note="Available:
+\url{ftp://ftp.cs.toronto.edu/csrg-technical-reports/515/}
+[Viewed March 4, 2005]"
+,annotation="
+	Comparison of RCU, QBSR, and EBSR.  RCU wins for read-mostly
+	workloads.  ;-)
+"
+}
+
+@unpublished{JonCorbet2005DeprecateSyncKernel
+,Author="Jonathan Corbet"
+,Title="API change: synchronize_kernel() deprecated"
+,month="May"
+,day="3"
+,year="2005"
+,note="Available:
+\url{http://lwn.net/Articles/134484/}
+[Viewed May 3, 2005]"
+,annotation="
+	Jon Corbet describes deprecation of synchronize_kernel()
+	in favor of synchronize_rcu() and synchronize_sched().
+"
+}
+
+@unpublished{PaulMcKenney05a
+,Author="Paul E. McKenney"
+,Title="{[RFC]} {RCU} and {CONFIG\_PREEMPT\_RT} progress"
+,month="May"
+,year="2005"
+,note="Available:
+\url{http://lkml.org/lkml/2005/5/9/185}
+[Viewed May 13, 2005]"
+,annotation="
+	First publication of working lock-based deferred free patches
+	for the CONFIG_PREEMPT_RT environment.
+"
+}
+
+@conference{PaulMcKenney05b
+,Author="Paul E. McKenney and Dipankar Sarma"
+,Title="Towards Hard Realtime Response from the {Linux} Kernel on {SMP} Hardware"
+,Booktitle="linux.conf.au 2005"
+,month="April"
+,year="2005"
+,address="Canberra, Australia"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/RCU/realtimeRCU.2005.04.23a.pdf}
+[Viewed May 13, 2005]"
+,annotation="
+	Realtime turns into making RCU yet more realtime friendly.
+	http://lca2005.linux.org.au/Papers/Paul%20McKenney/Towards%20Hard%20Realtime%20Response%20from%20the%20Linux%20Kernel/LKS.2005.04.22a.pdf
+"
+}
+
+@unpublished{PaulEMcKenneyHomePage
+,Author="Paul E. McKenney"
+,Title="{Paul} {E.} {McKenney}"
+,month="May"
+,year="2005"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/}
+[Viewed May 25, 2005]"
+,annotation="
+	Paul McKenney's home page.
+"
+}
+
+@unpublished{PaulEMcKenneyRCUPage
+,Author="Paul E. McKenney"
+,Title="Read-Copy Update {(RCU)}"
+,month="May"
+,year="2005"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/RCU}
+[Viewed May 25, 2005]"
+,annotation="
+	Paul McKenney's RCU page.
+"
+}
+
+@unpublished{JosephSeigh2005a
+,Author="Joseph Seigh"
+,Title="{RCU}+{SMR} (hazard pointers)"
+,month="July"
+,year="2005"
+,note="Personal communication"
+,annotation="
+	Joe Seigh announcing his atomic-ptr-plus project.
+	http://sourceforge.net/projects/atomic-ptr-plus/
+"
+}
+
+@unpublished{JosephSeigh2005b
+,Author="Joseph Seigh"
+,Title="Lock-free synchronization primitives"
+,month="July"
+,day="6"
+,year="2005"
+,note="Available:
+\url{http://sourceforge.net/projects/atomic-ptr-plus/}
+[Viewed August 8, 2005]"
+,annotation="
+	Joe Seigh's atomic-ptr-plus project.
+"
+}
+
+@unpublished{PaulMcKenney2005c
+,Author="Paul E.McKenney"
+,Title="{[RFC,PATCH] RCU} and {CONFIG\_PREEMPT\_RT} sane patch"
+,month="August"
+,day="1"
+,year="2005"
+,note="Available:
+\url{http://lkml.org/lkml/2005/8/1/155}
+[Viewed March 14, 2006]"
+,annotation="
+	First operating counter-based realtime RCU patch posted to LKML.
+"
+}
+
+@unpublished{PaulMcKenney2005d
+,Author="Paul E. McKenney"
+,Title="Re: [Fwd: Re: [patch] Real-Time Preemption, -RT-2.6.13-rc4-V0.7.52-01]"
+,month="August"
+,day="8"
+,year="2005"
+,note="Available:
+\url{http://lkml.org/lkml/2005/8/8/108}
+[Viewed March 14, 2006]"
+,annotation="
+	First operating counter-based realtime RCU patch posted to LKML,
+	but fixed so that various unusual combinations of configuration
+	parameters all function properly.
+"
+}
+
+@unpublished{PaulMcKenney2005rcutorture
+,Author="Paul E. McKenney"
+,Title="{[PATCH]} {RCU} torture testing"
+,month="October"
+,day="1"
+,year="2005"
+,note="Available:
+\url{http://lkml.org/lkml/2005/10/1/70}
+[Viewed March 14, 2006]"
+,annotation="
+	First rcutorture patch.
+"
+}
+
+@conference{ThomasEHart2006a
+,Author="Thomas E. Hart and Paul E. McKenney and Angela Demke Brown"
+,Title="Making Lockless Synchronization Fast: Performance Implications
+of Memory Reclamation"
+,Booktitle="20\textsuperscript{th} {IEEE} International Parallel and
+Distributed Processing Symposium"
+,month="April"
+,year="2006"
+,day="25-29"
+,address="Rhodes, Greece"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/RCU/hart_ipdps06.pdf}
+[Viewed April 28, 2008]"
+,annotation="
+	Compares QSBR, HPBR, EBR, and lock-free reference counting.
+	http://www.cs.toronto.edu/~tomhart/perflab/ipdps06.tgz
+"
+}
+
+@unpublished{NickPiggin2006radixtree
+,Author="Nick Piggin"
+,Title="[patch 3/3] radix-tree: {RCU} lockless readside"
+,month="June"
+,day="20"
+,year="2006"
+,note="Available:
+\url{http://lkml.org/lkml/2006/6/20/238}
+[Viewed March 25, 2008]"
+,annotation="
+	RCU-protected radix tree.
+"
+}
+
+@Conference{PaulEMcKenney2006b
+,Author="Paul E. McKenney and Dipankar Sarma and Ingo Molnar and
+Suparna Bhattacharya"
+,Title="Extending {RCU} for Realtime and Embedded Workloads"
+,Booktitle="{Ottawa Linux Symposium}"
+,Month="July"
+,Year="2006"
+,pages="v2 123-138"
+,note="Available:
+\url{http://www.linuxsymposium.org/2006/view_abstract.php?content_key=184}
+\url{http://www.rdrop.com/users/paulmck/RCU/OLSrtRCU.2006.08.11a.pdf}
+[Viewed January 1, 2007]"
+,annotation="
+	Described how to improve the -rt implementation of realtime RCU.
+"
+}
+
+@unpublished{WikipediaRCU
+,Author="Paul E. McKenney and Chris Purcell and Algae and Ben Schumin and
+Gaius Cornelius and Qwertyus and Neil Conway and Sbw and Blainster and
+Canis Rufus and Zoicon5 and Anome and Hal Eisen"
+,Title="Read-Copy Update"
+,month="July"
+,day="8"
+,year="2006"
+,note="Available:
+\url{http://en.wikipedia.org/wiki/Read-copy-update}
+[Viewed August 21, 2006]"
+,annotation="
+	Wikipedia RCU page as of July 8 2006.
+"
+}
+
+@Conference{NickPiggin2006LocklessPageCache
+,Author="Nick Piggin"
+,Title="A Lockless Pagecache in Linux---Introduction, Progress, Performance"
+,Booktitle="{Ottawa Linux Symposium}"
+,Month="July"
+,Year="2006"
+,pages="v2 249-254"
+,note="Available:
+\url{http://www.linuxsymposium.org/2006/view_abstract.php?content_key=184}
+[Viewed January 11, 2009]"
+,annotation="
+	Uses RCU-protected radix tree for a lockless page cache.
+"
+}
+
+@unpublished{PaulEMcKenney2006c
+,Author="Paul E. McKenney"
+,Title="Sleepable {RCU}"
+,month="October"
+,day="9"
+,year="2006"
+,note="Available:
+\url{http://lwn.net/Articles/202847/}
+Revised:
+\url{http://www.rdrop.com/users/paulmck/RCU/srcu.2007.01.14a.pdf}
+[Viewed August 21, 2006]"
+,annotation="
+	LWN article introducing SRCU.
 "
 }
 
 @unpublished{RobertOlsson2006a
 ,Author="Robert Olsson and Stefan Nilsson"
 ,Title="{TRASH}: A dynamic {LC}-trie and hash data structure"
-,month="August"
-,day="18"
-,year="2006"
+,month="August"
+,day="18"
+,year="2006"
+,note="Available:
+\url{http://www.nada.kth.se/~snilsson/publications/TRASH/trash.pdf}
+[Viewed March 4, 2011]"
+,annotation="
+	RCU-protected dynamic trie-hash combination.
+"
+}
+
+@unpublished{ChristophHellwig2006RCU2SRCU
+,Author="Christoph Hellwig"
+,Title="Re: {[-mm PATCH 1/4]} {RCU}: split classic rcu"
+,month="September"
+,day="28"
+,year="2006"
+,note="Available:
+\url{http://lkml.org/lkml/2006/9/28/160}
+[Viewed March 27, 2008]"
+}
+
+@unpublished{PaulEMcKenneyRCUusagePage
+,Author="Paul E. McKenney"
+,Title="{RCU} {Linux} Usage"
+,month="October"
+,year="2006"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/RCU/linuxusage.html}
+[Viewed January 14, 2007]"
+,annotation="
+	Paul McKenney's RCU page showing graphs plotting Linux-kernel
+	usage of RCU.
+"
+}
+
+@unpublished{PaulEMcKenneyRCUusageRawDataPage
+,Author="Paul E. McKenney"
+,Title="Read-Copy Update {(RCU)} Usage in {Linux} Kernel"
+,month="October"
+,year="2006"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/RCU/linuxusage/rculocktab.html}
+[Viewed January 14, 2007]"
+,annotation="
+	Paul McKenney's RCU page showing Linux usage of RCU in tabular
+	form, with links to corresponding cscope databases.
+"
+}
+
+@unpublished{GauthamShenoy2006RCUrwlock
+,Author="Gautham R. Shenoy"
+,Title="[PATCH 4/5] lock\_cpu\_hotplug: Redesign - Lightweight implementation of lock\_cpu\_hotplug"
+,month="October"
+,year="2006"
+,day=26
+,note="Available:
+\url{http://lkml.org/lkml/2006/10/26/73}
+[Viewed January 26, 2009]"
+,annotation="
+	RCU-based reader-writer lock that allows readers to proceed with
+	no memory barriers or atomic instruction in absence of writers.
+	If writer do show up, readers must of course wait as required by
+	the semantics of reader-writer locking.  This is a recursive
+	lock.
+"
+}
+
+@unpublished{JensAxboe2006SlowSRCU
+,Author="Jens Axboe"
+,Title="Re: [patch] cpufreq: mark \url{cpufreq_tsc()} as
+\url{core_initcall_sync}"
+,month="November"
+,year="2006"
+,day=17
+,note="Available:
+\url{http://lkml.org/lkml/2006/11/17/56}
+[Viewed May 28, 2007]"
+,annotation="
+	SRCU's grace periods are too slow for Jens, even after a
+	factor-of-three speedup.
+	Sped-up version of SRCU at http://lkml.org/lkml/2006/11/17/359.
+"
+}
+
+@unpublished{OlegNesterov2006QRCU
+,Author="Oleg Nesterov"
+,Title="Re: [patch] cpufreq: mark {\tt cpufreq\_tsc()} as
+{\tt core\_initcall\_sync}"
+,month="November"
+,year="2006"
+,day=19
+,note="Available:
+\url{http://lkml.org/lkml/2006/11/19/69}
+[Viewed May 28, 2007]"
+,annotation="
+	First cut of QRCU.  Expanded/corrected versions followed.
+	Used to be OlegNesterov2007QRCU, now time-corrected.
+"
+}
+
+@unpublished{OlegNesterov2006aQRCU
+,Author="Oleg Nesterov"
+,Title="Re: [RFC, PATCH 1/2] qrcu: {"quick"} srcu implementation"
+,month="November"
+,year="2006"
+,day=30
+,note="Available:
+\url{http://lkml.org/lkml/2006/11/29/330}
+[Viewed November 26, 2008]"
+,annotation="
+	Expanded/corrected version of QRCU.
+	Used to be OlegNesterov2007aQRCU, now time-corrected.
+"
+}
+
+@unpublished{EvgeniyPolyakov2006RCUslowdown
+,Author="Evgeniy Polyakov"
+,Title="Badness in postponing work"
+,month="December"
+,year="2006"
+,day=05
+,note="Available:
+\url{http://www.ioremap.net/node/41}
+[Viewed October 28, 2008]"
+,annotation="
+	Using RCU as a pure delay leads to a 2.5x slowdown in skbs in
+	the Linux kernel.
+"
+}
+
+@inproceedings{ChrisMatthews2006ClusteredObjectsRCU
+,author = {Matthews, Chris and Coady, Yvonne and Appavoo, Jonathan}
+,title = {Portability events: a programming model for scalable system infrastructures}
+,booktitle = {PLOS '06: Proceedings of the 3rd workshop on Programming languages and operating systems}
+,year = {2006}
+,isbn = {1-59593-577-0}
+,pages = {11}
+,location = {San Jose, California}
+,doi = {http://doi.acm.org/10.1145/1215995.1216006}
+,publisher = {ACM}
+,address = {New York, NY, USA}
+,annotation={
+	Uses K42's RCU-like functionality to manage clustered-object
+	lifetimes.
+}}
+
+@article{DilmaDaSilva2006K42
+,author = {Silva, Dilma Da and Krieger, Orran and Wisniewski, Robert W. and Waterland, Amos and Tam, David and Baumann, Andrew}
+,title = {K42: an infrastructure for operating system research}
+,journal = {SIGOPS Oper. Syst. Rev.}
+,volume = {40}
+,number = {2}
+,year = {2006}
+,issn = {0163-5980}
+,pages = {34--42}
+,doi = {http://doi.acm.org/10.1145/1131322.1131333}
+,publisher = {ACM}
+,address = {New York, NY, USA}
+,annotation={
+	Describes relationship of K42 generations to RCU.
+}}
+
+# CoreyMinyard2007list_splice_rcu
+@unpublished{CoreyMinyard2007list:splice:rcu
+,Author="Corey Minyard and Paul E. McKenney"
+,Title="{[PATCH]} add an {RCU} version of list splicing"
+,month="January"
+,year="2007"
+,day=3
+,note="Available:
+\url{http://lkml.org/lkml/2007/1/3/112}
+[Viewed May 28, 2007]"
+,annotation="
+	Patch for list_splice_rcu().
+"
+}
+
+@unpublished{PaulEMcKenney2007rcubarrier
+,Author="Paul E. McKenney"
+,Title="{RCU} and Unloadable Modules"
+,month="January"
+,day="14"
+,year="2007"
+,note="Available:
+\url{http://lwn.net/Articles/217484/}
+[Viewed November 22, 2007]"
+,annotation="
+	LWN article introducing the rcu_barrier() primitive.
+"
+}
+
+@unpublished{PeterZijlstra2007SyncBarrier
+,Author="Peter Zijlstra and Ingo Molnar"
+,Title="{[PATCH 3/7]} barrier: a scalable synchonisation barrier"
+,month="January"
+,year="2007"
+,day=28
+,note="Available:
+\url{http://lkml.org/lkml/2007/1/28/34}
+[Viewed March 27, 2008]"
+,annotation="
+	RCU-like implementation for frequent updaters and rare readers(!).
+	Subsumed into QRCU.  Maybe...
+"
+}
+
+@unpublished{PaulEMcKenney2007BoostRCU
+,Author="Paul E. McKenney"
+,Title="Priority-Boosting {RCU} Read-Side Critical Sections"
+,month="February"
+,day="5"
+,year="2007"
+,note="Available:
+\url{http://lwn.net/Articles/220677/}
+Revised:
+\url{http://www.rdrop.com/users/paulmck/RCU/RCUbooststate.2007.04.16a.pdf}
+[Viewed September 7, 2007]"
+,annotation="
+	LWN article introducing RCU priority boosting.
+"
+}
+
+@unpublished{PaulMcKenney2007QRCUpatch
+,Author="Paul E. McKenney"
+,Title="{[PATCH]} {QRCU} with lockless fastpath"
+,month="February"
+,year="2007"
+,day=24
+,note="Available:
+\url{http://lkml.org/lkml/2007/2/25/18}
+[Viewed March 27, 2008]"
+,annotation="
+	Patch for QRCU supplying lock-free fast path.
+"
+}
+
+@article{JonathanAppavoo2007K42RCU
+,author = {Appavoo, Jonathan and Silva, Dilma Da and Krieger, Orran and Auslander, Marc and Ostrowski, Michal and Rosenburg, Bryan and Waterland, Amos and Wisniewski, Robert W. and Xenidis, Jimi and Stumm, Michael and Soares, Livio}
+,title = {Experience distributing objects in an SMMP OS}
+,journal = {ACM Trans. Comput. Syst.}
+,volume = {25}
+,number = {3}
+,year = {2007}
+,issn = {0734-2071}
+,pages = {6/1--6/52}
+,doi = {http://doi.acm.org/10.1145/1275517.1275518}
+,publisher = {ACM}
+,address = {New York, NY, USA}
+,annotation={
+	Role of RCU in K42.
+}}
+
+@conference{RobertOlsson2007Trash
+,Author="Robert Olsson and Stefan Nilsson"
+,Title="{TRASH}: A dynamic {LC}-trie and hash data structure"
+,booktitle="Workshop on High Performance Switching and Routing (HPSR'07)"
+,month="May"
+,year="2007"
 ,note="Available:
-\url{http://www.nada.kth.se/~snilsson/public/papers/trash/trash.pdf}
-[Viewed February 24, 2007]"
+\url{http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=4281239}
+[Viewed October 1, 2010]"
 ,annotation="
 	RCU-protected dynamic trie-hash combination.
 "
 }
 
-@unpublished{ThomasEHart2007a
-,Author="Thomas E. Hart and Paul E. McKenney and Angela Demke Brown and Jonathan Walpole"
-,Title="Performance of memory reclamation for lockless synchronization"
-,journal="J. Parallel Distrib. Comput."
+@conference{PeterZijlstra2007ConcurrentPagecacheRCU
+,Author="Peter Zijlstra"
+,Title="Concurrent Pagecache"
+,Booktitle="Linux Symposium"
+,month="June"
+,year="2007"
+,address="Ottawa, Canada"
+,note="Available:
+\url{http://ols.108.redhat.com/2007/Reprints/zijlstra-Reprint.pdf}
+[Viewed April 14, 2008]"
+,annotation="
+	Page-cache modifications permitting RCU readers and concurrent
+	updates.
+"
+}
+
+@unpublished{PaulEMcKenney2007whatisRCU
+,Author="Paul E. McKenney"
+,Title="What is {RCU}?"
 ,year="2007"
-,note="To appear in J. Parallel Distrib. Comput.
-       \url{doi=10.1016/j.jpdc.2007.04.010}"
+,month="07"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/RCU/whatisRCU.html}
+[Viewed July 6, 2007]"
 ,annotation={
-	Compares QSBR (AKA "classic RCU"), HPBR, EBR, and lock-free
-	reference counting.  Journal version of ThomasEHart2006a.
+	Describes RCU in Linux kernel.
 }
 }
 
 @unpublished{PaulEMcKenney2007QRCUspin
 ,Author="Paul E. McKenney"
-,Title="Using Promela and Spin to verify parallel algorithms"
+,Title="Using {Promela} and {Spin} to verify parallel algorithms"
 ,month="August"
 ,day="1"
 ,year="2007"
@@ -669,6 +1704,50 @@ Revised:
 ,annotation="
 	LWN article describing Promela and spin, and also using Oleg
 	Nesterov's QRCU as an example (with Paul McKenney's fastpath).
+	Merged patch at: http://lkml.org/lkml/2007/2/25/18
+"
+}
+
+@unpublished{PaulEMcKenney2007WG21DDOatomics
+,Author="Paul E. McKenney and Hans-J. Boehm and Lawrence Crowl"
+,Title="C++ Data-Dependency Ordering: Atomics and Memory Model"
+,month="August"
+,day="3"
+,year="2007"
+,note="Preprint:
+\url{http://open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2664.htm}
+[Viewed December 7, 2009]"
+,annotation="
+	RCU for C++, parts 1 and 2.
+"
+}
+
+@unpublished{PaulEMcKenney2007WG21DDOannotation
+,Author="Paul E. McKenney and Lawrence Crowl"
+,Title="C++ Data-Dependency Ordering: Function Annotation"
+,month="September"
+,day="18"
+,year="2008"
+,note="Preprint:
+\url{http://open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2782.htm}
+[Viewed December 7, 2009]"
+,annotation="
+	RCU for C++, part 2, updated many times.
+"
+}
+
+@unpublished{PaulEMcKenney2007PreemptibleRCUPatch
+,Author="Paul E. McKenney"
+,Title="[PATCH RFC 0/9] {RCU}: Preemptible {RCU}"
+,month="September"
+,day="10"
+,year="2007"
+,note="Available:
+\url{http://lkml.org/lkml/2007/9/10/213}
+[Viewed October 25, 2007]"
+,annotation="
+	Final patch for preemptable RCU to -rt.  (Later patches were
+	to mainline, eventually incorporated.)
 "
 }
 
@@ -686,10 +1765,46 @@ Revised:
 "
 }
 
+@article{ThomasEHart2007a
+,Author="Thomas E. Hart and Paul E. McKenney and Angela Demke Brown and Jonathan Walpole"
+,Title="Performance of memory reclamation for lockless synchronization"
+,journal="J. Parallel Distrib. Comput."
+,volume={67}
+,number="12"
+,year="2007"
+,issn="0743-7315"
+,pages="1270--1285"
+,doi="http://dx.doi.org/10.1016/j.jpdc.2007.04.010"
+,publisher="Academic Press, Inc."
+,address="Orlando, FL, USA"
+,annotation={
+	Compares QSBR, HPBR, EBR, and lock-free reference counting.
+	Journal version of ThomasEHart2006a.
+}
+}
+
+@unpublished{MathieuDesnoyers2007call:rcu:schedNeeded
+,Author="Mathieu Desnoyers"
+,Title="Re: [patch 1/2] {Linux} Kernel Markers - Support Multiple Probes"
+,month="December"
+,day="20"
+,year="2007"
+,note="Available:
+\url{http://lkml.org/lkml/2007/12/20/244}
+[Viewed March 27, 2008]"
+,annotation="
+	Request for call_rcu_sched() and rcu_barrier_sched().
+"
+}
+
+
 ########################################################################
 #
 #	"What is RCU?" LWN series.
 #
+#	http://lwn.net/Articles/262464/ (What is RCU, Fundamentally?)
+#	http://lwn.net/Articles/263130/ (What is RCU's Usage?)
+#	http://lwn.net/Articles/264090/ (What is RCU's API?)
 
 @unpublished{PaulEMcKenney2007WhatIsRCUFundamentally
 ,Author="Paul E. McKenney and Jonathan Walpole"
@@ -723,7 +1838,7 @@ Revised:
 	3. RCU is a Bulk Reference-Counting Mechanism
 	4. RCU is a Poor Man's Garbage Collector
 	5. RCU is a Way of Providing Existence Guarantees
-	6. RCU is a Way of Waiting for Things to Finish 
+	6. RCU is a Way of Waiting for Things to Finish
 "
 }
 
@@ -747,20 +1862,96 @@ Revised:
 #
 ########################################################################
 
+
+@unpublished{SteveRostedt2008dyntickRCUpatch
+,Author="Steven Rostedt and Paul E. McKenney"
+,Title="{[PATCH]} add support for dynamic ticks and preempt rcu"
+,month="January"
+,day="29"
+,year="2008"
+,note="Available:
+\url{http://lkml.org/lkml/2008/1/29/208}
+[Viewed March 27, 2008]"
+,annotation="
+	Patch that prevents preemptible RCU from unnecessarily waking
+	up dynticks-idle CPUs.
+"
+}
+
+@unpublished{PaulEMcKenney2008LKMLDependencyOrdering
+,Author="Paul E. McKenney"
+,Title="Re: [PATCH 02/22 -v7] Add basic support for gcc profiler instrumentation"
+,month="February"
+,day="1"
+,year="2008"
+,note="Available:
+\url{http://lkml.org/lkml/2008/2/2/255}
+[Viewed October 18, 2008]"
+,annotation="
+	Explanation of compilers violating dependency ordering.
+"
+}
+
+@Conference{PaulEMcKenney2008Beijing
+,Author="Paul E. McKenney"
+,Title="Introducing Technology Into {Linux} Or:
+Introducing your technology Into {Linux} will require introducing a
+lot of {Linux} into your technology!!!"
+,Booktitle="2008 Linux Developer Symposium - China"
+,Publisher="OSS China"
+,Month="February"
+,Year="2008"
+,Address="Beijing, China"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/RCU/TechIntroLinux.2008.02.19a.pdf}
+[Viewed August 12, 2008]"
+}
+
+@unpublished{PaulEMcKenney2008dynticksRCU
+,Author="Paul E. McKenney and Steven Rostedt"
+,Title="Integrating and Validating dynticks and Preemptable RCU"
+,month="April"
+,day="24"
+,year="2008"
+,note="Available:
+\url{http://lwn.net/Articles/279077/}
+[Viewed April 24, 2008]"
+,annotation="
+	Describes use of Promela and Spin to validate (and fix!) the
+	dynticks/RCU interface.
+"
+}
+
 @article{DinakarGuniguntala2008IBMSysJ
 ,author="D. Guniguntala and P. E. McKenney and J. Triplett and J. Walpole"
 ,title="The read-copy-update mechanism for supporting real-time applications on shared-memory multiprocessor systems with {Linux}"
 ,Year="2008"
-,Month="April"
+,Month="April-June"
 ,journal="IBM Systems Journal"
 ,volume="47"
 ,number="2"
-,pages="@@-@@"
+,pages="221-236"
 ,annotation="
 	RCU, realtime RCU, sleepable RCU, performance.
 "
 }
 
+@unpublished{LaiJiangshan2008NewClassicAlgorithm
+,Author="Lai Jiangshan"
+,Title="[{RFC}][{PATCH}] rcu classic: new algorithm for callbacks-processing"
+,month="June"
+,day="3"
+,year="2008"
+,note="Available:
+\url{http://lkml.org/lkml/2008/6/2/539}
+[Viewed December 10, 2008]"
+,annotation="
+	Updated RCU classic algorithm.  Introduced multi-tailed list
+	for RCU callbacks and also pulling common code into
+	__call_rcu().
+"
+}
+
 @article{PaulEMcKenney2008RCUOSR
 ,author="Paul E. McKenney and Jonathan Walpole"
 ,title="Introducing technology into the {Linux} kernel: a case study"
@@ -778,6 +1969,52 @@ Revised:
 }
 }
 
+@unpublished{ManfredSpraul2008StateMachineRCU
+,Author="Manfred Spraul"
+,Title="[{RFC}, {PATCH}] state machine based rcu"
+,month="August"
+,day="21"
+,year="2008"
+,note="Available:
+\url{http://lkml.org/lkml/2008/8/21/336}
+[Viewed December 8, 2008]"
+,annotation="
+	State-based RCU.  One key thing that this patch does is to
+	separate the dynticks handling of NMIs and IRQs.
+"
+}
+
+@unpublished{ManfredSpraul2008dyntickIRQNMI
+,Author="Manfred Spraul"
+,Title="Re: [{RFC}, {PATCH}] v4 scalable classic {RCU} implementation"
+,month="September"
+,day="6"
+,year="2008"
+,note="Available:
+\url{http://lkml.org/lkml/2008/9/6/86}
+[Viewed December 8, 2008]"
+,annotation="
+	Manfred notes a fix required to my attempt to separate irq
+	and NMI processing for hierarchical RCU's dynticks interface.
+"
+}
+
+@techreport{PaulEMcKenney2008cyclicRCU
+,author="Paul E. McKenney"
+,title="Efficient Support of Consistent Cyclic Search With Read-Copy Update"
+,institution="US Patent and Trademark Office"
+,address="Washington, DC"
+,year="2008"
+,number="US Patent 7,426,511"
+,month="September"
+,pages="23"
+,annotation="
+	Maintains an additional level of indirection to allow
+	readers to confine themselves to the desired snapshot of the
+	data structure.  Only permits one update at a time.
+"
+}
+
 @unpublished{PaulEMcKenney2008HierarchicalRCU
 ,Author="Paul E. McKenney"
 ,Title="Hierarchical {RCU}"
@@ -793,6 +2030,21 @@ Revised:
 "
 }
 
+@unpublished{PaulEMcKenney2009BloatwatchRCU
+,Author="Paul E. McKenney"
+,Title="Re: [PATCH fyi] RCU: the bloatwatch edition"
+,month="January"
+,day="14"
+,year="2009"
+,note="Available:
+\url{http://lkml.org/lkml/2009/1/14/449}
+[Viewed January 15, 2009]"
+,annotation="
+	Small-footprint implementation of RCU for uniprocessor
+	embedded applications -- and also for exposition purposes.
+"
+}
+
 @conference{PaulEMcKenney2009MaliciousURCU
 ,Author="Paul E. McKenney"
 ,Title="Using a Malicious User-Level {RCU} to Torture {RCU}-Based Algorithms"
@@ -816,15 +2068,17 @@ Revised:
 ,year="2009"
 ,note="Available:
 \url{http://lkml.org/lkml/2009/2/5/572}
-\url{git://lttng.org/userspace-rcu.git}
+\url{http://lttng.org/urcu}
 [Viewed February 20, 2009]"
 ,annotation="
 	Mathieu Desnoyers's user-space RCU implementation.
 	git://lttng.org/userspace-rcu.git
+	http://lttng.org/cgi-bin/gitweb.cgi?p=userspace-rcu.git
+	http://lttng.org/urcu
 "
 }
 
-@unpublished{PaulEMcKenney2009BloatWatchRCU
+@unpublished{PaulEMcKenney2009LWNBloatWatchRCU
 ,Author="Paul E. McKenney"
 ,Title="{RCU}: The {Bloatwatch} Edition"
 ,month="March"
@@ -852,14 +2106,29 @@ Revised:
 "
 }
 
-@unpublished{JoshTriplett2009RPHash
+@unpublished{PaulEMcKenney2009fastRTRCU
+,Author="Paul E. McKenney"
+,Title="[{PATCH} {RFC} -tip 0/4] {RCU} cleanups and simplified preemptable {RCU}"
+,month="July"
+,day="23"
+,year="2009"
+,note="Available:
+\url{http://lkml.org/lkml/2009/7/23/294}
+[Viewed August 15, 2009]"
+,annotation="
+	First posting of simple and fast preemptable RCU.
+"
+}
+
+@InProceedings{JoshTriplett2009RPHash
 ,Author="Josh Triplett"
 ,Title="Scalable concurrent hash tables via relativistic programming"
 ,month="September"
 ,year="2009"
-,note="Linux Plumbers Conference presentation"
+,booktitle="Linux Plumbers Conference 2009"
 ,annotation="
 	RP fun with hash tables.
+	See also JoshTriplett2010RPHash
 "
 }
 
@@ -872,4 +2141,323 @@ Revised:
 ,note="Available:
 \url{http://www.lttng.org/pub/thesis/desnoyers-dissertation-2009-12.pdf}
 [Viewed December 9, 2009]"
+,annotation={
+	Chapter 6 (page 97) covers user-level RCU.
+}
+}
+
+@unpublished{RelativisticProgrammingWiki
+,Author="Josh Triplett and Paul E. McKenney and Jonathan Walpole"
+,Title="Relativistic Programming"
+,month="September"
+,year="2009"
+,note="Available:
+\url{http://wiki.cs.pdx.edu/rp/}
+[Viewed December 9, 2009]"
+,annotation="
+	Main Relativistic Programming Wiki.
+"
+}
+
+@conference{PaulEMcKenney2009DeterministicRCU
+,Author="Paul E. McKenney"
+,Title="Deterministic Synchronization in Multicore Systems: the Role of {RCU}"
+,Booktitle="Eleventh Real Time Linux Workshop"
+,month="September"
+,year="2009"
+,address="Dresden, Germany"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/realtime/paper/DetSyncRCU.2009.08.18a.pdf}
+[Viewed January 14, 2009]"
+}
+
+@unpublished{PaulEMcKenney2009HuntingHeisenbugs
+,Author="Paul E. McKenney"
+,Title="Hunting Heisenbugs"
+,month="November"
+,year="2009"
+,day="1"
+,note="Available:
+\url{http://paulmck.livejournal.com/14639.html}
+[Viewed June 4, 2010]"
+,annotation="
+	Day-one bug in Tree RCU that took forever to track down.
+"
+}
+
+@unpublished{MathieuDesnoyers2009defer:rcu
+,Author="Mathieu Desnoyers"
+,Title="Kernel RCU: shrink the size of the struct rcu\_head"
+,month="December"
+,year="2009"
+,note="Available:
+\url{http://lkml.org/lkml/2009/10/18/129}
+[Viewed December 29, 2009]"
+,annotation="
+	Mathieu proposed defer_rcu() with fixed-size per-thread pool
+	of RCU callbacks.
+"
+}
+
+@unpublished{MathieuDesnoyers2009VerifPrePub
+,Author="Mathieu Desnoyers and Paul E. McKenney and Michel R. Dagenais"
+,Title="Multi-Core Systems Modeling for Formal Verification of Parallel Algorithms"
+,month="December"
+,year="2009"
+,note="Submitted to IEEE TPDS"
+,annotation="
+	OOMem model for Mathieu's user-level RCU mechanical proof of
+	correctness.
+"
+}
+
+@unpublished{MathieuDesnoyers2009URCUPrePub
+,Author="Mathieu Desnoyers and Paul E. McKenney and Alan Stern and Michel R. Dagenais and Jonathan Walpole"
+,Title="User-Level Implementations of Read-Copy Update"
+,month="December"
+,year="2010"
+,url=\url{http://www.computer.org/csdl/trans/td/2012/02/ttd2012020375-abs.html}
+,annotation="
+	RCU overview, desiderata, semi-formal semantics, user-level RCU
+	usage scenarios, three classes of RCU implementation, wait-free
+	RCU updates, RCU grace-period batching, update overhead,
+	http://www.rdrop.com/users/paulmck/RCU/urcu-main-accepted.2011.08.30a.pdf
+	http://www.rdrop.com/users/paulmck/RCU/urcu-supp-accepted.2011.08.30a.pdf
+	Superseded by MathieuDesnoyers2012URCU.
+"
+}
+
+@inproceedings{HariKannan2009DynamicAnalysisRCU
+,author = {Kannan, Hari}
+,title = {Ordering decoupled metadata accesses in multiprocessors}
+,booktitle = {MICRO 42: Proceedings of the 42nd Annual IEEE/ACM International Symposium on Microarchitecture}
+,year = {2009}
+,isbn = {978-1-60558-798-1}
+,pages = {381--390}
+,location = {New York, New York}
+,doi = {http://doi.acm.org/10.1145/1669112.1669161}
+,publisher = {ACM}
+,address = {New York, NY, USA}
+,annotation={
+	Uses RCU to protect metadata used in dynamic analysis.
+}}
+
+@conference{PaulEMcKenney2010SimpleOptRCU
+,Author="Paul E. McKenney"
+,Title="Simplicity Through Optimization"
+,Booktitle="linux.conf.au 2010"
+,month="January"
+,year="2010"
+,address="Wellington, New Zealand"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/RCU/SimplicityThruOptimization.2010.01.21f.pdf}
+[Viewed October 10, 2010]"
+,annotation="
+	TREE_PREEMPT_RCU optimizations greatly simplified the old
+	PREEMPT_RCU implementation.
+"
+}
+
+@unpublished{PaulEMcKenney2010LockdepRCU
+,Author="Paul E. McKenney"
+,Title="Lockdep-{RCU}"
+,month="February"
+,year="2010"
+,day="1"
+,note="Available:
+\url{https://lwn.net/Articles/371986/}
+[Viewed June 4, 2010]"
+,annotation="
+	CONFIG_PROVE_RCU, or at least an early version.
+"
+}
+
+@unpublished{AviKivity2010KVM2RCU
+,Author="Avi Kivity"
+,Title="[{PATCH} 37/40] {KVM}: Bump maximum vcpu count to 64"
+,month="February"
+,year="2010"
+,note="Available:
+\url{http://www.mail-archive.com/kvm@vger.kernel.org/msg28640.html}
+[Viewed March 20, 2010]"
+,annotation="
+	Use of RCU permits KVM to increase the size of guest OSes from
+	16 CPUs to 64 CPUs.
+"
+}
+
+@unpublished{HerbertXu2010RCUResizeHash
+,Author="Herbert Xu"
+,Title="bridge: Add core IGMP snooping support"
+,month="February"
+,year="2010"
+,note="Available:
+\url{http://kerneltrap.com/mailarchive/linux-netdev/2010/2/26/6270589}
+[Viewed March 20, 2011]"
+,annotation={
+	Use a pair of list_head structures to support RCU-protected
+	resizable hash tables.
+}}
+
+@article{JoshTriplett2010RPHash
+,author="Josh Triplett and Paul E. McKenney and Jonathan Walpole"
+,title="Scalable Concurrent Hash Tables via Relativistic Programming"
+,journal="ACM Operating Systems Review"
+,year=2010
+,volume=44
+,number=3
+,month="July"
+,annotation={
+	RP fun with hash tables.
+	http://portal.acm.org/citation.cfm?id=1842733.1842750
+}}
+
+@unpublished{PaulEMcKenney2010RCUAPI
+,Author="Paul E. McKenney"
+,Title="The {RCU} {API}, 2010 Edition"
+,month="December"
+,day="8"
+,year="2010"
+,note="Available:
+\url{http://lwn.net/Articles/418853/}
+[Viewed December 8, 2010]"
+,annotation="
+	Includes updated software-engineering features.
+"
+}
+
+@mastersthesis{AndrejPodzimek2010masters
+,author="Andrej Podzimek"
+,title="Read-Copy-Update for OpenSolaris"
+,school="Charles University in Prague"
+,year="2010"
+,note="Available:
+\url{https://andrej.podzimek.org/thesis.pdf}
+[Viewed January 31, 2011]"
+,annotation={
+	Reviews RCU implementations and creates a few for OpenSolaris.
+	Drives quiescent-state detection from RCU read-side primitives,
+	in a manner roughly similar to that of Jim Houston.
+}}
+
+@unpublished{LinusTorvalds2011Linux2:6:38:rc1:NPigginVFS
+,Author="Linus Torvalds"
+,Title="Linux 2.6.38-rc1"
+,month="January"
+,year="2011"
+,note="Available:
+\url{https://lkml.org/lkml/2011/1/18/322}
+[Viewed March 4, 2011]"
+,annotation={
+	"The RCU-based name lookup is at the other end of the spectrum - the
+	absolute anti-gimmick. It's some seriously good stuff, and gets rid of
+	the last main global lock that really tends to hurt some kernel loads.
+	The dentry lock is no longer a big serializing issue. What's really
+	nice about it is that it actually improves performance a lot even for
+	single-threaded loads (on an SMP kernel), because it gets rid of some
+	of the most expensive parts of path component lookup, which was the
+	d_lock on every component lookup. So I'm seeing improvements of 30-50%
+	on some seriously pathname-lookup intensive loads."
+}}
+
+@techreport{JoshTriplett2011RPScalableCorrectOrdering
+,author = {Josh Triplett and Philip W. Howard and Paul E. McKenney and Jonathan Walpole}
+,title = {Scalable Correct Memory Ordering via Relativistic Programming}
+,year = {2011}
+,number = {11-03}
+,institution = {Portland State University}
+,note = {\url{http://www.cs.pdx.edu/pdfs/tr1103.pdf}}
+}
+
+@inproceedings{PhilHoward2011RCUTMRBTree
+,author = {Philip W. Howard and Jonathan Walpole}
+,title = {A Relativistic Enhancement to Software Transactional Memory}
+,booktitle = {Proceedings of the 3rd USENIX conference on Hot topics in parallelism}
+,series = {HotPar'11}
+,year = {2011}
+,location = {Berkeley, CA}
+,pages = {1--6}
+,numpages = {6}
+,url = {http://www.usenix.org/event/hotpar11/tech/final_files/Howard.pdf}
+,publisher = {USENIX Association}
+,address = {Berkeley, CA, USA}
+}
+
+@techreport{PaulEMcKenney2011cyclicparallelRCU
+,author="Paul E. McKenney and Jonathan Walpole"
+,title="Efficient Support of Consistent Cyclic Search With Read-Copy Update and Parallel Updates"
+,institution="US Patent and Trademark Office"
+,address="Washington, DC"
+,year="2011"
+,number="US Patent 7,953,778"
+,month="May"
+,pages="34"
+,annotation="
+	Maintains an array of generation numbers to track in-flight
+	updates and keeps an additional level of indirection to allow
+	readers to confine themselves to the desired snapshot of the
+	data structure.
+"
+}
+
+@inproceedings{Triplett:2011:RPHash
+,author = {Triplett, Josh and McKenney, Paul E. and Walpole, Jonathan}
+,title = {Resizable, Scalable, Concurrent Hash Tables via Relativistic Programming}
+,booktitle = {Proceedings of the 2011 USENIX Annual Technical Conference}
+,month = {June}
+,year = {2011}
+,pages = {145--158}
+,numpages = {14}
+,url={http://www.usenix.org/event/atc11/tech/final_files/atc11_proceedings.pdf}
+,publisher = {The USENIX Association}
+,address = {Portland, OR USA}
+}
+
+@unpublished{PaulEMcKenney2011RCU3.0trainwreck
+,Author="Paul E. McKenney"
+,Title="3.0 and {RCU:} what went wrong"
+,month="July"
+,day="27"
+,year="2011"
+,note="Available:
+\url{http://lwn.net/Articles/453002/}
+[Viewed July 27, 2011]"
+,annotation="
+	Analysis of the RCU trainwreck in Linux kernel 3.0.
+"
+}
+
+@unpublished{NeilBrown2011MeetTheLockers
+,Author="Neil Brown"
+,Title="Meet the Lockers"
+,month="August"
+,day="3"
+,year="2011"
+,note="Available:
+\url{http://lwn.net/Articles/453685/}
+[Viewed September 2, 2011]"
+,annotation="
+	The Locker family as an analogy for locking, reference counting,
+	RCU, and seqlock.
+"
+}
+
+@article{MathieuDesnoyers2012URCU
+,Author="Mathieu Desnoyers and Paul E. McKenney and Alan Stern and Michel R. Dagenais and Jonathan Walpole"
+,Title="User-Level Implementations of Read-Copy Update"
+,journal="IEEE Transactions on Parallel and Distributed Systems"
+,volume={23}
+,year="2012"
+,issn="1045-9219"
+,pages="375-382"
+,doi="http://doi.ieeecomputersociety.org/10.1109/TPDS.2011.159"
+,publisher="IEEE Computer Society"
+,address="Los Alamitos, CA, USA"
+,annotation={
+	RCU overview, desiderata, semi-formal semantics, user-level RCU
+	usage scenarios, three classes of RCU implementation, wait-free
+	RCU updates, RCU grace-period batching, update overhead,
+	http://www.rdrop.com/users/paulmck/RCU/urcu-main-accepted.2011.08.30a.pdf
+	http://www.rdrop.com/users/paulmck/RCU/urcu-supp-accepted.2011.08.30a.pdf
+}
 }
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index bff2d8b..5c8d749 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -180,6 +180,20 @@ over a rather long period of time, but improvements are always welcome!
 	operations that would not normally be undertaken while a real-time
 	workload is running.
 
+	In particular, if you find yourself invoking one of the expedited
+	primitives repeatedly in a loop, please do everyone a favor:
+	Restructure your code so that it batches the updates, allowing
+	a single non-expedited primitive to cover the entire batch.
+	This will very likely be faster than the loop containing the
+	expedited primitive, and will be much much easier on the rest
+	of the system, especially to real-time workloads running on
+	the rest of the system.
+
+	In addition, it is illegal to call the expedited forms from
+	a CPU-hotplug notifier, or while holding a lock that is acquired
+	by a CPU-hotplug notifier.  Failing to observe this restriction
+	will result in deadlock.
+
 7.	If the updater uses call_rcu() or synchronize_rcu(), then the
 	corresponding readers must use rcu_read_lock() and
 	rcu_read_unlock().  If the updater uses call_rcu_bh() or
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 083d88c..523364e 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -12,14 +12,38 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
 	This kernel configuration parameter defines the period of time
 	that RCU will wait from the beginning of a grace period until it
 	issues an RCU CPU stall warning.  This time period is normally
-	ten seconds.
+	sixty seconds.
 
-RCU_SECONDS_TILL_STALL_RECHECK
+	This configuration parameter may be changed at runtime via the
+	/sys/module/rcutree/parameters/rcu_cpu_stall_timeout, however
+	this parameter is checked only at the beginning of a cycle.
+	So if you are 30 seconds into a 70-second stall, setting this
+	sysfs parameter to (say) five will shorten the timeout for the
+	-next- stall, or the following warning for the current stall
+	(assuming the stall lasts long enough).  It will not affect the
+	timing of the next warning for the current stall.
 
-	This macro defines the period of time that RCU will wait after
-	issuing a stall warning until it issues another stall warning
-	for the same stall.  This time period is normally set to three
-	times the check interval plus thirty seconds.
+	Stall-warning messages may be enabled and disabled completely via
+	/sys/module/rcutree/parameters/rcu_cpu_stall_suppress.
+
+CONFIG_RCU_CPU_STALL_VERBOSE
+
+	This kernel configuration parameter causes the stall warning to
+	also dump the stacks of any tasks that are blocking the current
+	RCU-preempt grace period.
+
+RCU_CPU_STALL_INFO
+
+	This kernel configuration parameter causes the stall warning to
+	print out additional per-CPU diagnostic information, including
+	information on scheduling-clock ticks and RCU's idle-CPU tracking.
+
+RCU_STALL_DELAY_DELTA
+
+	Although the lockdep facility is extremely useful, it does add
+	some overhead.  Therefore, under CONFIG_PROVE_RCU, the
+	RCU_STALL_DELAY_DELTA macro allows five extra seconds before
+	giving an RCU CPU stall warning message.
 
 RCU_STALL_RAT_DELAY
 
@@ -64,6 +88,54 @@ INFO: rcu_bh_state detected stalls on CPUs/tasks: { } (detected by 4, 2502 jiffi
 
 This is rare, but does happen from time to time in real life.
 
+If the CONFIG_RCU_CPU_STALL_INFO kernel configuration parameter is set,
+more information is printed with the stall-warning message, for example:
+
+	INFO: rcu_preempt detected stall on CPU
+	0: (63959 ticks this GP) idle=241/3fffffffffffffff/0
+	   (t=65000 jiffies)
+
+In kernels with CONFIG_RCU_FAST_NO_HZ, even more information is
+printed:
+
+	INFO: rcu_preempt detected stall on CPU
+	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 drain=0 . timer=-1
+	   (t=65000 jiffies)
+
+The "(64628 ticks this GP)" indicates that this CPU has taken more
+than 64,000 scheduling-clock interrupts during the current stalled
+grace period.  If the CPU was not yet aware of the current grace
+period (for example, if it was offline), then this part of the message
+indicates how many grace periods behind the CPU is.
+
+The "idle=" portion of the message prints the dyntick-idle state.
+The hex number before the first "/" is the low-order 12 bits of the
+dynticks counter, which will have an even-numbered value if the CPU is
+in dyntick-idle mode and an odd-numbered value otherwise.  The hex
+number between the two "/"s is the value of the nesting, which will
+be a small positive number if in the idle loop and a very large positive
+number (as shown above) otherwise.
+
+For CONFIG_RCU_FAST_NO_HZ kernels, the "drain=0" indicates that the
+CPU is not in the process of trying to force itself into dyntick-idle
+state, the "." indicates that the CPU has not given up forcing RCU
+into dyntick-idle mode (it would be "H" otherwise), and the "timer=-1"
+indicates that the CPU has not recented forced RCU into dyntick-idle
+mode (it would otherwise indicate the number of microseconds remaining
+in this forced state).
+
+
+Multiple Warnings From One Stall
+
+If a stall lasts long enough, multiple stall-warning messages will be
+printed for it.  The second and subsequent messages are printed at
+longer intervals, so that the time between (say) the first and second
+message will be about three times the interval between the beginning
+of the stall and the first message.
+
+
+What Causes RCU CPU Stall Warnings?
+
 So your kernel printed an RCU CPU stall warning.  The next question is
 "What caused it?"  The following problems can result in RCU CPU stall
 warnings:
@@ -128,4 +200,5 @@ is occurring, which will usually be in the function nearest the top of
 that portion of the stack which remains the same from trace to trace.
 If you can reliably trigger the stall, ftrace can be quite helpful.
 
-RCU bugs can often be debugged with the help of CONFIG_RCU_TRACE.
+RCU bugs can often be debugged with the help of CONFIG_RCU_TRACE
+and with RCU's event tracing.
diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index d67068d..375d3fb 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -69,6 +69,13 @@ onoff_interval
 		CPU-hotplug operations regardless of what value is
 		specified for onoff_interval.
 
+onoff_holdoff	The number of seconds to wait until starting CPU-hotplug
+		operations.  This would normally only be used when
+		rcutorture was built into the kernel and started
+		automatically at boot time, in which case it is useful
+		in order to avoid confusing boot-time code with CPUs
+		coming and going.
+
 shuffle_interval
 		The number of seconds to keep the test threads affinitied
 		to a particular subset of the CPUs, defaults to 3 seconds.
@@ -79,6 +86,24 @@ shutdown_secs	The number of seconds to run the test before terminating
 		zero, which disables test termination and system shutdown.
 		This capability is useful for automated testing.
 
+stall_cpu	The number of seconds that a CPU should be stalled while
+		within both an rcu_read_lock() and a preempt_disable().
+		This stall happens only once per rcutorture run.
+		If you need multiple stalls, use modprobe and rmmod to
+		repeatedly run rcutorture.  The default for stall_cpu
+		is zero, which prevents rcutorture from stalling a CPU.
+
+		Note that attempts to rmmod rcutorture while the stall
+		is ongoing will hang, so be careful what value you
+		choose for this module parameter!  In addition, too-large
+		values for stall_cpu might well induce failures and
+		warnings in other parts of the kernel.  You have been
+		warned!
+
+stall_cpu_holdoff
+		The number of seconds to wait after rcutorture starts
+		before stalling a CPU.  Defaults to 10 seconds.
+
 stat_interval	The number of seconds between output of torture
 		statistics (via printk()).  Regardless of the interval,
 		statistics are printed when the module is unloaded.
@@ -271,11 +296,13 @@ The following script may be used to torture RCU:
 	#!/bin/sh
 
 	modprobe rcutorture
-	sleep 100
+	sleep 3600
 	rmmod rcutorture
 	dmesg | grep torture:
 
 The output can be manually inspected for the error flag of "!!!".
 One could of course create a more elaborate script that automatically
-checked for such errors.  The "rmmod" command forces a "SUCCESS" or
-"FAILURE" indication to be printk()ed.
+checked for such errors.  The "rmmod" command forces a "SUCCESS",
+"FAILURE", or "RCU_HOTPLUG" indication to be printk()ed.  The first
+two are self-explanatory, while the last indicates that while there
+were no RCU failures, CPU-hotplug problems were detected.
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 49587ab..f6f15ce 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -33,23 +33,23 @@ rcu/rcuboost:
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu_sched:
-  0 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=545/1/0 df=50 of=0 ri=0 ql=163 qs=NRW. kt=0/W/0 ktl=ebc3 b=10 ci=153737 co=0 ca=0
-  1 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=967/1/0 df=58 of=0 ri=0 ql=634 qs=NRW. kt=0/W/1 ktl=58c b=10 ci=191037 co=0 ca=0
-  2 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1081/1/0 df=175 of=0 ri=0 ql=74 qs=N.W. kt=0/W/2 ktl=da94 b=10 ci=75991 co=0 ca=0
-  3 c=20942 g=20943 pq=1 pgp=20942 qp=1 dt=1846/0/0 df=404 of=0 ri=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=72261 co=0 ca=0
-  4 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=369/1/0 df=83 of=0 ri=0 ql=48 qs=N.W. kt=0/W/4 ktl=e0e7 b=10 ci=128365 co=0 ca=0
-  5 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=381/1/0 df=64 of=0 ri=0 ql=169 qs=NRW. kt=0/W/5 ktl=fb2f b=10 ci=164360 co=0 ca=0
-  6 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1037/1/0 df=183 of=0 ri=0 ql=62 qs=N.W. kt=0/W/6 ktl=d2ad b=10 ci=65663 co=0 ca=0
-  7 c=20897 g=20897 pq=1 pgp=20896 qp=0 dt=1572/0/0 df=382 of=0 ri=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=75006 co=0 ca=0
+  0 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=545/1/0 df=50 of=0 ql=163 qs=NRW. kt=0/W/0 ktl=ebc3 b=10 ci=153737 co=0 ca=0
+  1 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=967/1/0 df=58 of=0 ql=634 qs=NRW. kt=0/W/1 ktl=58c b=10 ci=191037 co=0 ca=0
+  2 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1081/1/0 df=175 of=0 ql=74 qs=N.W. kt=0/W/2 ktl=da94 b=10 ci=75991 co=0 ca=0
+  3 c=20942 g=20943 pq=1 pgp=20942 qp=1 dt=1846/0/0 df=404 of=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=72261 co=0 ca=0
+  4 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=369/1/0 df=83 of=0 ql=48 qs=N.W. kt=0/W/4 ktl=e0e7 b=10 ci=128365 co=0 ca=0
+  5 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=381/1/0 df=64 of=0 ql=169 qs=NRW. kt=0/W/5 ktl=fb2f b=10 ci=164360 co=0 ca=0
+  6 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1037/1/0 df=183 of=0 ql=62 qs=N.W. kt=0/W/6 ktl=d2ad b=10 ci=65663 co=0 ca=0
+  7 c=20897 g=20897 pq=1 pgp=20896 qp=0 dt=1572/0/0 df=382 of=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=75006 co=0 ca=0
 rcu_bh:
-  0 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=545/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/0 ktl=ebc3 b=10 ci=0 co=0 ca=0
-  1 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=967/1/0 df=3 of=0 ri=1 ql=0 qs=.... kt=0/W/1 ktl=58c b=10 ci=151 co=0 ca=0
-  2 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1081/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/2 ktl=da94 b=10 ci=0 co=0 ca=0
-  3 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1846/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=0 co=0 ca=0
-  4 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=369/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/4 ktl=e0e7 b=10 ci=0 co=0 ca=0
-  5 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=381/1/0 df=4 of=0 ri=1 ql=0 qs=.... kt=0/W/5 ktl=fb2f b=10 ci=0 co=0 ca=0
-  6 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1037/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/6 ktl=d2ad b=10 ci=0 co=0 ca=0
-  7 c=1474 g=1474 pq=1 pgp=1473 qp=0 dt=1572/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=0 co=0 ca=0
+  0 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=545/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/0 ktl=ebc3 b=10 ci=0 co=0 ca=0
+  1 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=967/1/0 df=3 of=0 ql=0 qs=.... kt=0/W/1 ktl=58c b=10 ci=151 co=0 ca=0
+  2 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1081/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/2 ktl=da94 b=10 ci=0 co=0 ca=0
+  3 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1846/0/0 df=8 of=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=0 co=0 ca=0
+  4 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=369/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/4 ktl=e0e7 b=10 ci=0 co=0 ca=0
+  5 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=381/1/0 df=4 of=0 ql=0 qs=.... kt=0/W/5 ktl=fb2f b=10 ci=0 co=0 ca=0
+  6 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1037/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/6 ktl=d2ad b=10 ci=0 co=0 ca=0
+  7 c=1474 g=1474 pq=1 pgp=1473 qp=0 dt=1572/0/0 df=8 of=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=0 co=0 ca=0
 
 The first section lists the rcu_data structures for rcu_sched, the second
 for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
@@ -119,10 +119,6 @@ o	"of" is the number of times that some other CPU has forced a
 	CPU is offline when it is really alive and kicking) is a fatal
 	error, so it makes sense to err conservatively.
 
-o	"ri" is the number of times that RCU has seen fit to send a
-	reschedule IPI to this CPU in order to get it to report a
-	quiescent state.
-
 o	"ql" is the number of RCU callbacks currently residing on
 	this CPU.  This is the total number of callbacks, regardless
 	of what state they are in (new, waiting for grace period to
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index b9a7fdd..e30b2df 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -165,13 +165,6 @@ static inline int ext_hash(u16 code)
 	return (code + (code >> 9)) & 0xff;
 }
 
-static void ext_int_hash_update(struct rcu_head *head)
-{
-	struct ext_int_info *p = container_of(head, struct ext_int_info, rcu);
-
-	kfree(p);
-}
-
 int register_external_interrupt(u16 code, ext_int_handler_t handler)
 {
 	struct ext_int_info *p;
@@ -202,7 +195,7 @@ int unregister_external_interrupt(u16 code, ext_int_handler_t handler)
 	list_for_each_entry_rcu(p, &ext_int_hash[index], entry)
 		if (p->code == code && p->handler == handler) {
 			list_del_rcu(&p->entry);
-			call_rcu(&p->rcu, ext_int_hash_update);
+			kfree_rcu(p, rcu);
 		}
 	spin_unlock_irqrestore(&ext_int_hash_lock, flags);
 	return 0;
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 4c0507c..eff512b 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -86,16 +86,6 @@ static struct ft_tport *ft_tport_create(struct fc_lport *lport)
 }
 
 /*
- * Free tport via RCU.
- */
-static void ft_tport_rcu_free(struct rcu_head *rcu)
-{
-	struct ft_tport *tport = container_of(rcu, struct ft_tport, rcu);
-
-	kfree(tport);
-}
-
-/*
  * Delete a target local port.
  * Caller holds ft_lport_lock.
  */
@@ -114,7 +104,7 @@ static void ft_tport_delete(struct ft_tport *tport)
 		tpg->tport = NULL;
 		tport->tpg = NULL;
 	}
-	call_rcu(&tport->rcu, ft_tport_rcu_free);
+	kfree_rcu(tport, rcu);
 }
 
 /*
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 81c04f4..9372174 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -190,6 +190,33 @@ extern void rcu_idle_exit(void);
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
 
+/**
+ * RCU_NONIDLE - Indicate idle-loop code that needs RCU readers
+ * @a: Code that RCU needs to pay attention to.
+ *
+ * RCU, RCU-bh, and RCU-sched read-side critical sections are forbidden
+ * in the inner idle loop, that is, between the rcu_idle_enter() and
+ * the rcu_idle_exit() -- RCU will happily ignore any such read-side
+ * critical sections.  However, things like powertop need tracepoints
+ * in the inner idle loop.
+ *
+ * This macro provides the way out:  RCU_NONIDLE(do_something_with_RCU())
+ * will tell RCU that it needs to pay attending, invoke its argument
+ * (in this example, a call to the do_something_with_RCU() function),
+ * and then tell RCU to go back to ignoring this CPU.  It is permissible
+ * to nest RCU_NONIDLE() wrappers, but the nesting level is currently
+ * quite limited.  If deeper nesting is required, it will be necessary
+ * to adjust DYNTICK_TASK_NESTING_VALUE accordingly.
+ *
+ * This macro may be used from process-level code only.
+ */
+#define RCU_NONIDLE(a) \
+	do { \
+		rcu_idle_exit(); \
+		do { a; } while (0); \
+		rcu_idle_enter(); \
+	} while (0)
+
 /*
  * Infrastructure to implement the synchronize_() primitives in
  * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
@@ -226,6 +253,15 @@ static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
 }
 #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
+#if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU)
+bool rcu_lockdep_current_cpu_online(void);
+#else /* #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
+static inline bool rcu_lockdep_current_cpu_online(void)
+{
+	return 1;
+}
+#endif /* #else #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 #ifdef CONFIG_PROVE_RCU
@@ -239,13 +275,11 @@ static inline int rcu_is_cpu_idle(void)
 
 static inline void rcu_lock_acquire(struct lockdep_map *map)
 {
-	WARN_ON_ONCE(rcu_is_cpu_idle());
 	lock_acquire(map, 0, 0, 2, 1, NULL, _THIS_IP_);
 }
 
 static inline void rcu_lock_release(struct lockdep_map *map)
 {
-	WARN_ON_ONCE(rcu_is_cpu_idle());
 	lock_release(map, 1, _THIS_IP_);
 }
 
@@ -270,6 +304,9 @@ extern int debug_lockdep_rcu_enabled(void);
  * occur in the same context, for example, it is illegal to invoke
  * rcu_read_unlock() in process context if the matching rcu_read_lock()
  * was invoked from within an irq handler.
+ *
+ * Note that rcu_read_lock() is disallowed if the CPU is either idle or
+ * offline from an RCU perspective, so check for those as well.
  */
 static inline int rcu_read_lock_held(void)
 {
@@ -277,6 +314,8 @@ static inline int rcu_read_lock_held(void)
 		return 1;
 	if (rcu_is_cpu_idle())
 		return 0;
+	if (!rcu_lockdep_current_cpu_online())
+		return 0;
 	return lock_is_held(&rcu_lock_map);
 }
 
@@ -313,6 +352,9 @@ extern int rcu_read_lock_bh_held(void);
  * notice an extended quiescent state to other CPUs that started a grace
  * period. Otherwise we would delay any grace period as long as we run in
  * the idle task.
+ *
+ * Similarly, we avoid claiming an SRCU read lock held if the current
+ * CPU is offline.
  */
 #ifdef CONFIG_PREEMPT_COUNT
 static inline int rcu_read_lock_sched_held(void)
@@ -323,6 +365,8 @@ static inline int rcu_read_lock_sched_held(void)
 		return 1;
 	if (rcu_is_cpu_idle())
 		return 0;
+	if (!rcu_lockdep_current_cpu_online())
+		return 0;
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
 	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
@@ -381,8 +425,22 @@ extern int rcu_my_thread_group_empty(void);
 		}							\
 	} while (0)
 
+#if defined(CONFIG_PROVE_RCU) && !defined(CONFIG_PREEMPT_RCU)
+static inline void rcu_preempt_sleep_check(void)
+{
+	rcu_lockdep_assert(!lock_is_held(&rcu_lock_map),
+			   "Illegal context switch in RCU read-side "
+			   "critical section");
+}
+#else /* #ifdef CONFIG_PROVE_RCU */
+static inline void rcu_preempt_sleep_check(void)
+{
+}
+#endif /* #else #ifdef CONFIG_PROVE_RCU */
+
 #define rcu_sleep_check()						\
 	do {								\
+		rcu_preempt_sleep_check();				\
 		rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),	\
 				   "Illegal context switch in RCU-bh"	\
 				   " read-side critical section");	\
@@ -470,6 +528,13 @@ extern int rcu_my_thread_group_empty(void);
  * NULL.  Although rcu_access_pointer() may also be used in cases where
  * update-side locks prevent the value of the pointer from changing, you
  * should instead use rcu_dereference_protected() for this use case.
+ *
+ * It is also permissible to use rcu_access_pointer() when read-side
+ * access to the pointer was removed at least one grace period ago, as
+ * is the case in the context of the RCU callback that is freeing up
+ * the data, or after a synchronize_rcu() returns.  This can be useful
+ * when tearing down multi-linked structures after a grace period
+ * has elapsed.
  */
 #define rcu_access_pointer(p) __rcu_access_pointer((p), __rcu)
 
@@ -659,6 +724,8 @@ static inline void rcu_read_lock(void)
 	__rcu_read_lock();
 	__acquire(RCU);
 	rcu_lock_acquire(&rcu_lock_map);
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "rcu_read_lock() used illegally while idle");
 }
 
 /*
@@ -678,6 +745,8 @@ static inline void rcu_read_lock(void)
  */
 static inline void rcu_read_unlock(void)
 {
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "rcu_read_unlock() used illegally while idle");
 	rcu_lock_release(&rcu_lock_map);
 	__release(RCU);
 	__rcu_read_unlock();
@@ -705,6 +774,8 @@ static inline void rcu_read_lock_bh(void)
 	local_bh_disable();
 	__acquire(RCU_BH);
 	rcu_lock_acquire(&rcu_bh_lock_map);
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "rcu_read_lock_bh() used illegally while idle");
 }
 
 /*
@@ -714,6 +785,8 @@ static inline void rcu_read_lock_bh(void)
  */
 static inline void rcu_read_unlock_bh(void)
 {
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "rcu_read_unlock_bh() used illegally while idle");
 	rcu_lock_release(&rcu_bh_lock_map);
 	__release(RCU_BH);
 	local_bh_enable();
@@ -737,6 +810,8 @@ static inline void rcu_read_lock_sched(void)
 	preempt_disable();
 	__acquire(RCU_SCHED);
 	rcu_lock_acquire(&rcu_sched_lock_map);
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "rcu_read_lock_sched() used illegally while idle");
 }
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
@@ -753,6 +828,8 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
  */
 static inline void rcu_read_unlock_sched(void)
 {
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "rcu_read_unlock_sched() used illegally while idle");
 	rcu_lock_release(&rcu_sched_lock_map);
 	__release(RCU_SCHED);
 	preempt_enable();
@@ -841,7 +918,7 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
 	/* See the kfree_rcu() header comment. */
 	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
 
-	call_rcu(head, (rcu_callback)offset);
+	kfree_call_rcu(head, (rcu_callback)offset);
 }
 
 /**
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 00b7a5e..e93df77 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -27,13 +27,9 @@
 
 #include <linux/cache.h>
 
-#ifdef CONFIG_RCU_BOOST
 static inline void rcu_init(void)
 {
 }
-#else /* #ifdef CONFIG_RCU_BOOST */
-void rcu_init(void);
-#endif /* #else #ifdef CONFIG_RCU_BOOST */
 
 static inline void rcu_barrier_bh(void)
 {
@@ -83,6 +79,12 @@ static inline void synchronize_sched_expedited(void)
 	synchronize_sched();
 }
 
+static inline void kfree_call_rcu(struct rcu_head *head,
+				  void (*func)(struct rcu_head *rcu))
+{
+	call_rcu(head, func);
+}
+
 #ifdef CONFIG_TINY_RCU
 
 static inline void rcu_preempt_note_context_switch(void)
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 6745846..e8ee5dd 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -61,6 +61,24 @@ extern void synchronize_rcu_bh(void);
 extern void synchronize_sched_expedited(void);
 extern void synchronize_rcu_expedited(void);
 
+void kfree_call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
+
+/**
+ * synchronize_rcu_bh_expedited - Brute-force RCU-bh grace period
+ *
+ * Wait for an RCU-bh grace period to elapse, but use a "big hammer"
+ * approach to force the grace period to end quickly.  This consumes
+ * significant time on all CPUs and is unfriendly to real-time workloads,
+ * so is thus not recommended for any sort of common-case code.  In fact,
+ * if you are using synchronize_rcu_bh_expedited() in a loop, please
+ * restructure your code to batch your updates, and then use a single
+ * synchronize_rcu_bh() instead.
+ *
+ * Note that it is illegal to call this function while holding any lock
+ * that is acquired by a CPU-hotplug notifier.  And yes, it is also illegal
+ * to call this function from a CPU-hotplug notifier.  Failing to observe
+ * these restriction will result in deadlock.
+ */
 static inline void synchronize_rcu_bh_expedited(void)
 {
 	synchronize_sched_expedited();
@@ -83,6 +101,7 @@ extern void rcu_sched_force_quiescent_state(void);
 /* A context switch is a grace period for RCU-sched and RCU-bh. */
 static inline int rcu_blocking_is_gp(void)
 {
+	might_sleep();  /* Check for RCU read-side critical section. */
 	return num_online_cpus() == 1;
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d379a6..e692aba 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1864,8 +1864,7 @@ extern void task_clear_jobctl_pending(struct task_struct *task,
 #ifdef CONFIG_PREEMPT_RCU
 
 #define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
-#define RCU_READ_UNLOCK_BOOSTED (1 << 1) /* boosted while in RCU read-side. */
-#define RCU_READ_UNLOCK_NEED_QS (1 << 2) /* RCU core needs CPU response. */
+#define RCU_READ_UNLOCK_NEED_QS (1 << 1) /* RCU core needs CPU response. */
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index e1b0059..d3d5fa5 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -99,15 +99,18 @@ long srcu_batches_completed(struct srcu_struct *sp);
  * power mode. This way we can notice an extended quiescent state to
  * other CPUs that started a grace period. Otherwise we would delay any
  * grace period as long as we run in the idle task.
+ *
+ * Similarly, we avoid claiming an SRCU read lock held if the current
+ * CPU is offline.
  */
 static inline int srcu_read_lock_held(struct srcu_struct *sp)
 {
-	if (rcu_is_cpu_idle())
-		return 0;
-
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
-
+	if (rcu_is_cpu_idle())
+		return 0;
+	if (!rcu_lockdep_current_cpu_online())
+		return 0;
 	return lock_is_held(&sp->dep_map);
 }
 
@@ -169,6 +172,8 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 	int retval = __srcu_read_lock(sp);
 
 	rcu_lock_acquire(&(sp)->dep_map);
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "srcu_read_lock() used illegally while idle");
 	return retval;
 }
 
@@ -182,6 +187,8 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__releases(sp)
 {
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "srcu_read_unlock() used illegally while idle");
 	rcu_lock_release(&(sp)->dep_map);
 	__srcu_read_unlock(sp, idx);
 }
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index d2d88be..3370997 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -313,19 +313,22 @@ TRACE_EVENT(rcu_prep_idle,
 /*
  * Tracepoint for the registration of a single RCU callback function.
  * The first argument is the type of RCU, the second argument is
- * a pointer to the RCU callback itself, and the third element is the
- * new RCU callback queue length for the current CPU.
+ * a pointer to the RCU callback itself, the third element is the
+ * number of lazy callbacks queued, and the fourth element is the
+ * total number of callbacks queued.
  */
 TRACE_EVENT(rcu_callback,
 
-	TP_PROTO(char *rcuname, struct rcu_head *rhp, long qlen),
+	TP_PROTO(char *rcuname, struct rcu_head *rhp, long qlen_lazy,
+		 long qlen),
 
-	TP_ARGS(rcuname, rhp, qlen),
+	TP_ARGS(rcuname, rhp, qlen_lazy, qlen),
 
 	TP_STRUCT__entry(
 		__field(char *, rcuname)
 		__field(void *, rhp)
 		__field(void *, func)
+		__field(long, qlen_lazy)
 		__field(long, qlen)
 	),
 
@@ -333,11 +336,13 @@ TRACE_EVENT(rcu_callback,
 		__entry->rcuname = rcuname;
 		__entry->rhp = rhp;
 		__entry->func = rhp->func;
+		__entry->qlen_lazy = qlen_lazy;
 		__entry->qlen = qlen;
 	),
 
-	TP_printk("%s rhp=%p func=%pf %ld",
-		  __entry->rcuname, __entry->rhp, __entry->func, __entry->qlen)
+	TP_printk("%s rhp=%p func=%pf %ld/%ld",
+		  __entry->rcuname, __entry->rhp, __entry->func,
+		  __entry->qlen_lazy, __entry->qlen)
 );
 
 /*
@@ -345,20 +350,21 @@ TRACE_EVENT(rcu_callback,
  * kfree() form.  The first argument is the RCU type, the second argument
  * is a pointer to the RCU callback, the third argument is the offset
  * of the callback within the enclosing RCU-protected data structure,
- * and the fourth argument is the new RCU callback queue length for the
- * current CPU.
+ * the fourth argument is the number of lazy callbacks queued, and the
+ * fifth argument is the total number of callbacks queued.
  */
 TRACE_EVENT(rcu_kfree_callback,
 
 	TP_PROTO(char *rcuname, struct rcu_head *rhp, unsigned long offset,
-		 long qlen),
+		 long qlen_lazy, long qlen),
 
-	TP_ARGS(rcuname, rhp, offset, qlen),
+	TP_ARGS(rcuname, rhp, offset, qlen_lazy, qlen),
 
 	TP_STRUCT__entry(
 		__field(char *, rcuname)
 		__field(void *, rhp)
 		__field(unsigned long, offset)
+		__field(long, qlen_lazy)
 		__field(long, qlen)
 	),
 
@@ -366,41 +372,45 @@ TRACE_EVENT(rcu_kfree_callback,
 		__entry->rcuname = rcuname;
 		__entry->rhp = rhp;
 		__entry->offset = offset;
+		__entry->qlen_lazy = qlen_lazy;
 		__entry->qlen = qlen;
 	),
 
-	TP_printk("%s rhp=%p func=%ld %ld",
+	TP_printk("%s rhp=%p func=%ld %ld/%ld",
 		  __entry->rcuname, __entry->rhp, __entry->offset,
-		  __entry->qlen)
+		  __entry->qlen_lazy, __entry->qlen)
 );
 
 /*
  * Tracepoint for marking the beginning rcu_do_batch, performed to start
  * RCU callback invocation.  The first argument is the RCU flavor,
- * the second is the total number of callbacks (including those that
- * are not yet ready to be invoked), and the third argument is the
- * current RCU-callback batch limit.
+ * the second is the number of lazy callbacks queued, the third is
+ * the total number of callbacks queued, and the fourth argument is
+ * the current RCU-callback batch limit.
  */
 TRACE_EVENT(rcu_batch_start,
 
-	TP_PROTO(char *rcuname, long qlen, int blimit),
+	TP_PROTO(char *rcuname, long qlen_lazy, long qlen, int blimit),
 
-	TP_ARGS(rcuname, qlen, blimit),
+	TP_ARGS(rcuname, qlen_lazy, qlen, blimit),
 
 	TP_STRUCT__entry(
 		__field(char *, rcuname)
+		__field(long, qlen_lazy)
 		__field(long, qlen)
 		__field(int, blimit)
 	),
 
 	TP_fast_assign(
 		__entry->rcuname = rcuname;
+		__entry->qlen_lazy = qlen_lazy;
 		__entry->qlen = qlen;
 		__entry->blimit = blimit;
 	),
 
-	TP_printk("%s CBs=%ld bl=%d",
-		  __entry->rcuname, __entry->qlen, __entry->blimit)
+	TP_printk("%s CBs=%ld/%ld bl=%d",
+		  __entry->rcuname, __entry->qlen_lazy, __entry->qlen,
+		  __entry->blimit)
 );
 
 /*
@@ -531,16 +541,21 @@ TRACE_EVENT(rcu_torture_read,
 #else /* #ifdef CONFIG_RCU_TRACE */
 
 #define trace_rcu_grace_period(rcuname, gpnum, gpevent) do { } while (0)
-#define trace_rcu_grace_period_init(rcuname, gpnum, level, grplo, grphi, qsmask) do { } while (0)
+#define trace_rcu_grace_period_init(rcuname, gpnum, level, grplo, grphi, \
+				    qsmask) do { } while (0)
 #define trace_rcu_preempt_task(rcuname, pid, gpnum) do { } while (0)
 #define trace_rcu_unlock_preempted_task(rcuname, gpnum, pid) do { } while (0)
-#define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, grplo, grphi, gp_tasks) do { } while (0)
+#define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, \
+					 grplo, grphi, gp_tasks) do { } \
+	while (0)
 #define trace_rcu_fqs(rcuname, gpnum, cpu, qsevent) do { } while (0)
 #define trace_rcu_dyntick(polarity, oldnesting, newnesting) do { } while (0)
 #define trace_rcu_prep_idle(reason) do { } while (0)
-#define trace_rcu_callback(rcuname, rhp, qlen) do { } while (0)
-#define trace_rcu_kfree_callback(rcuname, rhp, offset, qlen) do { } while (0)
-#define trace_rcu_batch_start(rcuname, qlen, blimit) do { } while (0)
+#define trace_rcu_callback(rcuname, rhp, qlen_lazy, qlen) do { } while (0)
+#define trace_rcu_kfree_callback(rcuname, rhp, offset, qlen_lazy, qlen) \
+	do { } while (0)
+#define trace_rcu_batch_start(rcuname, qlen_lazy, qlen, blimit) \
+	do { } while (0)
 #define trace_rcu_invoke_callback(rcuname, rhp) do { } while (0)
 #define trace_rcu_invoke_kfree_callback(rcuname, rhp, offset) do { } while (0)
 #define trace_rcu_batch_end(rcuname, callbacks_invoked, cb, nr, iit, risk) \
diff --git a/init/Kconfig b/init/Kconfig
index 3f42cd6..72f33fa 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -438,15 +438,6 @@ config PREEMPT_RCU
 	  This option enables preemptible-RCU code that is common between
 	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
 
-config RCU_TRACE
-	bool "Enable tracing for RCU"
-	help
-	  This option provides tracing in RCU which presents stats
-	  in debugfs for debugging RCU implementation.
-
-	  Say Y here if you want to enable RCU tracing
-	  Say N if you are unsure.
-
 config RCU_FANOUT
 	int "Tree-based hierarchical RCU fanout value"
 	range 2 64 if 64BIT
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8889f7d..ea9ee45 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -4176,7 +4176,13 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 	printk("-------------------------------\n");
 	printk("%s:%d %s!\n", file, line, s);
 	printk("\nother info that might help us debug this:\n\n");
-	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
+	printk("\n%srcu_scheduler_active = %d, debug_locks = %d\n",
+	       !rcu_lockdep_current_cpu_online()
+			? "RCU used illegally from offline CPU!\n"
+			: rcu_is_cpu_idle()
+				? "RCU used illegally from idle CPU!\n"
+				: "",
+	       rcu_scheduler_active, debug_locks);
 
 	/*
 	 * If a CPU is in the RCU-free window in idle (ie: in the section
diff --git a/kernel/rcu.h b/kernel/rcu.h
index aa88baa..8ba99cd 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -33,8 +33,27 @@
  * Process-level increment to ->dynticks_nesting field.  This allows for
  * architectures that use half-interrupts and half-exceptions from
  * process context.
+ *
+ * DYNTICK_TASK_NEST_MASK defines a field of width DYNTICK_TASK_NEST_WIDTH
+ * that counts the number of process-based reasons why RCU cannot
+ * consider the corresponding CPU to be idle, and DYNTICK_TASK_NEST_VALUE
+ * is the value used to increment or decrement this field.
+ *
+ * The rest of the bits could in principle be used to count interrupts,
+ * but this would mean that a negative-one value in the interrupt
+ * field could incorrectly zero out the DYNTICK_TASK_NEST_MASK field.
+ * We therefore provide a two-bit guard field defined by DYNTICK_TASK_MASK
+ * that is set to DYNTICK_TASK_FLAG upon initial exit from idle.
+ * The DYNTICK_TASK_EXIT_IDLE value is thus the combined value used upon
+ * initial exit from idle.
  */
-#define DYNTICK_TASK_NESTING (LLONG_MAX / 2 - 1)
+#define DYNTICK_TASK_NEST_WIDTH 7
+#define DYNTICK_TASK_NEST_VALUE ((LLONG_MAX >> DYNTICK_TASK_NEST_WIDTH) + 1)
+#define DYNTICK_TASK_NEST_MASK  (LLONG_MAX - DYNTICK_TASK_NEST_VALUE + 1)
+#define DYNTICK_TASK_FLAG	   ((DYNTICK_TASK_NEST_VALUE / 8) * 2)
+#define DYNTICK_TASK_MASK	   ((DYNTICK_TASK_NEST_VALUE / 8) * 3)
+#define DYNTICK_TASK_EXIT_IDLE	   (DYNTICK_TASK_NEST_VALUE + \
+				    DYNTICK_TASK_FLAG)
 
 /*
  * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
@@ -50,7 +69,6 @@ extern struct debug_obj_descr rcuhead_debug_descr;
 
 static inline void debug_rcu_head_queue(struct rcu_head *head)
 {
-	WARN_ON_ONCE((unsigned long)head & 0x3);
 	debug_object_activate(head, &rcuhead_debug_descr);
 	debug_object_active_state(head, &rcuhead_debug_descr,
 				  STATE_RCU_HEAD_READY,
@@ -76,16 +94,18 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 
 extern void kfree(const void *);
 
-static inline void __rcu_reclaim(char *rn, struct rcu_head *head)
+static inline bool __rcu_reclaim(char *rn, struct rcu_head *head)
 {
 	unsigned long offset = (unsigned long)head->func;
 
 	if (__is_kfree_rcu_offset(offset)) {
 		RCU_TRACE(trace_rcu_invoke_kfree_callback(rn, head, offset));
 		kfree((void *)head - offset);
+		return 1;
 	} else {
 		RCU_TRACE(trace_rcu_invoke_callback(rn, head));
 		head->func(head);
+		return 0;
 	}
 }
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 2bc4e13..a86f174 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -88,6 +88,9 @@ EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
  * section.
  *
  * Check debug_lockdep_rcu_enabled() to prevent false positives during boot.
+ *
+ * Note that rcu_read_lock() is disallowed if the CPU is either idle or
+ * offline from an RCU perspective, so check for those as well.
  */
 int rcu_read_lock_bh_held(void)
 {
@@ -95,6 +98,8 @@ int rcu_read_lock_bh_held(void)
 		return 1;
 	if (rcu_is_cpu_idle())
 		return 0;
+	if (!rcu_lockdep_current_cpu_online())
+		return 0;
 	return in_softirq() || irqs_disabled();
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 977296d..37a5444 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -53,7 +53,7 @@ static void __call_rcu(struct rcu_head *head,
 
 #include "rcutiny_plugin.h"
 
-static long long rcu_dynticks_nesting = DYNTICK_TASK_NESTING;
+static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 
 /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
 static void rcu_idle_enter_common(long long oldval)
@@ -88,10 +88,16 @@ void rcu_idle_enter(void)
 
 	local_irq_save(flags);
 	oldval = rcu_dynticks_nesting;
-	rcu_dynticks_nesting = 0;
+	WARN_ON_ONCE((rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK) == 0);
+	if ((rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK) ==
+	    DYNTICK_TASK_NEST_VALUE)
+		rcu_dynticks_nesting = 0;
+	else
+		rcu_dynticks_nesting  -= DYNTICK_TASK_NEST_VALUE;
 	rcu_idle_enter_common(oldval);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
 /*
  * Exit an interrupt handler towards idle.
@@ -140,11 +146,15 @@ void rcu_idle_exit(void)
 
 	local_irq_save(flags);
 	oldval = rcu_dynticks_nesting;
-	WARN_ON_ONCE(oldval != 0);
-	rcu_dynticks_nesting = DYNTICK_TASK_NESTING;
+	WARN_ON_ONCE(rcu_dynticks_nesting < 0);
+	if (rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK)
+		rcu_dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
+	else
+		rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	rcu_idle_exit_common(oldval);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_idle_exit);
 
 /*
  * Enter an interrupt handler, moving away from idle.
@@ -258,7 +268,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 
 	/* If no RCU callbacks ready to invoke, just return. */
 	if (&rcp->rcucblist == rcp->donetail) {
-		RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, -1));
+		RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, 0, -1));
 		RCU_TRACE(trace_rcu_batch_end(rcp->name, 0,
 					      ACCESS_ONCE(rcp->rcucblist),
 					      need_resched(),
@@ -269,7 +279,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 
 	/* Move the ready-to-invoke callbacks to a local list. */
 	local_irq_save(flags);
-	RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, -1));
+	RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, rcp->qlen, -1));
 	list = rcp->rcucblist;
 	rcp->rcucblist = *rcp->donetail;
 	*rcp->donetail = NULL;
@@ -319,6 +329,10 @@ static void rcu_process_callbacks(struct softirq_action *unused)
  */
 void synchronize_sched(void)
 {
+	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map) &&
+			   !lock_is_held(&rcu_lock_map) &&
+			   !lock_is_held(&rcu_sched_lock_map),
+			   "Illegal synchronize_sched() in RCU read-side critical section");
 	cond_resched();
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 9cb1ae4..22ecea0 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -132,6 +132,7 @@ static struct rcu_preempt_ctrlblk rcu_preempt_ctrlblk = {
 	RCU_TRACE(.rcb.name = "rcu_preempt")
 };
 
+static void rcu_read_unlock_special(struct task_struct *t);
 static int rcu_preempted_readers_exp(void);
 static void rcu_report_exp_done(void);
 
@@ -146,6 +147,16 @@ static int rcu_cpu_blocking_cur_gp(void)
 /*
  * Check for a running RCU reader.  Because there is only one CPU,
  * there can be but one running RCU reader at a time.  ;-)
+ *
+ * Returns zero if there are no running readers.  Returns a positive
+ * number if there is at least one reader within its RCU read-side
+ * critical section.  Returns a negative number if an outermost reader
+ * is in the midst of exiting from its RCU read-side critical section
+ *
+ * Returns zero if there are no running readers.  Returns a positive
+ * number if there is at least one reader within its RCU read-side
+ * critical section.  Returns a negative number if an outermost reader
+ * is in the midst of exiting from its RCU read-side critical section.
  */
 static int rcu_preempt_running_reader(void)
 {
@@ -307,7 +318,6 @@ static int rcu_boost(void)
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
 	t->rcu_boost_mutex = &mtx;
-	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
 	raw_local_irq_restore(flags);
 	rt_mutex_lock(&mtx);
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
@@ -475,7 +485,7 @@ void rcu_preempt_note_context_switch(void)
 	unsigned long flags;
 
 	local_irq_save(flags); /* must exclude scheduler_tick(). */
-	if (rcu_preempt_running_reader() &&
+	if (rcu_preempt_running_reader() > 0 &&
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
@@ -494,6 +504,13 @@ void rcu_preempt_note_context_switch(void)
 		list_add(&t->rcu_node_entry, &rcu_preempt_ctrlblk.blkd_tasks);
 		if (rcu_cpu_blocking_cur_gp())
 			rcu_preempt_ctrlblk.gp_tasks = &t->rcu_node_entry;
+	} else if (rcu_preempt_running_reader() < 0 &&
+		   t->rcu_read_unlock_special) {
+		/*
+		 * Complete exit from RCU read-side critical section on
+		 * behalf of preempted instance of __rcu_read_unlock().
+		 */
+		rcu_read_unlock_special(t);
 	}
 
 	/*
@@ -526,12 +543,15 @@ EXPORT_SYMBOL_GPL(__rcu_read_lock);
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static void rcu_read_unlock_special(struct task_struct *t)
+static noinline void rcu_read_unlock_special(struct task_struct *t)
 {
 	int empty;
 	int empty_exp;
 	unsigned long flags;
 	struct list_head *np;
+#ifdef CONFIG_RCU_BOOST
+	struct rt_mutex *rbmp = NULL;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 	int special;
 
 	/*
@@ -552,7 +572,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		rcu_preempt_cpu_qs();
 
 	/* Hardware IRQ handlers cannot block. */
-	if (in_irq()) {
+	if (in_irq() || in_serving_softirq()) {
 		local_irq_restore(flags);
 		return;
 	}
@@ -597,10 +617,10 @@ static void rcu_read_unlock_special(struct task_struct *t)
 	}
 #ifdef CONFIG_RCU_BOOST
 	/* Unboost self if was boosted. */
-	if (special & RCU_READ_UNLOCK_BOOSTED) {
-		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BOOSTED;
-		rt_mutex_unlock(t->rcu_boost_mutex);
+	if (t->rcu_boost_mutex != NULL) {
+		rbmp = t->rcu_boost_mutex;
 		t->rcu_boost_mutex = NULL;
+		rt_mutex_unlock(rbmp);
 	}
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	local_irq_restore(flags);
@@ -618,13 +638,22 @@ void __rcu_read_unlock(void)
 	struct task_struct *t = current;
 
 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutiny.c */
-	--t->rcu_read_lock_nesting;
-	barrier();  /* decrement before load of ->rcu_read_unlock_special */
-	if (t->rcu_read_lock_nesting == 0 &&
-	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
-		rcu_read_unlock_special(t);
+	if (t->rcu_read_lock_nesting != 1)
+		--t->rcu_read_lock_nesting;
+	else {
+		t->rcu_read_lock_nesting = INT_MIN;
+		barrier();  /* assign before ->rcu_read_unlock_special load */
+		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
+			rcu_read_unlock_special(t);
+		barrier();  /* ->rcu_read_unlock_special load before assign */
+		t->rcu_read_lock_nesting = 0;
+	}
 #ifdef CONFIG_PROVE_LOCKING
-	WARN_ON_ONCE(t->rcu_read_lock_nesting < 0);
+	{
+		int rrln = ACCESS_ONCE(t->rcu_read_lock_nesting);
+
+		WARN_ON_ONCE(rrln < 0 && rrln > INT_MIN / 2);
+	}
 #endif /* #ifdef CONFIG_PROVE_LOCKING */
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
@@ -649,7 +678,7 @@ static void rcu_preempt_check_callbacks(void)
 		invoke_rcu_callbacks();
 	if (rcu_preempt_gp_in_progress() &&
 	    rcu_cpu_blocking_cur_gp() &&
-	    rcu_preempt_running_reader())
+	    rcu_preempt_running_reader() > 0)
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
 }
 
@@ -706,6 +735,11 @@ EXPORT_SYMBOL_GPL(call_rcu);
  */
 void synchronize_rcu(void)
 {
+	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map) &&
+			   !lock_is_held(&rcu_lock_map) &&
+			   !lock_is_held(&rcu_sched_lock_map),
+			   "Illegal synchronize_rcu() in RCU read-side critical section");
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	if (!rcu_scheduler_active)
 		return;
@@ -882,7 +916,8 @@ static void rcu_preempt_process_callbacks(void)
 static void invoke_rcu_callbacks(void)
 {
 	have_rcu_kthread_work = 1;
-	wake_up(&rcu_kthread_wq);
+	if (rcu_kthread_task != NULL)
+		wake_up(&rcu_kthread_wq);
 }
 
 #ifdef CONFIG_RCU_TRACE
@@ -943,12 +978,16 @@ early_initcall(rcu_spawn_kthreads);
 
 #else /* #ifdef CONFIG_RCU_BOOST */
 
+/* Hold off callback invocation until early_initcall() time. */
+static int rcu_scheduler_fully_active __read_mostly;
+
 /*
  * Start up softirq processing of callbacks.
  */
 void invoke_rcu_callbacks(void)
 {
-	raise_softirq(RCU_SOFTIRQ);
+	if (rcu_scheduler_fully_active)
+		raise_softirq(RCU_SOFTIRQ);
 }
 
 #ifdef CONFIG_RCU_TRACE
@@ -963,10 +1002,14 @@ static bool rcu_is_callbacks_kthread(void)
 
 #endif /* #ifdef CONFIG_RCU_TRACE */
 
-void rcu_init(void)
+static int __init rcu_scheduler_really_started(void)
 {
+	rcu_scheduler_fully_active = 1;
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+	raise_softirq(RCU_SOFTIRQ);  /* Invoke any callbacks from early boot. */
+	return 0;
 }
+early_initcall(rcu_scheduler_really_started);
 
 #endif /* #else #ifdef CONFIG_RCU_BOOST */
 
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index a58ac28..a89b381 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -65,7 +65,10 @@ static int fqs_duration;	/* Duration of bursts (us), 0 to disable. */
 static int fqs_holdoff;		/* Hold time within burst (us). */
 static int fqs_stutter = 3;	/* Wait time between bursts (s). */
 static int onoff_interval;	/* Wait time between CPU hotplugs, 0=disable. */
+static int onoff_holdoff;	/* Seconds after boot before CPU hotplugs. */
 static int shutdown_secs;	/* Shutdown time (s).  <=0 for no shutdown. */
+static int stall_cpu;		/* CPU-stall duration (s).  0 for no stall. */
+static int stall_cpu_holdoff = 10; /* Time to wait until stall (s).  */
 static int test_boost = 1;	/* Test RCU prio boost: 0=no, 1=maybe, 2=yes. */
 static int test_boost_interval = 7; /* Interval between boost tests, seconds. */
 static int test_boost_duration = 4; /* Duration of each boost test, seconds. */
@@ -95,8 +98,14 @@ module_param(fqs_stutter, int, 0444);
 MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
 module_param(onoff_interval, int, 0444);
 MODULE_PARM_DESC(onoff_interval, "Time between CPU hotplugs (s), 0=disable");
+module_param(onoff_holdoff, int, 0444);
+MODULE_PARM_DESC(onoff_holdoff, "Time after boot before CPU hotplugs (s)");
 module_param(shutdown_secs, int, 0444);
 MODULE_PARM_DESC(shutdown_secs, "Shutdown time (s), zero to disable.");
+module_param(stall_cpu, int, 0444);
+MODULE_PARM_DESC(stall_cpu, "Stall duration (s), zero to disable.");
+module_param(stall_cpu_holdoff, int, 0444);
+MODULE_PARM_DESC(stall_cpu_holdoff, "Time to wait before starting stall (s).");
 module_param(test_boost, int, 0444);
 MODULE_PARM_DESC(test_boost, "Test RCU prio boost: 0=no, 1=maybe, 2=yes.");
 module_param(test_boost_interval, int, 0444);
@@ -129,6 +138,7 @@ static struct task_struct *shutdown_task;
 #ifdef CONFIG_HOTPLUG_CPU
 static struct task_struct *onoff_task;
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
+static struct task_struct *stall_task;
 
 #define RCU_TORTURE_PIPE_LEN 10
 
@@ -990,12 +1000,12 @@ static void rcu_torture_timer(unsigned long unused)
 				  rcu_read_lock_bh_held() ||
 				  rcu_read_lock_sched_held() ||
 				  srcu_read_lock_held(&srcu_ctl));
-	do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 	if (p == NULL) {
 		/* Leave because rcu_torture_writer is not yet underway */
 		cur_ops->readunlock(idx);
 		return;
 	}
+	do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 	if (p->rtort_mbtest == 0)
 		atomic_inc(&n_rcu_torture_mberror);
 	spin_lock(&rand_lock);
@@ -1053,13 +1063,13 @@ rcu_torture_reader(void *arg)
 					  rcu_read_lock_bh_held() ||
 					  rcu_read_lock_sched_held() ||
 					  srcu_read_lock_held(&srcu_ctl));
-		do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 		if (p == NULL) {
 			/* Wait for rcu_torture_writer to get underway */
 			cur_ops->readunlock(idx);
 			schedule_timeout_interruptible(HZ);
 			continue;
 		}
+		do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 		if (p->rtort_mbtest == 0)
 			atomic_inc(&n_rcu_torture_mberror);
 		cur_ops->read_delay(&rand);
@@ -1300,13 +1310,13 @@ rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, char *tag)
 		"fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d "
 		"test_boost=%d/%d test_boost_interval=%d "
 		"test_boost_duration=%d shutdown_secs=%d "
-		"onoff_interval=%d\n",
+		"onoff_interval=%d onoff_holdoff=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
 		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
 		stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter,
 		test_boost, cur_ops->can_boost,
 		test_boost_interval, test_boost_duration, shutdown_secs,
-		onoff_interval);
+		onoff_interval, onoff_holdoff);
 }
 
 static struct notifier_block rcutorture_shutdown_nb = {
@@ -1410,6 +1420,11 @@ rcu_torture_onoff(void *arg)
 	for_each_online_cpu(cpu)
 		maxcpu = cpu;
 	WARN_ON(maxcpu < 0);
+	if (onoff_holdoff > 0) {
+		VERBOSE_PRINTK_STRING("rcu_torture_onoff begin holdoff");
+		schedule_timeout_interruptible(onoff_holdoff * HZ);
+		VERBOSE_PRINTK_STRING("rcu_torture_onoff end holdoff");
+	}
 	while (!kthread_should_stop()) {
 		cpu = (rcu_random(&rand) >> 4) % (maxcpu + 1);
 		if (cpu_online(cpu) && cpu_is_hotpluggable(cpu)) {
@@ -1450,12 +1465,15 @@ rcu_torture_onoff(void *arg)
 static int __cpuinit
 rcu_torture_onoff_init(void)
 {
+	int ret;
+
 	if (onoff_interval <= 0)
 		return 0;
 	onoff_task = kthread_run(rcu_torture_onoff, NULL, "rcu_torture_onoff");
 	if (IS_ERR(onoff_task)) {
+		ret = PTR_ERR(onoff_task);
 		onoff_task = NULL;
-		return PTR_ERR(onoff_task);
+		return ret;
 	}
 	return 0;
 }
@@ -1481,6 +1499,63 @@ static void rcu_torture_onoff_cleanup(void)
 
 #endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
 
+/*
+ * CPU-stall kthread.  It waits as specified by stall_cpu_holdoff, then
+ * induces a CPU stall for the time specified by stall_cpu.
+ */
+static int __cpuinit rcu_torture_stall(void *args)
+{
+	unsigned long stop_at;
+
+	VERBOSE_PRINTK_STRING("rcu_torture_stall task started");
+	if (stall_cpu_holdoff > 0) {
+		VERBOSE_PRINTK_STRING("rcu_torture_stall begin holdoff");
+		schedule_timeout_interruptible(stall_cpu_holdoff * HZ);
+		VERBOSE_PRINTK_STRING("rcu_torture_stall end holdoff");
+	}
+	if (!kthread_should_stop()) {
+		stop_at = get_seconds() + stall_cpu;
+		/* RCU CPU stall is expected behavior in following code. */
+		printk(KERN_ALERT "rcu_torture_stall start.\n");
+		rcu_read_lock();
+		preempt_disable();
+		while (ULONG_CMP_LT(get_seconds(), stop_at))
+			continue;  /* Induce RCU CPU stall warning. */
+		preempt_enable();
+		rcu_read_unlock();
+		printk(KERN_ALERT "rcu_torture_stall end.\n");
+	}
+	rcutorture_shutdown_absorb("rcu_torture_stall");
+	while (!kthread_should_stop())
+		schedule_timeout_interruptible(10 * HZ);
+	return 0;
+}
+
+/* Spawn CPU-stall kthread, if stall_cpu specified. */
+static int __init rcu_torture_stall_init(void)
+{
+	int ret;
+
+	if (stall_cpu <= 0)
+		return 0;
+	stall_task = kthread_run(rcu_torture_stall, NULL, "rcu_torture_stall");
+	if (IS_ERR(stall_task)) {
+		ret = PTR_ERR(stall_task);
+		stall_task = NULL;
+		return ret;
+	}
+	return 0;
+}
+
+/* Clean up after the CPU-stall kthread, if one was spawned. */
+static void rcu_torture_stall_cleanup(void)
+{
+	if (stall_task == NULL)
+		return;
+	VERBOSE_PRINTK_STRING("Stopping rcu_torture_stall_task.");
+	kthread_stop(stall_task);
+}
+
 static int rcutorture_cpu_notify(struct notifier_block *self,
 				 unsigned long action, void *hcpu)
 {
@@ -1523,6 +1598,7 @@ rcu_torture_cleanup(void)
 	fullstop = FULLSTOP_RMMOD;
 	mutex_unlock(&fullstop_mutex);
 	unregister_reboot_notifier(&rcutorture_shutdown_nb);
+	rcu_torture_stall_cleanup();
 	if (stutter_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stutter task");
 		kthread_stop(stutter_task);
@@ -1602,6 +1678,10 @@ rcu_torture_cleanup(void)
 		cur_ops->cleanup();
 	if (atomic_read(&n_rcu_torture_error))
 		rcu_torture_print_module_parms(cur_ops, "End of test: FAILURE");
+	else if (n_online_successes != n_online_attempts ||
+		 n_offline_successes != n_offline_attempts)
+		rcu_torture_print_module_parms(cur_ops,
+					       "End of test: RCU_HOTPLUG");
 	else
 		rcu_torture_print_module_parms(cur_ops, "End of test: SUCCESS");
 }
@@ -1819,6 +1899,7 @@ rcu_torture_init(void)
 	}
 	rcu_torture_onoff_init();
 	register_reboot_notifier(&rcutorture_shutdown_nb);
+	rcu_torture_stall_init();
 	rcutorture_record_test_transition();
 	mutex_unlock(&fullstop_mutex);
 	return 0;
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6c4a672..1050d6d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -50,6 +50,8 @@
 #include <linux/wait.h>
 #include <linux/kthread.h>
 #include <linux/prefetch.h>
+#include <linux/delay.h>
+#include <linux/stop_machine.h>
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -196,7 +198,7 @@ void rcu_note_context_switch(int cpu)
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
-	.dynticks_nesting = DYNTICK_TASK_NESTING,
+	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
 	.dynticks = ATOMIC_INIT(1),
 };
 
@@ -208,8 +210,11 @@ module_param(blimit, int, 0);
 module_param(qhimark, int, 0);
 module_param(qlowmark, int, 0);
 
-int rcu_cpu_stall_suppress __read_mostly;
+int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
+int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
+
 module_param(rcu_cpu_stall_suppress, int, 0644);
+module_param(rcu_cpu_stall_timeout, int, 0644);
 
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
 static int rcu_pending(int cpu);
@@ -301,8 +306,6 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 	return &rsp->node[0];
 }
 
-#ifdef CONFIG_SMP
-
 /*
  * If the specified CPU is offline, tell the caller that it is in
  * a quiescent state.  Otherwise, whack it with a reschedule IPI.
@@ -317,30 +320,21 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 {
 	/*
-	 * If the CPU is offline, it is in a quiescent state.  We can
-	 * trust its state not to change because interrupts are disabled.
+	 * If the CPU is offline for more than a jiffy, it is in a quiescent
+	 * state.  We can trust its state not to change because interrupts
+	 * are disabled.  The reason for the jiffy's worth of slack is to
+	 * handle CPUs initializing on the way up and finding their way
+	 * to the idle loop on the way down.
 	 */
-	if (cpu_is_offline(rdp->cpu)) {
+	if (cpu_is_offline(rdp->cpu) &&
+	    ULONG_CMP_LT(rdp->rsp->gp_start + 2, jiffies)) {
 		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "ofl");
 		rdp->offline_fqs++;
 		return 1;
 	}
-
-	/*
-	 * The CPU is online, so send it a reschedule IPI.  This forces
-	 * it through the scheduler, and (inefficiently) also handles cases
-	 * where idle loops fail to inform RCU about the CPU being idle.
-	 */
-	if (rdp->cpu != smp_processor_id())
-		smp_send_reschedule(rdp->cpu);
-	else
-		set_need_resched();
-	rdp->resched_ipi++;
 	return 0;
 }
 
-#endif /* #ifdef CONFIG_SMP */
-
 /*
  * rcu_idle_enter_common - inform RCU that current CPU is moving towards idle
  *
@@ -366,6 +360,17 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 	atomic_inc(&rdtp->dynticks);
 	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+
+	/*
+	 * The idle task is not permitted to enter the idle loop while
+	 * in an RCU read-side critical section.
+	 */
+	rcu_lockdep_assert(!lock_is_held(&rcu_lock_map),
+			   "Illegal idle entry in RCU read-side critical section.");
+	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),
+			   "Illegal idle entry in RCU-bh read-side critical section.");
+	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
+			   "Illegal idle entry in RCU-sched read-side critical section.");
 }
 
 /**
@@ -389,10 +394,15 @@ void rcu_idle_enter(void)
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
-	rdtp->dynticks_nesting = 0;
+	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
+	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE)
+		rdtp->dynticks_nesting = 0;
+	else
+		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
 	rcu_idle_enter_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
 /**
  * rcu_irq_exit - inform RCU that current CPU is exiting irq towards idle
@@ -462,7 +472,7 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
  * Exit idle mode, in other words, -enter- the mode in which RCU
  * read-side critical sections can occur.
  *
- * We crowbar the ->dynticks_nesting field to DYNTICK_TASK_NESTING to
+ * We crowbar the ->dynticks_nesting field to DYNTICK_TASK_NEST to
  * allow for the possibility of usermode upcalls messing up our count
  * of interrupt nesting level during the busy period that is just
  * now starting.
@@ -476,11 +486,15 @@ void rcu_idle_exit(void)
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
-	WARN_ON_ONCE(oldval != 0);
-	rdtp->dynticks_nesting = DYNTICK_TASK_NESTING;
+	WARN_ON_ONCE(oldval < 0);
+	if (oldval & DYNTICK_TASK_NEST_MASK)
+		rdtp->dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
+	else
+		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	rcu_idle_exit_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_idle_exit);
 
 /**
  * rcu_irq_enter - inform RCU that current CPU is entering irq away from idle
@@ -581,6 +595,49 @@ int rcu_is_cpu_idle(void)
 }
 EXPORT_SYMBOL(rcu_is_cpu_idle);
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Is the current CPU online?  Disable preemption to avoid false positives
+ * that could otherwise happen due to the current CPU number being sampled,
+ * this task being preempted, its old CPU being taken offline, resuming
+ * on some other CPU, then determining that its old CPU is now offline.
+ * It is OK to use RCU on an offline processor during initial boot, hence
+ * the check for rcu_scheduler_fully_active.  Note also that it is OK
+ * for a CPU coming online to use RCU for one jiffy prior to marking itself
+ * online in the cpu_online_mask.  Similarly, it is OK for a CPU going
+ * offline to continue to use RCU for one jiffy after marking itself
+ * offline in the cpu_online_mask.  This leniency is necessary given the
+ * non-atomic nature of the online and offline processing, for example,
+ * the fact that a CPU enters the scheduler after completing the CPU_DYING
+ * notifiers.
+ *
+ * This is also why RCU internally marks CPUs online during the
+ * CPU_UP_PREPARE phase and offline during the CPU_DEAD phase.
+ *
+ * Disable checking if in an NMI handler because we cannot safely report
+ * errors from NMI handlers anyway.
+ */
+bool rcu_lockdep_current_cpu_online(void)
+{
+	struct rcu_data *rdp;
+	struct rcu_node *rnp;
+	bool ret;
+
+	if (in_nmi())
+		return 1;
+	preempt_disable();
+	rdp = &__get_cpu_var(rcu_sched_data);
+	rnp = rdp->mynode;
+	ret = (rdp->grpmask & rnp->qsmaskinit) ||
+	      !rcu_scheduler_fully_active;
+	preempt_enable();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
 #endif /* #ifdef CONFIG_PROVE_RCU */
 
 /**
@@ -595,8 +652,6 @@ int rcu_is_cpu_rrupt_from_idle(void)
 	return __get_cpu_var(rcu_dynticks).dynticks_nesting <= 1;
 }
 
-#ifdef CONFIG_SMP
-
 /*
  * Snapshot the specified CPU's dynticks counter so that we can later
  * credit them with an implicit quiescent state.  Return 1 if this CPU
@@ -640,12 +695,28 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	return rcu_implicit_offline_qs(rdp);
 }
 
-#endif /* #ifdef CONFIG_SMP */
+static int jiffies_till_stall_check(void)
+{
+	int till_stall_check = ACCESS_ONCE(rcu_cpu_stall_timeout);
+
+	/*
+	 * Limit check must be consistent with the Kconfig limits
+	 * for CONFIG_RCU_CPU_STALL_TIMEOUT.
+	 */
+	if (till_stall_check < 3) {
+		ACCESS_ONCE(rcu_cpu_stall_timeout) = 3;
+		till_stall_check = 3;
+	} else if (till_stall_check > 300) {
+		ACCESS_ONCE(rcu_cpu_stall_timeout) = 300;
+		till_stall_check = 300;
+	}
+	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
+}
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
 	rsp->gp_start = jiffies;
-	rsp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_CHECK;
+	rsp->jiffies_stall = jiffies + jiffies_till_stall_check();
 }
 
 static void print_other_cpu_stall(struct rcu_state *rsp)
@@ -664,13 +735,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
-	rsp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
-
-	/*
-	 * Now rat on any tasks that got kicked up to the root rcu_node
-	 * due to CPU offlining.
-	 */
-	ndetected = rcu_print_task_stall(rnp);
+	rsp->jiffies_stall = jiffies + 3 * jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/*
@@ -678,8 +743,9 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	 * See Documentation/RCU/stallwarn.txt for info on how to debug
 	 * RCU CPU stall warnings.
 	 */
-	printk(KERN_ERR "INFO: %s detected stalls on CPUs/tasks: {",
+	printk(KERN_ERR "INFO: %s detected stalls on CPUs/tasks:",
 	       rsp->name);
+	print_cpu_stall_info_begin();
 	rcu_for_each_leaf_node(rsp, rnp) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		ndetected += rcu_print_task_stall(rnp);
@@ -688,11 +754,22 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 			continue;
 		for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
 			if (rnp->qsmask & (1UL << cpu)) {
-				printk(" %d", rnp->grplo + cpu);
+				print_cpu_stall_info(rsp, rnp->grplo + cpu);
 				ndetected++;
 			}
 	}
-	printk("} (detected by %d, t=%ld jiffies)\n",
+
+	/*
+	 * Now rat on any tasks that got kicked up to the root rcu_node
+	 * due to CPU offlining.
+	 */
+	rnp = rcu_get_root(rsp);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	ndetected = rcu_print_task_stall(rnp);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+
+	print_cpu_stall_info_end();
+	printk(KERN_CONT "(detected by %d, t=%ld jiffies)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
 	if (ndetected == 0)
 		printk(KERN_ERR "INFO: Stall ended before state dump start\n");
@@ -716,15 +793,18 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	 * See Documentation/RCU/stallwarn.txt for info on how to debug
 	 * RCU CPU stall warnings.
 	 */
-	printk(KERN_ERR "INFO: %s detected stall on CPU %d (t=%lu jiffies)\n",
-	       rsp->name, smp_processor_id(), jiffies - rsp->gp_start);
+	printk(KERN_ERR "INFO: %s self-detected stall on CPU", rsp->name);
+	print_cpu_stall_info_begin();
+	print_cpu_stall_info(rsp, smp_processor_id());
+	print_cpu_stall_info_end();
+	printk(KERN_CONT " (t=%lu jiffies)\n", jiffies - rsp->gp_start);
 	if (!trigger_all_cpu_backtrace())
 		dump_stack();
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	if (ULONG_CMP_GE(jiffies, rsp->jiffies_stall))
-		rsp->jiffies_stall =
-			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
+		rsp->jiffies_stall = jiffies +
+				     3 * jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	set_need_resched();  /* kick ourselves to get things going. */
@@ -807,6 +887,7 @@ static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct
 			rdp->passed_quiesce = 0;
 		} else
 			rdp->qs_pending = 0;
+		zero_cpu_stall_ticks(rdp);
 	}
 }
 
@@ -943,6 +1024,10 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
  * in preparation for detecting the next grace period.  The caller must hold
  * the root node's ->lock, which is released before return.  Hard irqs must
  * be disabled.
+ *
+ * Note that it is legal for a dying CPU (which is marked as offline) to
+ * invoke this function.  This can happen when the dying CPU reports its
+ * quiescent state.
  */
 static void
 rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
@@ -980,26 +1065,8 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	rsp->fqs_state = RCU_GP_INIT; /* Hold off force_quiescent_state. */
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
-
-	/* Special-case the common single-level case. */
-	if (NUM_RCU_NODES == 1) {
-		rcu_preempt_check_blocked_tasks(rnp);
-		rnp->qsmask = rnp->qsmaskinit;
-		rnp->gpnum = rsp->gpnum;
-		rnp->completed = rsp->completed;
-		rsp->fqs_state = RCU_SIGNAL_INIT; /* force_quiescent_state OK */
-		rcu_start_gp_per_cpu(rsp, rnp, rdp);
-		rcu_preempt_boost_start_gp(rnp);
-		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
-					    rnp->level, rnp->grplo,
-					    rnp->grphi, rnp->qsmask);
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		return;
-	}
-
 	raw_spin_unlock(&rnp->lock);  /* leave irqs disabled. */
 
-
 	/* Exclude any concurrent CPU-hotplug operations. */
 	raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
 
@@ -1245,53 +1312,115 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 
 /*
  * Move a dying CPU's RCU callbacks to online CPU's callback list.
- * Synchronization is not required because this function executes
- * in stop_machine() context.
+ * Also record a quiescent state for this CPU for the current grace period.
+ * Synchronization and interrupt disabling are not required because
+ * this function executes in stop_machine() context.  Therefore, cleanup
+ * operations that might block must be done later from the CPU_DEAD
+ * notifier.
+ *
+ * Note that the outgoing CPU's bit has already been cleared in the
+ * cpu_online_mask.  This allows us to randomly pick a callback
+ * destination from the bits set in that mask.
  */
-static void rcu_send_cbs_to_online(struct rcu_state *rsp)
+static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 {
 	int i;
-	/* current DYING CPU is cleared in the cpu_online_mask */
+	unsigned long mask;
 	int receive_cpu = cpumask_any(cpu_online_mask);
 	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 	struct rcu_data *receive_rdp = per_cpu_ptr(rsp->rda, receive_cpu);
+	RCU_TRACE(struct rcu_node *rnp = rdp->mynode); /* For dying CPU. */
+
+	/* First, adjust the counts. */
+	if (rdp->nxtlist != NULL) {
+		receive_rdp->qlen_lazy += rdp->qlen_lazy;
+		receive_rdp->qlen += rdp->qlen;
+		rdp->qlen_lazy = 0;
+		rdp->qlen = 0;
+	}
 
-	if (rdp->nxtlist == NULL)
-		return;  /* irqs disabled, so comparison is stable. */
+	/*
+	 * Next, move ready-to-invoke callbacks to be invoked on some
+	 * other CPU.  These will not be required to pass through another
+	 * grace period:  They are done, regardless of CPU.
+	 */
+	if (rdp->nxtlist != NULL &&
+	    rdp->nxttail[RCU_DONE_TAIL] != &rdp->nxtlist) {
+		struct rcu_head *oldhead;
+		struct rcu_head **oldtail;
+		struct rcu_head **newtail;
+
+		oldhead = rdp->nxtlist;
+		oldtail = receive_rdp->nxttail[RCU_DONE_TAIL];
+		rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
+		*rdp->nxttail[RCU_DONE_TAIL] = *oldtail;
+		*receive_rdp->nxttail[RCU_DONE_TAIL] = oldhead;
+		newtail = rdp->nxttail[RCU_DONE_TAIL];
+		for (i = RCU_DONE_TAIL; i < RCU_NEXT_SIZE; i++) {
+			if (receive_rdp->nxttail[i] == oldtail)
+				receive_rdp->nxttail[i] = newtail;
+			if (rdp->nxttail[i] == newtail)
+				rdp->nxttail[i] = &rdp->nxtlist;
+		}
+	}
 
-	*receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
-	receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-	receive_rdp->qlen += rdp->qlen;
-	receive_rdp->n_cbs_adopted += rdp->qlen;
-	rdp->n_cbs_orphaned += rdp->qlen;
+	/*
+	 * Finally, put the rest of the callbacks at the end of the list.
+	 * The ones that made it partway through get to start over:  We
+	 * cannot assume that grace periods are synchronized across CPUs.
+	 * (We could splice RCU_WAIT_TAIL into RCU_NEXT_READY_TAIL, but
+	 * this does not seem compelling.  Not yet, anyway.)
+	 */
+	if (rdp->nxtlist != NULL) {
+		*receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
+		receive_rdp->nxttail[RCU_NEXT_TAIL] =
+				rdp->nxttail[RCU_NEXT_TAIL];
+		receive_rdp->n_cbs_adopted += rdp->qlen;
+		rdp->n_cbs_orphaned += rdp->qlen;
+
+		rdp->nxtlist = NULL;
+		for (i = 0; i < RCU_NEXT_SIZE; i++)
+			rdp->nxttail[i] = &rdp->nxtlist;
+	}
 
-	rdp->nxtlist = NULL;
-	for (i = 0; i < RCU_NEXT_SIZE; i++)
-		rdp->nxttail[i] = &rdp->nxtlist;
-	rdp->qlen = 0;
+	/*
+	 * Record a quiescent state for the dying CPU.  This is safe
+	 * only because we have already cleared out the callbacks.
+	 * (Otherwise, the RCU core might try to schedule the invocation
+	 * of callbacks on this now-offline CPU, which would be bad.)
+	 */
+	mask = rdp->grpmask;	/* rnp->grplo is constant. */
+	trace_rcu_grace_period(rsp->name,
+			       rnp->gpnum + 1 - !!(rnp->qsmask & mask),
+			       "cpuofl");
+	rcu_report_qs_rdp(smp_processor_id(), rsp, rdp, rsp->gpnum);
+	/* Note that rcu_report_qs_rdp() might call trace_rcu_grace_period(). */
 }
 
 /*
- * Remove the outgoing CPU from the bitmasks in the rcu_node hierarchy
- * and move all callbacks from the outgoing CPU to the current one.
+ * The CPU has been completely removed, and some other CPU is reporting
+ * this fact from process context.  Do the remainder of the cleanup.
  * There can only be one CPU hotplug operation at a time, so no other
  * CPU can be attempting to update rcu_cpu_kthread_task.
  */
-static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
+static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
 	unsigned long mask;
 	int need_report = 0;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
-	struct rcu_node *rnp;
+	struct rcu_node *rnp = rdp->mynode;  /* Outgoing CPU's rnp. */
 
+	/* Adjust any no-longer-needed kthreads. */
 	rcu_stop_cpu_kthread(cpu);
+	rcu_node_kthread_setaffinity(rnp, -1);
+
+	/* Remove the dying CPU from the bitmasks in the rcu_node hierarchy. */
 
 	/* Exclude any attempts to start a new grace period. */
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
 
 	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
-	rnp = rdp->mynode;	/* this is the outgoing CPU's rnp. */
 	mask = rdp->grpmask;	/* rnp->grplo is constant. */
 	do {
 		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
@@ -1299,20 +1428,11 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		if (rnp->qsmaskinit != 0) {
 			if (rnp != rdp->mynode)
 				raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
-			else
-				trace_rcu_grace_period(rsp->name,
-						       rnp->gpnum + 1 -
-						       !!(rnp->qsmask & mask),
-						       "cpuofl");
 			break;
 		}
-		if (rnp == rdp->mynode) {
-			trace_rcu_grace_period(rsp->name,
-					       rnp->gpnum + 1 -
-					       !!(rnp->qsmask & mask),
-					       "cpuofl");
+		if (rnp == rdp->mynode)
 			need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
-		} else
+		else
 			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		mask = rnp->grpmask;
 		rnp = rnp->parent;
@@ -1332,29 +1452,15 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	if (need_report & RCU_OFL_TASKS_EXP_GP)
 		rcu_report_exp_rnp(rsp, rnp, true);
-	rcu_node_kthread_setaffinity(rnp, -1);
-}
-
-/*
- * Remove the specified CPU from the RCU hierarchy and move any pending
- * callbacks that it might have to the current CPU.  This code assumes
- * that at least one CPU in the system will remain running at all times.
- * Any attempt to offline -all- CPUs is likely to strand RCU callbacks.
- */
-static void rcu_offline_cpu(int cpu)
-{
-	__rcu_offline_cpu(cpu, &rcu_sched_state);
-	__rcu_offline_cpu(cpu, &rcu_bh_state);
-	rcu_preempt_offline_cpu(cpu);
 }
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
 
-static void rcu_send_cbs_to_online(struct rcu_state *rsp)
+static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 {
 }
 
-static void rcu_offline_cpu(int cpu)
+static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 {
 }
 
@@ -1368,11 +1474,11 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list, **tail;
-	int bl, count;
+	int bl, count, count_lazy;
 
 	/* If no callbacks are ready, just return.*/
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
-		trace_rcu_batch_start(rsp->name, 0, 0);
+		trace_rcu_batch_start(rsp->name, rdp->qlen_lazy, rdp->qlen, 0);
 		trace_rcu_batch_end(rsp->name, 0, !!ACCESS_ONCE(rdp->nxtlist),
 				    need_resched(), is_idle_task(current),
 				    rcu_is_callbacks_kthread());
@@ -1384,8 +1490,9 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	 * races with call_rcu() from interrupt handlers.
 	 */
 	local_irq_save(flags);
+	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
 	bl = rdp->blimit;
-	trace_rcu_batch_start(rsp->name, rdp->qlen, bl);
+	trace_rcu_batch_start(rsp->name, rdp->qlen_lazy, rdp->qlen, bl);
 	list = rdp->nxtlist;
 	rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
 	*rdp->nxttail[RCU_DONE_TAIL] = NULL;
@@ -1396,12 +1503,13 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	local_irq_restore(flags);
 
 	/* Invoke callbacks. */
-	count = 0;
+	count = count_lazy = 0;
 	while (list) {
 		next = list->next;
 		prefetch(next);
 		debug_rcu_head_unqueue(list);
-		__rcu_reclaim(rsp->name, list);
+		if (__rcu_reclaim(rsp->name, list))
+			count_lazy++;
 		list = next;
 		/* Stop only if limit reached and CPU has something to do. */
 		if (++count >= bl &&
@@ -1416,6 +1524,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 			    rcu_is_callbacks_kthread());
 
 	/* Update count, and requeue any remaining callbacks. */
+	rdp->qlen_lazy -= count_lazy;
 	rdp->qlen -= count;
 	rdp->n_cbs_invoked += count;
 	if (list != NULL) {
@@ -1458,6 +1567,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 void rcu_check_callbacks(int cpu, int user)
 {
 	trace_rcu_utilization("Start scheduler-tick");
+	increment_cpu_stall_ticks();
 	if (user || rcu_is_cpu_rrupt_from_idle()) {
 
 		/*
@@ -1492,8 +1602,6 @@ void rcu_check_callbacks(int cpu, int user)
 	trace_rcu_utilization("End scheduler-tick");
 }
 
-#ifdef CONFIG_SMP
-
 /*
  * Scan the leaf rcu_node structures, processing dyntick state for any that
  * have not yet encountered a quiescent state, using the function specified.
@@ -1616,15 +1724,6 @@ unlock_fqs_ret:
 	trace_rcu_utilization("End fqs");
 }
 
-#else /* #ifdef CONFIG_SMP */
-
-static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
-{
-	set_need_resched();
-}
-
-#endif /* #else #ifdef CONFIG_SMP */
-
 /*
  * This does the RCU core processing work for the specified rcu_state
  * and rcu_data structures.  This may be called only from the CPU to
@@ -1702,11 +1801,12 @@ static void invoke_rcu_core(void)
 
 static void
 __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
-	   struct rcu_state *rsp)
+	   struct rcu_state *rsp, bool lazy)
 {
 	unsigned long flags;
 	struct rcu_data *rdp;
 
+	WARN_ON_ONCE((unsigned long)head & 0x3); /* Misaligned rcu_head! */
 	debug_rcu_head_queue(head);
 	head->func = func;
 	head->next = NULL;
@@ -1720,18 +1820,21 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	 * a quiescent state betweentimes.
 	 */
 	local_irq_save(flags);
+	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
 	rdp = this_cpu_ptr(rsp->rda);
 
 	/* Add the callback to our list. */
 	*rdp->nxttail[RCU_NEXT_TAIL] = head;
 	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
 	rdp->qlen++;
+	if (lazy)
+		rdp->qlen_lazy++;
 
 	if (__is_kfree_rcu_offset((unsigned long)func))
 		trace_rcu_kfree_callback(rsp->name, head, (unsigned long)func,
-					 rdp->qlen);
+					 rdp->qlen_lazy, rdp->qlen);
 	else
-		trace_rcu_callback(rsp->name, head, rdp->qlen);
+		trace_rcu_callback(rsp->name, head, rdp->qlen_lazy, rdp->qlen);
 
 	/* If interrupts were disabled, don't dive into RCU core. */
 	if (irqs_disabled_flags(flags)) {
@@ -1778,16 +1881,16 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
  */
 void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_sched_state);
+	__call_rcu(head, func, &rcu_sched_state, 0);
 }
 EXPORT_SYMBOL_GPL(call_rcu_sched);
 
 /*
- * Queue an RCU for invocation after a quicker grace period.
+ * Queue an RCU callback for invocation after a quicker grace period.
  */
 void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_bh_state);
+	__call_rcu(head, func, &rcu_bh_state, 0);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
@@ -1816,6 +1919,10 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
  */
 void synchronize_sched(void)
 {
+	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map) &&
+			   !lock_is_held(&rcu_lock_map) &&
+			   !lock_is_held(&rcu_sched_lock_map),
+			   "Illegal synchronize_sched() in RCU-sched read-side critical section");
 	if (rcu_blocking_is_gp())
 		return;
 	wait_rcu_gp(call_rcu_sched);
@@ -1833,12 +1940,137 @@ EXPORT_SYMBOL_GPL(synchronize_sched);
  */
 void synchronize_rcu_bh(void)
 {
+	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map) &&
+			   !lock_is_held(&rcu_lock_map) &&
+			   !lock_is_held(&rcu_sched_lock_map),
+			   "Illegal synchronize_rcu_bh() in RCU-bh read-side critical section");
 	if (rcu_blocking_is_gp())
 		return;
 	wait_rcu_gp(call_rcu_bh);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
+static atomic_t sync_sched_expedited_started = ATOMIC_INIT(0);
+static atomic_t sync_sched_expedited_done = ATOMIC_INIT(0);
+
+static int synchronize_sched_expedited_cpu_stop(void *data)
+{
+	/*
+	 * There must be a full memory barrier on each affected CPU
+	 * between the time that try_stop_cpus() is called and the
+	 * time that it returns.
+	 *
+	 * In the current initial implementation of cpu_stop, the
+	 * above condition is already met when the control reaches
+	 * this point and the following smp_mb() is not strictly
+	 * necessary.  Do smp_mb() anyway for documentation and
+	 * robustness against future implementation changes.
+	 */
+	smp_mb(); /* See above comment block. */
+	return 0;
+}
+
+/**
+ * synchronize_sched_expedited - Brute-force RCU-sched grace period
+ *
+ * Wait for an RCU-sched grace period to elapse, but use a "big hammer"
+ * approach to force the grace period to end quickly.  This consumes
+ * significant time on all CPUs and is unfriendly to real-time workloads,
+ * so is thus not recommended for any sort of common-case code.  In fact,
+ * if you are using synchronize_sched_expedited() in a loop, please
+ * restructure your code to batch your updates, and then use a single
+ * synchronize_sched() instead.
+ *
+ * Note that it is illegal to call this function while holding any lock
+ * that is acquired by a CPU-hotplug notifier.  And yes, it is also illegal
+ * to call this function from a CPU-hotplug notifier.  Failing to observe
+ * these restriction will result in deadlock.
+ *
+ * This implementation can be thought of as an application of ticket
+ * locking to RCU, with sync_sched_expedited_started and
+ * sync_sched_expedited_done taking on the roles of the halves
+ * of the ticket-lock word.  Each task atomically increments
+ * sync_sched_expedited_started upon entry, snapshotting the old value,
+ * then attempts to stop all the CPUs.  If this succeeds, then each
+ * CPU will have executed a context switch, resulting in an RCU-sched
+ * grace period.  We are then done, so we use atomic_cmpxchg() to
+ * update sync_sched_expedited_done to match our snapshot -- but
+ * only if someone else has not already advanced past our snapshot.
+ *
+ * On the other hand, if try_stop_cpus() fails, we check the value
+ * of sync_sched_expedited_done.  If it has advanced past our
+ * initial snapshot, then someone else must have forced a grace period
+ * some time after we took our snapshot.  In this case, our work is
+ * done for us, and we can simply return.  Otherwise, we try again,
+ * but keep our initial snapshot for purposes of checking for someone
+ * doing our work for us.
+ *
+ * If we fail too many times in a row, we fall back to synchronize_sched().
+ */
+void synchronize_sched_expedited(void)
+{
+	int firstsnap, s, snap, trycount = 0;
+
+	/* Note that atomic_inc_return() implies full memory barrier. */
+	firstsnap = snap = atomic_inc_return(&sync_sched_expedited_started);
+	get_online_cpus();
+	WARN_ON_ONCE(cpu_is_offline(raw_smp_processor_id()));
+
+	/*
+	 * Each pass through the following loop attempts to force a
+	 * context switch on each CPU.
+	 */
+	while (try_stop_cpus(cpu_online_mask,
+			     synchronize_sched_expedited_cpu_stop,
+			     NULL) == -EAGAIN) {
+		put_online_cpus();
+
+		/* No joy, try again later.  Or just synchronize_sched(). */
+		if (trycount++ < 10)
+			udelay(trycount * num_online_cpus());
+		else {
+			synchronize_sched();
+			return;
+		}
+
+		/* Check to see if someone else did our work for us. */
+		s = atomic_read(&sync_sched_expedited_done);
+		if (UINT_CMP_GE((unsigned)s, (unsigned)firstsnap)) {
+			smp_mb(); /* ensure test happens before caller kfree */
+			return;
+		}
+
+		/*
+		 * Refetching sync_sched_expedited_started allows later
+		 * callers to piggyback on our grace period.  We subtract
+		 * 1 to get the same token that the last incrementer got.
+		 * We retry after they started, so our grace period works
+		 * for them, and they started after our first try, so their
+		 * grace period works for us.
+		 */
+		get_online_cpus();
+		snap = atomic_read(&sync_sched_expedited_started);
+		smp_mb(); /* ensure read is before try_stop_cpus(). */
+	}
+
+	/*
+	 * Everyone up to our most recent fetch is covered by our grace
+	 * period.  Update the counter, but only if our work is still
+	 * relevant -- which it won't be if someone who started later
+	 * than we did beat us to the punch.
+	 */
+	do {
+		s = atomic_read(&sync_sched_expedited_done);
+		if (UINT_CMP_GE((unsigned)s, (unsigned)snap)) {
+			smp_mb(); /* ensure test happens before caller kfree */
+			break;
+		}
+	} while (atomic_cmpxchg(&sync_sched_expedited_done, s, snap) != s);
+
+	put_online_cpus();
+}
+EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
+
 /*
  * Check to see if there is any immediate RCU-related work to be done
  * by the current CPU, for the specified type of RCU, returning 1 if so.
@@ -1932,7 +2164,7 @@ static int rcu_cpu_has_callbacks(int cpu)
 	/* RCU callbacks either ready or pending? */
 	return per_cpu(rcu_sched_data, cpu).nxtlist ||
 	       per_cpu(rcu_bh_data, cpu).nxtlist ||
-	       rcu_preempt_needs_cpu(cpu);
+	       rcu_preempt_cpu_has_callbacks(cpu);
 }
 
 static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
@@ -2027,9 +2259,10 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->nxtlist = NULL;
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
 		rdp->nxttail[i] = &rdp->nxtlist;
+	rdp->qlen_lazy = 0;
 	rdp->qlen = 0;
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
-	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_NESTING);
+	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE);
 	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
 	rdp->cpu = cpu;
 	rdp->rsp = rsp;
@@ -2057,7 +2290,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
-	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_NESTING;
+	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	atomic_set(&rdp->dynticks->dynticks,
 		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
 	rcu_prepare_for_idle_init(cpu);
@@ -2139,16 +2372,18 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		 * touch any data without introducing corruption. We send the
 		 * dying CPU's callbacks to an arbitrarily chosen online CPU.
 		 */
-		rcu_send_cbs_to_online(&rcu_bh_state);
-		rcu_send_cbs_to_online(&rcu_sched_state);
-		rcu_preempt_send_cbs_to_online();
+		rcu_cleanup_dying_cpu(&rcu_bh_state);
+		rcu_cleanup_dying_cpu(&rcu_sched_state);
+		rcu_preempt_cleanup_dying_cpu();
 		rcu_cleanup_after_idle(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
-		rcu_offline_cpu(cpu);
+		rcu_cleanup_dead_cpu(cpu, &rcu_bh_state);
+		rcu_cleanup_dead_cpu(cpu, &rcu_sched_state);
+		rcu_preempt_cleanup_dead_cpu(cpu);
 		break;
 	default:
 		break;
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index fddff92..cdd1be0 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -239,6 +239,12 @@ struct rcu_data {
 	bool		preemptible;	/* Preemptible RCU? */
 	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
 	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
+#ifdef CONFIG_RCU_CPU_STALL_INFO
+	unsigned long	ticks_this_gp;	/* The number of scheduling-clock */
+					/*  ticks this CPU has handled */
+					/*  during and after the last grace */
+					/* period it is aware of. */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
 
 	/* 2) batch handling */
 	/*
@@ -265,7 +271,8 @@ struct rcu_data {
 	 */
 	struct rcu_head *nxtlist;
 	struct rcu_head **nxttail[RCU_NEXT_SIZE];
-	long		qlen;		/* # of queued callbacks */
+	long		qlen_lazy;	/* # of lazy queued callbacks */
+	long		qlen;		/* # of queued callbacks, incl lazy */
 	long		qlen_last_fqs_check;
 					/* qlen at last check for QS forcing */
 	unsigned long	n_cbs_invoked;	/* count of RCU cbs invoked. */
@@ -282,7 +289,6 @@ struct rcu_data {
 	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
 	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
 	unsigned long offline_fqs;	/* Kicked due to being offline. */
-	unsigned long resched_ipi;	/* Sent a resched IPI. */
 
 	/* 5) __rcu_pending() statistics. */
 	unsigned long n_rcu_pending;	/* rcu_pending() calls since boot. */
@@ -313,12 +319,6 @@ struct rcu_data {
 #else
 #define RCU_STALL_DELAY_DELTA	       0
 #endif
-
-#define RCU_SECONDS_TILL_STALL_CHECK   (CONFIG_RCU_CPU_STALL_TIMEOUT * HZ + \
-					RCU_STALL_DELAY_DELTA)
-						/* for rsp->jiffies_stall */
-#define RCU_SECONDS_TILL_STALL_RECHECK (3 * RCU_SECONDS_TILL_STALL_CHECK + 30)
-						/* for rsp->jiffies_stall */
 #define RCU_STALL_RAT_DELAY		2	/* Allow other CPUs time */
 						/*  to take at least one */
 						/*  scheduling clock irq */
@@ -438,8 +438,8 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 				     struct rcu_node *rnp,
 				     struct rcu_data *rdp);
-static void rcu_preempt_offline_cpu(int cpu);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
+static void rcu_preempt_cleanup_dead_cpu(int cpu);
 static void rcu_preempt_check_callbacks(int cpu);
 static void rcu_preempt_process_callbacks(void);
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
@@ -448,9 +448,9 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 			       bool wake);
 #endif /* #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU) */
 static int rcu_preempt_pending(int cpu);
-static int rcu_preempt_needs_cpu(int cpu);
+static int rcu_preempt_cpu_has_callbacks(int cpu);
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
-static void rcu_preempt_send_cbs_to_online(void);
+static void rcu_preempt_cleanup_dying_cpu(void);
 static void __init __rcu_init_preempt(void);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
@@ -471,5 +471,10 @@ static void __cpuinit rcu_prepare_kthreads(int cpu);
 static void rcu_prepare_for_idle_init(int cpu);
 static void rcu_cleanup_after_idle(int cpu);
 static void rcu_prepare_for_idle(int cpu);
+static void print_cpu_stall_info_begin(void);
+static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
+static void print_cpu_stall_info_end(void);
+static void zero_cpu_stall_ticks(struct rcu_data *rdp);
+static void increment_cpu_stall_ticks(void);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 8bb35d7..c023464 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -25,7 +25,6 @@
  */
 
 #include <linux/delay.h>
-#include <linux/stop_machine.h>
 
 #define RCU_KTHREAD_PRIO 1
 
@@ -63,7 +62,10 @@ static void __init rcu_bootup_announce_oddness(void)
 	printk(KERN_INFO "\tRCU torture testing starts during boot.\n");
 #endif
 #if defined(CONFIG_TREE_PREEMPT_RCU) && !defined(CONFIG_RCU_CPU_STALL_VERBOSE)
-	printk(KERN_INFO "\tVerbose stalled-CPUs detection is disabled.\n");
+	printk(KERN_INFO "\tDump stacks of tasks blocking RCU-preempt GP.\n");
+#endif
+#if defined(CONFIG_RCU_CPU_STALL_INFO)
+	printk(KERN_INFO "\tAdditional per-CPU info printed with stalls.\n");
 #endif
 #if NUM_RCU_LVL_4 != 0
 	printk(KERN_INFO "\tExperimental four-level hierarchy is enabled.\n");
@@ -490,6 +492,31 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
 
 #endif /* #else #ifdef CONFIG_RCU_CPU_STALL_VERBOSE */
 
+#ifdef CONFIG_RCU_CPU_STALL_INFO
+
+static void rcu_print_task_stall_begin(struct rcu_node *rnp)
+{
+	printk(KERN_ERR "\tTasks blocked on level-%d rcu_node (CPUs %d-%d):",
+	       rnp->level, rnp->grplo, rnp->grphi);
+}
+
+static void rcu_print_task_stall_end(void)
+{
+	printk(KERN_CONT "\n");
+}
+
+#else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
+
+static void rcu_print_task_stall_begin(struct rcu_node *rnp)
+{
+}
+
+static void rcu_print_task_stall_end(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_INFO */
+
 /*
  * Scan the current list of tasks blocked within RCU read-side critical
  * sections, printing out the tid of each.
@@ -501,12 +528,14 @@ static int rcu_print_task_stall(struct rcu_node *rnp)
 
 	if (!rcu_preempt_blocked_readers_cgp(rnp))
 		return 0;
+	rcu_print_task_stall_begin(rnp);
 	t = list_entry(rnp->gp_tasks,
 		       struct task_struct, rcu_node_entry);
 	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry) {
-		printk(" P%d", t->pid);
+		printk(KERN_CONT " P%d", t->pid);
 		ndetected++;
 	}
+	rcu_print_task_stall_end();
 	return ndetected;
 }
 
@@ -581,7 +610,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	 * absolutely necessary, but this is a good performance/complexity
 	 * tradeoff.
 	 */
-	if (rcu_preempt_blocked_readers_cgp(rnp))
+	if (rcu_preempt_blocked_readers_cgp(rnp) && rnp->qsmask == 0)
 		retval |= RCU_OFL_TASKS_NORM_GP;
 	if (rcu_preempted_readers_exp(rnp))
 		retval |= RCU_OFL_TASKS_EXP_GP;
@@ -618,16 +647,16 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	return retval;
 }
 
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
 /*
  * Do CPU-offline processing for preemptible RCU.
  */
-static void rcu_preempt_offline_cpu(int cpu)
+static void rcu_preempt_cleanup_dead_cpu(int cpu)
 {
-	__rcu_offline_cpu(cpu, &rcu_preempt_state);
+	rcu_cleanup_dead_cpu(cpu, &rcu_preempt_state);
 }
 
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-
 /*
  * Check for a quiescent state from the current CPU.  When a task blocks,
  * the task is recorded in the corresponding CPU's rcu_node structure,
@@ -671,10 +700,24 @@ static void rcu_preempt_do_callbacks(void)
  */
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_preempt_state);
+	__call_rcu(head, func, &rcu_preempt_state, 0);
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
+/*
+ * Queue an RCU callback for lazy invocation after a grace period.
+ * This will likely be later named something like "call_rcu_lazy()",
+ * but this change will require some way of tagging the lazy RCU
+ * callbacks in the list of pending callbacks.  Until then, this
+ * function may only be called from __kfree_rcu().
+ */
+void kfree_call_rcu(struct rcu_head *head,
+		    void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_preempt_state, 1);
+}
+EXPORT_SYMBOL_GPL(kfree_call_rcu);
+
 /**
  * synchronize_rcu - wait until a grace period has elapsed.
  *
@@ -688,6 +731,10 @@ EXPORT_SYMBOL_GPL(call_rcu);
  */
 void synchronize_rcu(void)
 {
+	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map) &&
+			   !lock_is_held(&rcu_lock_map) &&
+			   !lock_is_held(&rcu_sched_lock_map),
+			   "Illegal synchronize_rcu() in RCU read-side critical section");
 	if (!rcu_scheduler_active)
 		return;
 	wait_rcu_gp(call_rcu);
@@ -788,10 +835,22 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 		rcu_report_exp_rnp(rsp, rnp, false); /* Don't wake self. */
 }
 
-/*
- * Wait for an rcu-preempt grace period, but expedite it.  The basic idea
- * is to invoke synchronize_sched_expedited() to push all the tasks to
- * the ->blkd_tasks lists and wait for this list to drain.
+/**
+ * synchronize_rcu_expedited - Brute-force RCU grace period
+ *
+ * Wait for an RCU-preempt grace period, but expedite it.  The basic
+ * idea is to invoke synchronize_sched_expedited() to push all the tasks to
+ * the ->blkd_tasks lists and wait for this list to drain.  This consumes
+ * significant time on all CPUs and is unfriendly to real-time workloads,
+ * so is thus not recommended for any sort of common-case code.
+ * In fact, if you are using synchronize_rcu_expedited() in a loop,
+ * please restructure your code to batch your updates, and then Use a
+ * single synchronize_rcu() instead.
+ *
+ * Note that it is illegal to call this function while holding any lock
+ * that is acquired by a CPU-hotplug notifier.  And yes, it is also illegal
+ * to call this function from a CPU-hotplug notifier.  Failing to observe
+ * these restriction will result in deadlock.
  */
 void synchronize_rcu_expedited(void)
 {
@@ -869,9 +928,9 @@ static int rcu_preempt_pending(int cpu)
 }
 
 /*
- * Does preemptible RCU need the CPU to stay out of dynticks mode?
+ * Does preemptible RCU have callbacks on this CPU?
  */
-static int rcu_preempt_needs_cpu(int cpu)
+static int rcu_preempt_cpu_has_callbacks(int cpu)
 {
 	return !!per_cpu(rcu_preempt_data, cpu).nxtlist;
 }
@@ -894,11 +953,12 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 }
 
 /*
- * Move preemptible RCU's callbacks from dying CPU to other online CPU.
+ * Move preemptible RCU's callbacks from dying CPU to other online CPU
+ * and record a quiescent state.
  */
-static void rcu_preempt_send_cbs_to_online(void)
+static void rcu_preempt_cleanup_dying_cpu(void)
 {
-	rcu_send_cbs_to_online(&rcu_preempt_state);
+	rcu_cleanup_dying_cpu(&rcu_preempt_state);
 }
 
 /*
@@ -1034,16 +1094,16 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	return 0;
 }
 
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
 /*
  * Because preemptible RCU does not exist, it never needs CPU-offline
  * processing.
  */
-static void rcu_preempt_offline_cpu(int cpu)
+static void rcu_preempt_cleanup_dead_cpu(int cpu)
 {
 }
 
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-
 /*
  * Because preemptible RCU does not exist, it never has any callbacks
  * to check.
@@ -1061,6 +1121,22 @@ static void rcu_preempt_process_callbacks(void)
 }
 
 /*
+ * Queue an RCU callback for lazy invocation after a grace period.
+ * This will likely be later named something like "call_rcu_lazy()",
+ * but this change will require some way of tagging the lazy RCU
+ * callbacks in the list of pending callbacks.  Until then, this
+ * function may only be called from __kfree_rcu().
+ *
+ * Because there is no preemptible RCU, we use RCU-sched instead.
+ */
+void kfree_call_rcu(struct rcu_head *head,
+		    void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_sched_state, 1);
+}
+EXPORT_SYMBOL_GPL(kfree_call_rcu);
+
+/*
  * Wait for an rcu-preempt grace period, but make it happen quickly.
  * But because preemptible RCU does not exist, map to rcu-sched.
  */
@@ -1093,9 +1169,9 @@ static int rcu_preempt_pending(int cpu)
 }
 
 /*
- * Because preemptible RCU does not exist, it never needs any CPU.
+ * Because preemptible RCU does not exist, it never has callbacks
  */
-static int rcu_preempt_needs_cpu(int cpu)
+static int rcu_preempt_cpu_has_callbacks(int cpu)
 {
 	return 0;
 }
@@ -1119,9 +1195,9 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 }
 
 /*
- * Because there is no preemptible RCU, there are no callbacks to move.
+ * Because there is no preemptible RCU, there is no cleanup to do.
  */
-static void rcu_preempt_send_cbs_to_online(void)
+static void rcu_preempt_cleanup_dying_cpu(void)
 {
 }
 
@@ -1823,132 +1899,6 @@ static void __cpuinit rcu_prepare_kthreads(int cpu)
 
 #endif /* #else #ifdef CONFIG_RCU_BOOST */
 
-#ifndef CONFIG_SMP
-
-void synchronize_sched_expedited(void)
-{
-	cond_resched();
-}
-EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
-
-#else /* #ifndef CONFIG_SMP */
-
-static atomic_t sync_sched_expedited_started = ATOMIC_INIT(0);
-static atomic_t sync_sched_expedited_done = ATOMIC_INIT(0);
-
-static int synchronize_sched_expedited_cpu_stop(void *data)
-{
-	/*
-	 * There must be a full memory barrier on each affected CPU
-	 * between the time that try_stop_cpus() is called and the
-	 * time that it returns.
-	 *
-	 * In the current initial implementation of cpu_stop, the
-	 * above condition is already met when the control reaches
-	 * this point and the following smp_mb() is not strictly
-	 * necessary.  Do smp_mb() anyway for documentation and
-	 * robustness against future implementation changes.
-	 */
-	smp_mb(); /* See above comment block. */
-	return 0;
-}
-
-/*
- * Wait for an rcu-sched grace period to elapse, but use "big hammer"
- * approach to force grace period to end quickly.  This consumes
- * significant time on all CPUs, and is thus not recommended for
- * any sort of common-case code.
- *
- * Note that it is illegal to call this function while holding any
- * lock that is acquired by a CPU-hotplug notifier.  Failing to
- * observe this restriction will result in deadlock.
- *
- * This implementation can be thought of as an application of ticket
- * locking to RCU, with sync_sched_expedited_started and
- * sync_sched_expedited_done taking on the roles of the halves
- * of the ticket-lock word.  Each task atomically increments
- * sync_sched_expedited_started upon entry, snapshotting the old value,
- * then attempts to stop all the CPUs.  If this succeeds, then each
- * CPU will have executed a context switch, resulting in an RCU-sched
- * grace period.  We are then done, so we use atomic_cmpxchg() to
- * update sync_sched_expedited_done to match our snapshot -- but
- * only if someone else has not already advanced past our snapshot.
- *
- * On the other hand, if try_stop_cpus() fails, we check the value
- * of sync_sched_expedited_done.  If it has advanced past our
- * initial snapshot, then someone else must have forced a grace period
- * some time after we took our snapshot.  In this case, our work is
- * done for us, and we can simply return.  Otherwise, we try again,
- * but keep our initial snapshot for purposes of checking for someone
- * doing our work for us.
- *
- * If we fail too many times in a row, we fall back to synchronize_sched().
- */
-void synchronize_sched_expedited(void)
-{
-	int firstsnap, s, snap, trycount = 0;
-
-	/* Note that atomic_inc_return() implies full memory barrier. */
-	firstsnap = snap = atomic_inc_return(&sync_sched_expedited_started);
-	get_online_cpus();
-
-	/*
-	 * Each pass through the following loop attempts to force a
-	 * context switch on each CPU.
-	 */
-	while (try_stop_cpus(cpu_online_mask,
-			     synchronize_sched_expedited_cpu_stop,
-			     NULL) == -EAGAIN) {
-		put_online_cpus();
-
-		/* No joy, try again later.  Or just synchronize_sched(). */
-		if (trycount++ < 10)
-			udelay(trycount * num_online_cpus());
-		else {
-			synchronize_sched();
-			return;
-		}
-
-		/* Check to see if someone else did our work for us. */
-		s = atomic_read(&sync_sched_expedited_done);
-		if (UINT_CMP_GE((unsigned)s, (unsigned)firstsnap)) {
-			smp_mb(); /* ensure test happens before caller kfree */
-			return;
-		}
-
-		/*
-		 * Refetching sync_sched_expedited_started allows later
-		 * callers to piggyback on our grace period.  We subtract
-		 * 1 to get the same token that the last incrementer got.
-		 * We retry after they started, so our grace period works
-		 * for them, and they started after our first try, so their
-		 * grace period works for us.
-		 */
-		get_online_cpus();
-		snap = atomic_read(&sync_sched_expedited_started);
-		smp_mb(); /* ensure read is before try_stop_cpus(). */
-	}
-
-	/*
-	 * Everyone up to our most recent fetch is covered by our grace
-	 * period.  Update the counter, but only if our work is still
-	 * relevant -- which it won't be if someone who started later
-	 * than we did beat us to the punch.
-	 */
-	do {
-		s = atomic_read(&sync_sched_expedited_done);
-		if (UINT_CMP_GE((unsigned)s, (unsigned)snap)) {
-			smp_mb(); /* ensure test happens before caller kfree */
-			break;
-		}
-	} while (atomic_cmpxchg(&sync_sched_expedited_done, s, snap) != s);
-
-	put_online_cpus();
-}
-EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
-
-#endif /* #else #ifndef CONFIG_SMP */
-
 #if !defined(CONFIG_RCU_FAST_NO_HZ)
 
 /*
@@ -1981,7 +1931,7 @@ static void rcu_cleanup_after_idle(int cpu)
 }
 
 /*
- * Do the idle-entry grace-period work, which, because CONFIG_RCU_FAST_NO_HZ=y,
+ * Do the idle-entry grace-period work, which, because CONFIG_RCU_FAST_NO_HZ=n,
  * is nothing.
  */
 static void rcu_prepare_for_idle(int cpu)
@@ -2015,6 +1965,9 @@ static void rcu_prepare_for_idle(int cpu)
  *	number, be warned: Setting RCU_IDLE_GP_DELAY too high can hang your
  *	system.  And if you are -that- concerned about energy efficiency,
  *	just power the system down and be done with it!
+ * RCU_IDLE_LAZY_GP_DELAY gives the number of jiffies that a CPU is
+ *	permitted to sleep in dyntick-idle mode with only lazy RCU
+ *	callbacks pending.  Setting this too high can OOM your system.
  *
  * The values below work well in practice.  If future workloads require
  * adjustment, they can be converted into kernel config parameters, though
@@ -2023,11 +1976,13 @@ static void rcu_prepare_for_idle(int cpu)
 #define RCU_IDLE_FLUSHES 5		/* Number of dyntick-idle tries. */
 #define RCU_IDLE_OPT_FLUSHES 3		/* Optional dyntick-idle tries. */
 #define RCU_IDLE_GP_DELAY 6		/* Roughly one grace period. */
+#define RCU_IDLE_LAZY_GP_DELAY (6 * HZ)	/* Roughly six seconds. */
 
 static DEFINE_PER_CPU(int, rcu_dyntick_drain);
 static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
 static DEFINE_PER_CPU(struct hrtimer, rcu_idle_gp_timer);
-static ktime_t rcu_idle_gp_wait;
+static ktime_t rcu_idle_gp_wait;	/* If some non-lazy callbacks. */
+static ktime_t rcu_idle_lazy_gp_wait;	/* If only lazy callbacks. */
 
 /*
  * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
@@ -2048,6 +2003,48 @@ int rcu_needs_cpu(int cpu)
 }
 
 /*
+ * Does the specified flavor of RCU have non-lazy callbacks pending on
+ * the specified CPU?  Both RCU flavor and CPU are specified by the
+ * rcu_data structure.
+ */
+static bool __rcu_cpu_has_nonlazy_callbacks(struct rcu_data *rdp)
+{
+	return rdp->qlen != rdp->qlen_lazy;
+}
+
+#ifdef CONFIG_TREE_PREEMPT_RCU
+
+/*
+ * Are there non-lazy RCU-preempt callbacks?  (There cannot be if there
+ * is no RCU-preempt in the kernel.)
+ */
+static bool rcu_preempt_cpu_has_nonlazy_callbacks(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
+
+	return __rcu_cpu_has_nonlazy_callbacks(rdp);
+}
+
+#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+
+static bool rcu_preempt_cpu_has_nonlazy_callbacks(int cpu)
+{
+	return 0;
+}
+
+#endif /* else #ifdef CONFIG_TREE_PREEMPT_RCU */
+
+/*
+ * Does any flavor of RCU have non-lazy callbacks on the specified CPU?
+ */
+static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
+{
+	return __rcu_cpu_has_nonlazy_callbacks(&per_cpu(rcu_sched_data, cpu)) ||
+	       __rcu_cpu_has_nonlazy_callbacks(&per_cpu(rcu_bh_data, cpu)) ||
+	       rcu_preempt_cpu_has_nonlazy_callbacks(cpu);
+}
+
+/*
  * Timer handler used to force CPU to start pushing its remaining RCU
  * callbacks in the case where it entered dyntick-idle mode with callbacks
  * pending.  The hander doesn't really need to do anything because the
@@ -2074,6 +2071,8 @@ static void rcu_prepare_for_idle_init(int cpu)
 		unsigned int upj = jiffies_to_usecs(RCU_IDLE_GP_DELAY);
 
 		rcu_idle_gp_wait = ns_to_ktime(upj * (u64)1000);
+		upj = jiffies_to_usecs(RCU_IDLE_LAZY_GP_DELAY);
+		rcu_idle_lazy_gp_wait = ns_to_ktime(upj * (u64)1000);
 		firsttime = 0;
 	}
 }
@@ -2109,10 +2108,6 @@ static void rcu_cleanup_after_idle(int cpu)
  */
 static void rcu_prepare_for_idle(int cpu)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-
 	/*
 	 * If there are no callbacks on this CPU, enter dyntick-idle mode.
 	 * Also reset state to avoid prejudicing later attempts.
@@ -2120,7 +2115,6 @@ static void rcu_prepare_for_idle(int cpu)
 	if (!rcu_cpu_has_callbacks(cpu)) {
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
-		local_irq_restore(flags);
 		trace_rcu_prep_idle("No callbacks");
 		return;
 	}
@@ -2130,7 +2124,6 @@ static void rcu_prepare_for_idle(int cpu)
 	 * refrained from disabling the scheduling-clock tick.
 	 */
 	if (per_cpu(rcu_dyntick_holdoff, cpu) == jiffies) {
-		local_irq_restore(flags);
 		trace_rcu_prep_idle("In holdoff");
 		return;
 	}
@@ -2140,18 +2133,22 @@ static void rcu_prepare_for_idle(int cpu)
 		/* First time through, initialize the counter. */
 		per_cpu(rcu_dyntick_drain, cpu) = RCU_IDLE_FLUSHES;
 	} else if (per_cpu(rcu_dyntick_drain, cpu) <= RCU_IDLE_OPT_FLUSHES &&
-		   !rcu_pending(cpu)) {
+		   !rcu_pending(cpu) &&
+		   !local_softirq_pending()) {
 		/* Can we go dyntick-idle despite still having callbacks? */
 		trace_rcu_prep_idle("Dyntick with callbacks");
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
-		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
-		hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
-			      rcu_idle_gp_wait, HRTIMER_MODE_REL);
+		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
+		if (rcu_cpu_has_nonlazy_callbacks(cpu))
+			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
+				      rcu_idle_gp_wait, HRTIMER_MODE_REL);
+		else
+			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
+				      rcu_idle_lazy_gp_wait, HRTIMER_MODE_REL);
 		return; /* Nothing more to do immediately. */
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
-		local_irq_restore(flags);
 		trace_rcu_prep_idle("Begin holdoff");
 		invoke_rcu_core();  /* Force the CPU out of dyntick-idle. */
 		return;
@@ -2163,23 +2160,17 @@ static void rcu_prepare_for_idle(int cpu)
 	 */
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	if (per_cpu(rcu_preempt_data, cpu).nxtlist) {
-		local_irq_restore(flags);
 		rcu_preempt_qs(cpu);
 		force_quiescent_state(&rcu_preempt_state, 0);
-		local_irq_save(flags);
 	}
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 	if (per_cpu(rcu_sched_data, cpu).nxtlist) {
-		local_irq_restore(flags);
 		rcu_sched_qs(cpu);
 		force_quiescent_state(&rcu_sched_state, 0);
-		local_irq_save(flags);
 	}
 	if (per_cpu(rcu_bh_data, cpu).nxtlist) {
-		local_irq_restore(flags);
 		rcu_bh_qs(cpu);
 		force_quiescent_state(&rcu_bh_state, 0);
-		local_irq_save(flags);
 	}
 
 	/*
@@ -2187,13 +2178,124 @@ static void rcu_prepare_for_idle(int cpu)
 	 * So try forcing the callbacks through the grace period.
 	 */
 	if (rcu_cpu_has_callbacks(cpu)) {
-		local_irq_restore(flags);
 		trace_rcu_prep_idle("More callbacks");
 		invoke_rcu_core();
-	} else {
-		local_irq_restore(flags);
+	} else
 		trace_rcu_prep_idle("Callbacks drained");
-	}
 }
 
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
+
+#ifdef CONFIG_RCU_CPU_STALL_INFO
+
+#ifdef CONFIG_RCU_FAST_NO_HZ
+
+static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
+{
+	struct hrtimer *hrtp = &per_cpu(rcu_idle_gp_timer, cpu);
+
+	sprintf(cp, "drain=%d %c timer=%lld",
+		per_cpu(rcu_dyntick_drain, cpu),
+		per_cpu(rcu_dyntick_holdoff, cpu) == jiffies ? 'H' : '.',
+		hrtimer_active(hrtp)
+			? ktime_to_us(hrtimer_get_remaining(hrtp))
+			: -1);
+}
+
+#else /* #ifdef CONFIG_RCU_FAST_NO_HZ */
+
+static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_FAST_NO_HZ */
+
+/* Initiate the stall-info list. */
+static void print_cpu_stall_info_begin(void)
+{
+	printk(KERN_CONT "\n");
+}
+
+/*
+ * Print out diagnostic information for the specified stalled CPU.
+ *
+ * If the specified CPU is aware of the current RCU grace period
+ * (flavor specified by rsp), then print the number of scheduling
+ * clock interrupts the CPU has taken during the time that it has
+ * been aware.  Otherwise, print the number of RCU grace periods
+ * that this CPU is ignorant of, for example, "1" if the CPU was
+ * aware of the previous grace period.
+ *
+ * Also print out idle and (if CONFIG_RCU_FAST_NO_HZ) idle-entry info.
+ */
+static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
+{
+	char fast_no_hz[72];
+	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
+	struct rcu_dynticks *rdtp = rdp->dynticks;
+	char *ticks_title;
+	unsigned long ticks_value;
+
+	if (rsp->gpnum == rdp->gpnum) {
+		ticks_title = "ticks this GP";
+		ticks_value = rdp->ticks_this_gp;
+	} else {
+		ticks_title = "GPs behind";
+		ticks_value = rsp->gpnum - rdp->gpnum;
+	}
+	print_cpu_stall_fast_no_hz(fast_no_hz, cpu);
+	printk(KERN_ERR "\t%d: (%lu %s) idle=%03x/%llx/%d %s\n",
+	       cpu, ticks_value, ticks_title,
+	       atomic_read(&rdtp->dynticks) & 0xfff,
+	       rdtp->dynticks_nesting, rdtp->dynticks_nmi_nesting,
+	       fast_no_hz);
+}
+
+/* Terminate the stall-info list. */
+static void print_cpu_stall_info_end(void)
+{
+	printk(KERN_ERR "\t");
+}
+
+/* Zero ->ticks_this_gp for all flavors of RCU. */
+static void zero_cpu_stall_ticks(struct rcu_data *rdp)
+{
+	rdp->ticks_this_gp = 0;
+}
+
+/* Increment ->ticks_this_gp for all flavors of RCU. */
+static void increment_cpu_stall_ticks(void)
+{
+	__get_cpu_var(rcu_sched_data).ticks_this_gp++;
+	__get_cpu_var(rcu_bh_data).ticks_this_gp++;
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	__get_cpu_var(rcu_preempt_data).ticks_this_gp++;
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+}
+
+#else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
+
+static void print_cpu_stall_info_begin(void)
+{
+	printk(KERN_CONT " {");
+}
+
+static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
+{
+	printk(KERN_CONT " %d", cpu);
+}
+
+static void print_cpu_stall_info_end(void)
+{
+	printk(KERN_CONT "} ");
+}
+
+static void zero_cpu_stall_ticks(struct rcu_data *rdp)
+{
+}
+
+static void increment_cpu_stall_ticks(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_INFO */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 654cfe6..ed459ed 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -72,9 +72,9 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks->dynticks_nesting,
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
-	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, " ql=%ld qs=%c%c%c%c",
-		   rdp->qlen,
+	seq_printf(m, " of=%lu", rdp->offline_fqs);
+	seq_printf(m, " ql=%ld/%ld qs=%c%c%c%c",
+		   rdp->qlen_lazy, rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
 		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
@@ -144,8 +144,8 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks->dynticks_nesting,
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
-	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, ",%ld,\"%c%c%c%c\"", rdp->qlen,
+	seq_printf(m, ",%lu", rdp->offline_fqs);
+	seq_printf(m, ",%ld,%ld,\"%c%c%c%c\"", rdp->qlen_lazy, rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
 		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
@@ -168,7 +168,7 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
 	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pgp\",\"pq\",");
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
-	seq_puts(m, "\"of\",\"ri\",\"ql\",\"qs\"");
+	seq_puts(m, "\"of\",\"qll\",\"ql\",\"qs\"");
 #ifdef CONFIG_RCU_BOOST
 	seq_puts(m, "\"kt\",\"ktl\"");
 #endif /* #ifdef CONFIG_RCU_BOOST */
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 0febf61..ba35f3a 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -172,6 +172,12 @@ static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
 {
 	int idx;
 
+	rcu_lockdep_assert(!lock_is_held(&sp->dep_map) &&
+			   !lock_is_held(&rcu_bh_lock_map) &&
+			   !lock_is_held(&rcu_lock_map) &&
+			   !lock_is_held(&rcu_sched_lock_map),
+			   "Illegal synchronize_srcu() in same-type SRCU (or RCU) read-side critical section");
+
 	idx = sp->completed;
 	mutex_lock(&sp->mutex);
 
@@ -280,19 +286,26 @@ void synchronize_srcu(struct srcu_struct *sp)
 EXPORT_SYMBOL_GPL(synchronize_srcu);
 
 /**
- * synchronize_srcu_expedited - like synchronize_srcu, but less patient
+ * synchronize_srcu_expedited - Brute-force SRCU grace period
  * @sp: srcu_struct with which to synchronize.
  *
- * Flip the completed counter, and wait for the old count to drain to zero.
- * As with classic RCU, the updater must use some separate means of
- * synchronizing concurrent updates.  Can block; must be called from
- * process context.
+ * Wait for an SRCU grace period to elapse, but use a "big hammer"
+ * approach to force the grace period to end quickly.  This consumes
+ * significant time on all CPUs and is unfriendly to real-time workloads,
+ * so is thus not recommended for any sort of common-case code.  In fact,
+ * if you are using synchronize_srcu_expedited() in a loop, please
+ * restructure your code to batch your updates, and then use a single
+ * synchronize_srcu() instead.
  *
- * Note that it is illegal to call synchronize_srcu_expedited()
- * from the corresponding SRCU read-side critical section; doing so
- * will result in deadlock.  However, it is perfectly legal to call
- * synchronize_srcu_expedited() on one srcu_struct from some other
- * srcu_struct's read-side critical section.
+ * Note that it is illegal to call this function while holding any lock
+ * that is acquired by a CPU-hotplug notifier.  And yes, it is also illegal
+ * to call this function from a CPU-hotplug notifier.  Failing to observe
+ * these restriction will result in deadlock.  It is also illegal to call
+ * synchronize_srcu_expedited() from the corresponding SRCU read-side
+ * critical section; doing so will result in deadlock.  However, it is
+ * perfectly legal to call synchronize_srcu_expedited() on one srcu_struct
+ * from some other srcu_struct's read-side critical section, as long as
+ * the resulting graph of srcu_structs is acyclic.
  */
 void synchronize_srcu_expedited(struct srcu_struct *sp)
 {
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8745ac7..d27a2aa 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -927,6 +927,30 @@ config RCU_CPU_STALL_VERBOSE
 
 	  Say Y if you want to enable such checks.
 
+config RCU_CPU_STALL_INFO
+	bool "Print additional diagnostics on RCU CPU stall"
+	depends on (TREE_RCU || TREE_PREEMPT_RCU) && DEBUG_KERNEL
+	default n
+	help
+	  For each stalled CPU that is aware of the current RCU grace
+	  period, print out additional per-CPU diagnostic information
+	  regarding scheduling-clock ticks, idle state, and,
+	  for RCU_FAST_NO_HZ kernels, idle-entry state.
+
+	  Say N if you are unsure.
+
+	  Say Y if you want to enable such diagnostics.
+
+config RCU_TRACE
+	bool "Enable tracing for RCU"
+	depends on DEBUG_KERNEL
+	help
+	  This option provides tracing in RCU which presents stats
+	  in debugfs for debugging RCU implementation.
+
+	  Say Y here if you want to enable RCU tracing
+	  Say N if you are unsure.
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 86f3b88..c48adc5 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1857,11 +1857,6 @@ static int cipso_v4_genopt(unsigned char *buf, u32 buf_len,
 	return CIPSO_V4_HDR_LEN + ret_val;
 }
 
-static void opt_kfree_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct ip_options_rcu, rcu));
-}
-
 /**
  * cipso_v4_sock_setattr - Add a CIPSO option to a socket
  * @sk: the socket
@@ -1938,7 +1933,7 @@ int cipso_v4_sock_setattr(struct sock *sk,
 	}
 	rcu_assign_pointer(sk_inet->inet_opt, opt);
 	if (old)
-		call_rcu(&old->rcu, opt_kfree_rcu);
+		kfree_rcu(old, rcu);
 
 	return 0;
 
@@ -2005,7 +2000,7 @@ int cipso_v4_req_setattr(struct request_sock *req,
 	req_inet = inet_rsk(req);
 	opt = xchg(&req_inet->opt, opt);
 	if (opt)
-		call_rcu(&opt->rcu, opt_kfree_rcu);
+		kfree_rcu(opt, rcu);
 
 	return 0;
 
@@ -2075,7 +2070,7 @@ static int cipso_v4_delopt(struct ip_options_rcu **opt_ptr)
 		 * remove the entire option struct */
 		*opt_ptr = NULL;
 		hdr_delta = opt->opt.optlen;
-		call_rcu(&opt->rcu, opt_kfree_rcu);
+		kfree_rcu(opt, rcu);
 	}
 
 	return hdr_delta;
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 8aa87c1..5343d9a 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -445,11 +445,6 @@ out:
 }
 
 
-static void opt_kfree_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct ip_options_rcu, rcu));
-}
-
 /*
  *	Socket option code for IP. This is the end of the line after any
  *	TCP,UDP etc options on an IP socket.
@@ -525,7 +520,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 		}
 		rcu_assign_pointer(inet->inet_opt, opt);
 		if (old)
-			call_rcu(&old->rcu, opt_kfree_rcu);
+			kfree_rcu(old, rcu);
 		break;
 	}
 	case IP_PKTINFO:
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index edf167e..30420bc 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -413,12 +413,6 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx, struct ieee80211_sub_if_data
 	return NULL;
 }
 
-static void mesh_gate_node_reclaim(struct rcu_head *rp)
-{
-	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
-	kfree(node);
-}
-
 /**
  * mesh_path_add_gate - add the given mpath to a mesh gate to our path table
  * @mpath: gate path to add to table
@@ -479,7 +473,7 @@ static int mesh_gate_del(struct mesh_table *tbl, struct mesh_path *mpath)
 		if (gate->mpath == mpath) {
 			spin_lock_bh(&tbl->gates_lock);
 			hlist_del_rcu(&gate->list);
-			call_rcu(&gate->rcu, mesh_gate_node_reclaim);
+			kfree_rcu(gate, rcu);
 			spin_unlock_bh(&tbl->gates_lock);
 			mpath->sdata->u.mesh.num_gates--;
 			mpath->is_gate = false;
