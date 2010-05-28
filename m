Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab0E1RoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:44:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37607 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842Ab0E1RoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:44:04 -0400
Date: Fri, 28 May 2010 10:41:41 -0700
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, ngupta@vflare.org, JBeulich@novell.com,
       chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com, avi@redhat.com, pavel@ucw.cz, konrad.wilk@oracle.com,
       dan.magenheimer@oracle.com
Subject: [PATCH V2 4/4] Frontswap (was Transcendent Memory): config files
Message-ID: <20100528174141.GA28278@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4C0000AB.006F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH V2 4/4] Frontswap (was Transcendent Memory): config files

Frontswap config defaults to on as the hooks devolve to
pointer-compare-to-NULL if no frontswap backend is provided.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Diffstat:
 Kconfig                                  |   16 ++++++++++++++++
 Makefile                                 |    1 +
 2 files changed, 17 insertions(+)

--- linux-2.6.34/mm/Makefile	2010-05-16 15:17:36.000000000 -0600
+++ linux-2.6.34-frontswap/mm/Makefile	2010-05-21 12:59:10.000000000 -0600
@@ -17,6 +17,7 @@ obj-y += init-mm.o
 
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
+obj-$(CONFIG_FRONTSWAP)	+= frontswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
--- linux-2.6.34/mm/Kconfig	2010-05-16 15:17:36.000000000 -0600
+++ linux-2.6.34-frontswap/mm/Kconfig	2010-05-21 12:59:10.000000000 -0600
@@ -287,3 +287,19 @@ config NOMMU_INITIAL_TRIM_EXCESS
 	  of 1 says that all excess pages should be trimmed.
 
 	  See Documentation/nommu-mmap.txt for more information.
+
+config FRONTSWAP
+	bool "Enable frontswap pseudo-RAM driver to cache swap pages"
+	default y
+	help
+ 	  Frontswap is so named because it can be thought of as the opposite of
+ 	  a "backing" store for a swap device.  The storage is assumed to be
+ 	  a synchronous concurrency-safe page-oriented pseudo-RAM device (such
+	  as Xen's Transcendent Memory, aka "tmem") which is not directly
+	  accessible or addressable by the kernel and is of unknown (and
+	  possibly time-varying) size.  When a pseudo-RAM device is available,
+	  a signficant swap I/O reduction may be achieved.  When none is
+	  available, all frontswap calls are reduced to a single pointer-
+	  compare-against-NULL resulting in a negligible performance hit.
+
+	  If unsure, say Y to enable frontswap.
