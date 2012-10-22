Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab2JVOBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:01:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab2JVOBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:01:33 -0400
Date: Mon, 22 Oct 2012 16:00:56 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Avi Kivity <avi@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix vcpu->mmio_fragments overflow
Message-ID: <20121022140056.GY29310@redhat.com>
References: <20121022114311.GQ29310@redhat.com>
 <508531E1.2030307@siemens.com>
 <508539A8.40404@redhat.com>
 <50853FF1.8010809@siemens.com>
 <20121022125301.GS29310@redhat.com>
 <50854232.8090309@siemens.com>
 <508542EF.5050401@redhat.com>
 <508544B6.6070301@siemens.com>
 <20121022130810.GW29310@redhat.com>
 <5085495D.6060307@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5085495D.6060307@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 03:25:49PM +0200, Jan Kiszka wrote:
> On 2012-10-22 15:08, Gleb Natapov wrote:
> > On Mon, Oct 22, 2012 at 03:05:58PM +0200, Jan Kiszka wrote:
> >> On 2012-10-22 14:58, Avi Kivity wrote:
> >>> On 10/22/2012 02:55 PM, Jan Kiszka wrote:
> >>>>> Since the userspace change is needed the idea is dead, but if we could
> >>>>> implement it I do not see how it can hurt the latency if it would be the
> >>>>> only mechanism to use coalesced mmio buffer. Checking that the ring buffer
> >>>>> is empty is cheap and if it is not empty it means that kernel just saved
> >>>>> you a lot of 8 bytes exists so even after iterating over all the entries there
> >>>>> you still saved a lot of time.
> >>>>
> >>>> When taking an exit for A, I'm not interesting in flushing stuff for B
> >>>> unless I have a dependency. Thus, buffers would have to be per device
> >>>> before extending their use.
> >>>
> >>> Any mmio exit has to flush everything.  For example a DMA caused by an
> >>> e1000 write has to see any writes to the framebuffer, in case the guest
> >>> is transmitting its framebuffer to the outside world.
> >>
> >> We already flush when that crazy guest actually accesses the region, no
> >> need to do this unconditionally.
> >>
> > What if framebuffer is accessed from inside the kernel? Is this case handled?
> 
> Unless I miss a case now, there is no direct access to the framebuffer
> possible when we are also doing coalescing. Everything needs to go
> through userspace.
> 
Yes, with frame buffer is seems to be the case. One can imagine ROMD
device that is MMIO on write but still can be accessed for read from
kernel, but it cannot be coalesced even if coalesced buffer is flushed
on every exit.

--
			Gleb.
