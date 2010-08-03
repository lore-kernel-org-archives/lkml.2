Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab0HCEQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:16:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35383 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab0HCEQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:16:48 -0400
Date: Tue, 3 Aug 2010 14:16:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Nixon <alex.nixon@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: linux-next: manual merge of the xen tree with the swiotlb tree
Message-Id: <20100803141646.594e0fee.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the xen tree got a conflict in
include/xen/xen-ops.h between commit
08bbc9da92f7e44b9c208c6a1adba70c403b255e ("xen: Add
xen_create_contiguous_region") from the swiotlb tree and commit
016b6f5fe8398b0291cece60b749d7c930a2e09c ("xen: Add suspend/resume
support for PV on HVM guests") from the xen tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/xen/xen-ops.h
index d789c93,46bc81e..0000000
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@@ -14,10 -15,6 +15,12 @@@ void xen_mm_unpin_all(void)
  void xen_timer_resume(void);
  void xen_arch_resume(void);
  
 +extern unsigned long *xen_contiguous_bitmap;
 +int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
 +				unsigned int address_bits);
 +
 +void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order);
 +
+ int xen_setup_shutdown_event(void);
+ 
  #endif /* INCLUDE_XEN_OPS_H */
