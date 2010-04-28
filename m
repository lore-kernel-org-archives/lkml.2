Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab0D1C4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 22:56:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:57108 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab0D1C4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 22:56:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,285,1270450800"; 
   d="scan'208";a="793411662"
Subject: Re: [PATCH 2/2] KVM, Fix QEMU-KVM is killed by guest SRAO MCE
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <4BD6AEC7.5020609@redhat.com>
References: <1272351860.24125.15.camel@yhuang-dev.sh.intel.com>
	 <4BD69680.10402@redhat.com>
	 <1272360341.24125.116.camel@yhuang-dev.sh.intel.com>
	 <4BD6AEC7.5020609@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 10:56:15 +0800
Message-ID: <1272423375.24125.189.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-27 at 17:30 +0800, Avi Kivity wrote:
> On 04/27/2010 12:25 PM, Huang Ying wrote:
> >
> >
> >> On 04/27/2010 10:04 AM, Huang Ying wrote:
> >>      
> >>> +static void kvm_send_hwpoison_signal(struct kvm *kvm, gfn_t gfn)
> >>> +{
> >>> +	char buf[1];
> >>> +	void __user *hva;
> >>> +	int r;
> >>> +
> >>> +	/* Touch the page, so send SIGBUS */
> >>> +	hva = (void __user *)gfn_to_hva(kvm, gfn);
> >>> +	r = copy_from_user(buf, hva, 1);
> >>>
> >>>        
> >> No error check?  What will a copy_from_user() of poisoned page expected
> >> to return?
> >>
> >> Best to return -EFAULT on failure for consistency.
> >>      
> > Just want to use the side effect of copy_from_user, SIGBUS will be sent
> > to current process because the page touched is marked as poisoned. That
> > is, failure is expected, so the return value is not checked.
> >    
> 
> What if the failure doesn't happen?  Say, someone mmap()ed over the page.

Sorry, not get your idea clearly. hva is re-mmap()ed? We just read the
hva, not write, so I think it should be OK here.

> btw, better to use (void)copy_from_user(...) instead to avoid the 
> initialized but not used warning the compiler may generate.

OK. Will do that.

Best Regards,
Huang Ying


