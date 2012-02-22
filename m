Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab2BVRsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:48:33 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55821 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab2BVRs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:48:29 -0500
Date: Wed, 22 Feb 2012 09:48:25 -0800
From: Tejun Heo <tj@kernel.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>, sam@ravnborg.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
Message-ID: <20120222174825.GA32694@google.com>
References: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
 <20120213080618.GA11077@ponder.secretlab.ca>
 <alpine.SOC.1.00.1202131119040.1488@math.ut.ee>
 <20120213214623.GJ11077@ponder.secretlab.ca>
 <alpine.SOC.1.00.1202162151030.16208@math.ut.ee>
 <alpine.SOC.1.00.1202201109260.467@math.ut.ee>
 <20120220170603.GC7836@mtj.dyndns.org>
 <alpine.SOC.1.00.1202210030530.11350@math.ut.ee>
 <20120221010537.GA15898@dhcp-172-17-108-109.mtv.corp.google.com>
 <alpine.SOC.1.00.1202220213180.4171@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1202220213180.4171@math.ut.ee>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 02:36:13AM +0200, Meelis Roos wrote:
> > Meelis, can you please apply the following patch before & after the
> > offending commit, boot with "memblock=debug" added as kernel param and
> > post the boot log?  The patch will generate some offset warnings after
> > the commit but should work fine.
> 
> Before the commit (v3.2-rc3-75-g0ee332c): memblock1.gz (attached)
> After the commit (v3.2-rc3-76-g7bd0b0f): memblock2.gz (attached)

Can you please try the following patch?  If it still fails to boot,
please attach the failing log.  Thank you.

diff --git a/mm/memblock.c b/mm/memblock.c
index 77b5f22..99f2855 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -99,9 +99,6 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 	phys_addr_t this_start, this_end, cand;
 	u64 i;
 
-	/* align @size to avoid excessive fragmentation on reserved array */
-	size = round_up(size, align);
-
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
 		end = memblock.current_limit;
@@ -731,6 +728,9 @@ static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
 {
 	phys_addr_t found;
 
+	/* align @size to avoid excessive fragmentation on reserved array */
+	size = round_up(size, align);
+
 	found = memblock_find_in_range_node(0, max_addr, size, align, nid);
 	if (found && !memblock_reserve(found, size))
 		return found;
