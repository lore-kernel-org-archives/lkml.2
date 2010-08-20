Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab0HTBLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:11:02 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38391 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab0HTBK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:10:59 -0400
From: "Tim Pepper" <lnxninja@linux.vnet.ibm.com>
Date: Thu, 19 Aug 2010 18:10:55 -0700
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 0/4 v2] kvm: rework KVM mmu_shrink() code
Message-ID: <20100820011054.GA11297@tpepper-t61p.dolavim.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series is the four patches Dave Hansen had queued for test
as mentioned last week in the thread: 
  "[PATCH] kvm: make mmu_shrink() fit shrinker's requirement"
Last week just before leaving for vacation Dave had noted in that thread
that these four were ready to merge based on our perf team's testing
finally having wrapped up.  But it turns out he hadn't actually posted
them after refactoring in response to comments back in June...

I'm covering for him in his absence and had previously reviewed this set.
This version contains fixes in response to the comments in June.  The
patches are pulled straight from Dave's development tree, as tested, with
a minor build/merge change to patch #3 which was otherwise inadvertantly
re-introducing an (unused) variable that Avi more recently had removed.

Compared to the previous version from June: 
- patch #3 addresses Marcelo's comment about a double deaccounting
  of kvm->arch.n_used_mmu_pages
- patch #4 includes protection of the used mmu page counts in response to 
  Avi's comments

Avi: if Dave's use of a per cpu counter in the refactored patch #4 is 
acceptable to you, then the series is for merging.

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
