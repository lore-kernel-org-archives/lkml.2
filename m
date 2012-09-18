Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab2ISVXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:23:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab2ISVXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:23:40 -0400
Date: Tue, 18 Sep 2012 20:43:07 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] KVM: MMU: introduce page_fault_start and
 page_fault_end
Message-ID: <20120918234307.GA5062@amt.cnet>
References: <5052FF61.3070600@linux.vnet.ibm.com>
 <5052FFEA.1040607@linux.vnet.ibm.com>
 <20120915152512.GB3037@amt.cnet>
 <50582DA4.8060000@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50582DA4.8060000@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 04:15:32PM +0800, Xiao Guangrong wrote:
> On 09/15/2012 11:25 PM, Marcelo Tosatti wrote:
> > On Fri, Sep 14, 2012 at 05:59:06PM +0800, Xiao Guangrong wrote:
> >> Wrap the common operations into these two functions
> >>
> >> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> > 
> > Why? I think people are used to 
> > 
> > spin_lock(lock)
> > sequence
> > spin_unlock(lock)
> 
> Marcelo,
> 
> There are many functions use this style that wrap the lock into the
> _start and _end functions in kernel (eg.: cgroup_pidlist_start and
> cgroup_pidlist_stop in kernel/cgroup.c).
> 
> Actually, i just wanted to remove below duplicate ugly code:
> 
> 	if (!is_error_pfn(pfn))
> 		kvm_release_pfn_clean(pfn);
> 
> > 
> > So its easy to verify whether access to data structures are protected.
> > 
> > Unrelated to this patch, one opportunity i see to simplify this
> > code is:
> > 
> > - error pfn / mmio pfn / invalid pfn relation
> > 
> > Have the meaning of this bits unified in a single function/helper, see
> > comment to patch 1 (perhaps you can further improve).
> 
> Sorry, more detail?

Should force the reader of the code to understand error pfn / mmio pfn /
invalid pfn in a single helper. That is, avoid using error pfn at all.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
