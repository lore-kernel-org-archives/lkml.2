Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab2GZVk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:40:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55921 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2GZVaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:30:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dimitri Sivanich <sivanich@sgi.com>, Christoph Lameter <cl@gentwo.org>,
        Mel Gorman <mel@csn.ul.ie>, Mel Gorman <mgorman@suse.de>
Subject: [ 07/40] mm/vmstat.c: cache align vm_stat
Date: Thu, 26 Jul 2012 14:29:25 -0700
Message-Id: <20120726211411.751682159@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211411.164006056@linuxfoundation.org>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Sivanich <sivanich@sgi.com>

commit a1cb2c60ddc98ff4e5246f410558805401ceee67 upstream.

Stable note: Not tracked on Bugzilla. This patch is known to make a big
        difference to tmpfs performance on larger machines.

This was found to adversely affect tmpfs I/O performance.

Tests run on a 640 cpu UV system.

With 120 threads doing parallel writes, each to different tmpfs mounts:
No patch:		~300 MB/sec
With vm_stat alignment:	~430 MB/sec

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Acked-by: Christoph Lameter <cl@gentwo.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>

---
 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -78,7 +78,7 @@ void vm_events_fold_cpu(int cpu)
  *
  * vm_stat contains the global counters
  */
-atomic_long_t vm_stat[NR_VM_ZONE_STAT_ITEMS];
+atomic_long_t vm_stat[NR_VM_ZONE_STAT_ITEMS] __cacheline_aligned_in_smp;
 EXPORT_SYMBOL(vm_stat);
 
 #ifdef CONFIG_SMP


