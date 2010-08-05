Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753Ab0HEDRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:17:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16704 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab0HEDRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:17:39 -0400
Date: Wed, 4 Aug 2010 20:14:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Dan Kruchinin <dkruchinin@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Documentation/padata.txt: fix typos etc.
Message-Id: <20100804201452.647aac63.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C5A2D21.00D5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix typos & grammar.
Use CPU instead of cpu in text.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Dan Kruchinin <dkruchinin@acm.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
---
 Documentation/padata.txt |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- lnx26-snap.orig/Documentation/padata.txt
+++ lnx26-snap/Documentation/padata.txt
@@ -19,7 +19,7 @@ overall control of how tasks are to be r
 
 The pcpumask describes which processors will be used to execute work
 submitted to this instance in parallel. The cbcpumask defines which
-processors are allowed to use as the serialization callback processor.
+processors are allowed to be used as the serialization callback processor.
 The workqueue wq is where the work will actually be done; it should be
 a multithreaded queue, naturally.
 
@@ -30,10 +30,10 @@ cpumasks this helper function can be use
 
 Note: Padata maintains two kinds of cpumasks internally. The user supplied
 cpumasks, submitted by padata_alloc/padata_alloc_possible and the 'usable'
-cpumasks. The usable cpumasks are always the subset of active cpus in the
-user supplied cpumasks, these are the cpumasks padata actually use. So
-it is legal to supply a cpumask to padata that contains offline cpus.
-Once a offline cpu in the user supplied cpumask comes online, padata
+cpumasks. The usable cpumasks are always a subset of active CPUs in the
+user supplied cpumasks; these are the cpumasks padata actually uses. So
+it is legal to supply a cpumask to padata that contains offline CPUs.
+Once an offline CPU in the user supplied cpumask comes online, padata
 is going to use it.
 
 There are functions for enabling and disabling the instance:
@@ -44,7 +44,7 @@ There are functions for enabling and dis
 These functions are setting or clearing the "PADATA_INIT" flag;
 if that flag is not set, other functions will refuse to work.
 padata_start returns zero on success (flag set) or -EINVAL if the
-padata cpumask contains no active cpu (flag not set).
+padata cpumask contains no active CPU (flag not set).
 padata_stop clears the flag and blocks until the padata instance
 is unused.
 
@@ -63,11 +63,11 @@ done with great frequency.
 
 It's possible to change both cpumasks of a padata instance with
 padata_set_cpumasks by specifying the cpumasks for parallel execution (pcpumask)
-and for the serial callback function (cbcpumask). padata_set_cpumask is to
+and for the serial callback function (cbcpumask). padata_set_cpumask is used to
 change just one of the cpumasks. Here cpumask_type is one of PADATA_CPU_SERIAL,
 PADATA_CPU_PARALLEL and cpumask specifies the new cpumask to use.
-To simply add or remove one cpu from a certain cpumask the functions
-padata_add_cpu/padata_remove_cpu are used. cpu specifies the cpu to add or
+To simply add or remove one CPU from a certain cpumask the functions
+padata_add_cpu/padata_remove_cpu are used. cpu specifies the CPU to add or
 remove and mask is one of PADATA_CPU_SERIAL, PADATA_CPU_PARALLEL.
 
 If a user is interested in padata cpumask changes, he can register to
@@ -82,7 +82,7 @@ To unregister from that notifier:
 					   struct notifier_block *nblock);
 
 The padata cpumask change notifier notifies about changes of the usable
-cpumasks, i.e. the subset of active cpus in the user supplied cpumask.
+cpumasks, i.e. the subset of active CPUs in the user supplied cpumask.
 
 Padata calls the notifier chain with:
 
@@ -92,7 +92,7 @@ Padata calls the notifier chain with:
 
 Here cpumask_change_notifier is registered notifier, notification_mask
 is one of PADATA_CPU_SERIAL, PADATA_CPU_PARALLEL and cpumask is a pointer
-to a struct padata_cpumask that contains the new cpumask informations.
+to a struct padata_cpumask that contains the new cpumask information.
 
 Actually submitting work to the padata instance requires the creation of a
 padata_priv structure:
@@ -104,7 +104,7 @@ padata_priv structure:
     };
 
 This structure will almost certainly be embedded within some larger
-structure specific to the work to be done.  Most its fields are private to
+structure specific to the work to be done.  Most of its fields are private to
 padata, but the structure should be zeroed at initialisation time, and the
 parallel() and serial() functions should be provided.  Those functions will
 be called in the process of getting the work done as we will see
