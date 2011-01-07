Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab1AGIZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 03:25:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab1AGIZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 03:25:45 -0500
Date: Fri, 7 Jan 2011 09:25:36 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, caiqian@redhat.com,
        nacc@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: + hugetlb-handle-nodemask_alloc-failure-correctly.patch added
 to -mm tree
Message-ID: <20110107082536.GA1891@tiehlicka.suse.cz>
References: <201101062039.p06Kd3ZL014025@imap1.linux-foundation.org>
 <alpine.DEB.2.00.1101061641370.9419@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101061641370.9419@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-01-11 16:42:06, David Rientjes wrote:
> On Thu, 6 Jan 2011, akpm@linux-foundation.org wrote:
[...]
> This patch is wrong, both functions may handle a NULL nodes_allowed, which 
> is why the __GFP_NORETRY is explicitly part of the gfp mask.
> 
> In both functions, init_nodemask_of_mempolicy() will immediately return 
> false if the mask is NULL.  If so, it is set to node_states[N_HIGH_MEMORY] 
> in the caller and we're careful to avoid calling the NODMASK_FREE() in 
> that case.  They are carefully coded in this way so they operate over all 
> nodes with memory rather than failing with -ENOMEM.

OK, I see. Thanks for the review.

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
