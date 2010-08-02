Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab0HBOnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:43:18 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35236 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab0HBOnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:43:16 -0400
Date: Mon, 2 Aug 2010 09:42:57 -0500
From: Ryan Harper <ryanh@us.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, vatsa@linux.vnet.ibm.com,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        linux-kernel@vger.kernel.org, npiggin@suse.de, kvm@vger.kernel.org,
        bharata@in.ibm.com, Balbir Singh <balbir@in.ibm.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH RFC 2/4] Add yield hypercall for KVM guests
Message-ID: <20100802144257.GN1647@us.ibm.com>
References: <20100726061150.GB21699@linux.vnet.ibm.com> <20100726061445.GB8402@linux.vnet.ibm.com> <4C4DC3AD.7010404@goop.org> <4C5682A3.40409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5682A3.40409@redhat.com>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2010-08-02 03:33]:
>  On 07/26/2010 08:19 PM, Jeremy Fitzhardinge wrote:
> > On 07/25/2010 11:14 PM, Srivatsa Vaddagiri wrote:
> >>Add KVM hypercall for yielding vcpu timeslice.
> >
> >Can you do a directed yield?
> >
> 
> A problem with directed yield is figuring out who to yield to.  One idea 
> is to look for a random vcpu that is not running and donate some runtime 
> to it.  In the best case, it's the lock holder and we cause it to start 
> running.  Middle case it's not the lock holder, but we lose enough 
> runtime to stop running, so at least we don't waste cpu.  Worst case we 
> continue running not having woken the lock holder.  Spin again, yield 
> again hoping to find the right vcpu.

It's been quite some time, but played with directed yielding for Xen[1]
and we were looking to model the POWER directed yield (H_CONFER) where
the lock holding vcpu was indiciated in the spinlock.  When acquiring
the lock, record the vcpu id.  When another vcpu attempts to acquire the
lock if it can't it can yield its time to the lock holder.

1.  http://lists.xensource.com/archives/html/xen-devel/2005-05/msg00776.html

-- 
Ryan Harper
Software Engineer; Linux Technology Center
IBM Corp., Austin, Tx
ryanh@us.ibm.com
