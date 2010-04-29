Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab0D2BbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 21:31:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:54636 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab0D2BbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 21:31:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,292,1270450800"; 
   d="scan'208";a="562529962"
Subject: Re: [PATCH 2/2] KVM, Fix QEMU-KVM is killed by guest SRAO MCE
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <4BD80449.4010700@redhat.com>
References: <1272351860.24125.15.camel@yhuang-dev.sh.intel.com>
	 <4BD69680.10402@redhat.com>
	 <1272360341.24125.116.camel@yhuang-dev.sh.intel.com>
	 <4BD6AEC7.5020609@redhat.com>
	 <1272423375.24125.189.camel@yhuang-dev.sh.intel.com>
	 <4BD80449.4010700@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Apr 2010 09:31:04 +0800
Message-ID: <1272504664.24125.365.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 17:47 +0800, Avi Kivity wrote:
> On 04/28/2010 05:56 AM, Huang Ying wrote:
> >    
> >>>
> >>> Just want to use the side effect of copy_from_user, SIGBUS will be sent
> >>> to current process because the page touched is marked as poisoned. That
> >>> is, failure is expected, so the return value is not checked.
> >>>
> >>>        
> >> What if the failure doesn't happen?  Say, someone mmap()ed over the page.
> >>      
> > Sorry, not get your idea clearly. hva is re-mmap()ed? We just read the
> > hva, not write, so I think it should be OK here.
> >
> >    
> 
> We don't generate a signal in this case.  Does the code continue to work 
> correctly (not sure what correctly is in this case... should probably 
> just continue).
> 
> There's also the possibility of -EFAULT.

I think signal should be generated for copy_from_user, because the hva
is poisoned now. The signal will not generated only if the hva is
re-mmap()ped to some other physical page, but this should be impossible
unless we have memory hotadd/hotremove in KVM.

If the signal is not generated, lost or overwritten, guest will
continue, and if the hva is still poisoned, the page fault will be
triggered again; if the hva is not poisoned, there will be no further
page fault.

Best Regards,
Huang Ying



