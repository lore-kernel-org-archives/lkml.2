Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab1CWMfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:35:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60246 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab1CWMfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:35:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=u5St6+m7TzUhGPjP5FwS2bgANAcbkvvWwY2IPRzcIoCnEcubxKhg9+cz/NWMTKflWN
         Fuqq5G3TkqQm4daqDTPQFCOiCW6O1EJimsKY7Wa9yAGg3h7axGuXFSFtbLYd6Jn7EpSD
         7Vn8kwqcTLWHNGJEEJyjoxa+6jkX4oXZeLxzM=
Date: Wed, 23 Mar 2011 14:38:28 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] lockdep: remove unused factor variable from
 lockdep_stats_show
Message-ID: <20110323123828.GB4244@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lockdep: remove unused factor variable from lockdep_stats_show

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 kernel/lockdep_proc.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 1969d2f..71edd2f 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -225,7 +225,7 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 		      nr_irq_read_safe = 0, nr_irq_read_unsafe = 0,
 		      nr_softirq_read_safe = 0, nr_softirq_read_unsafe = 0,
 		      nr_hardirq_read_safe = 0, nr_hardirq_read_unsafe = 0,
-		      sum_forward_deps = 0, factor = 0;
+		      sum_forward_deps = 0;
 
 	list_for_each_entry(class, &all_lock_classes, lock_entry) {
 
@@ -283,13 +283,6 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 			nr_hardirq_unsafe * nr_hardirq_safe +
 			nr_list_entries);
 
-	/*
-	 * Estimated factor between direct and indirect
-	 * dependencies:
-	 */
-	if (nr_list_entries)
-		factor = sum_forward_deps / nr_list_entries;
-
 #ifdef CONFIG_PROVE_LOCKING
 	seq_printf(m, " dependency chains:             %11lu [max: %lu]\n",
 			nr_lock_chains, MAX_LOCKDEP_CHAINS);

