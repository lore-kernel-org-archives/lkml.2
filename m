Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020Ab2DKBvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 21:51:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759999Ab2DKBu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 21:50:59 -0400
Date: Tue, 10 Apr 2012 22:47:12 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
Message-ID: <20120411014712.GA15327@amt.cnet>
References: <4F742951.7080003@linux.vnet.ibm.com>
 <4F82E04E.6000900@redhat.com>
 <20120409175829.GB21894@amt.cnet>
 <4F8329D3.7000605@gmail.com>
 <20120409194614.GB23053@amt.cnet>
 <4F84059D.80606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F84059D.80606@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 01:04:13PM +0300, Avi Kivity wrote:
> On 04/09/2012 10:46 PM, Marcelo Tosatti wrote:
> > Perhaps the mmu_lock hold times by get_dirty are a large component here?
> 
> That's my concern, because it affects the scaling of migration for wider
> guests.
> 
> > If that can be alleviated, not only RO->RW faults benefit.
> 
> Those are the most common types of faults on modern hardware, no?

Depends on your workload, of course. If there is memory pressure,
0->PRESENT might be very frequent. My point is that reduction of
mmu_lock contention is a good thing overall.

