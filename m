Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2FRQB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:01:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab2FRQBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:01:55 -0400
Date: Mon, 18 Jun 2012 19:01:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv7 5/8] kvm: eoi msi documentation
Message-ID: <20120618160136.GH26540@redhat.com>
References: <cover.1339681762.git.mst@redhat.com>
 <dd9306b83249bce230ef9a9011887e2a67974b55.1339681762.git.mst@redhat.com>
 <4FDF3911.7020902@redhat.com>
 <20120618145626.GF26540@redhat.com>
 <4FDF434E.1040907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDF434E.1040907@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 06:03:42PM +0300, Avi Kivity wrote:
> On 06/18/2012 05:56 PM, Michael S. Tsirkin wrote:
> > On Mon, Jun 18, 2012 at 05:20:01PM +0300, Avi Kivity wrote:
> >> On 06/14/2012 04:53 PM, Michael S. Tsirkin wrote:
> >> > Document the new EOI MSR. Couldn't decide whether this change belongs
> >> > conceptually on guest or host side, so a separate patch.
> >> > 
> >> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >> > ---
> >> >  Documentation/virtual/kvm/msr.txt | 32 ++++++++++++++++++++++++++++++++
> >> >  1 file changed, 32 insertions(+)
> >> > 
> >> > diff --git a/Documentation/virtual/kvm/msr.txt b/Documentation/virtual/kvm/msr.txt
> >> > index 96b41bd..6ae5a85 100644
> >> > --- a/Documentation/virtual/kvm/msr.txt
> >> > +++ b/Documentation/virtual/kvm/msr.txt
> >> > @@ -223,3 +223,35 @@ MSR_KVM_STEAL_TIME: 0x4b564d03
> >> >  		steal: the amount of time in which this vCPU did not run, in
> >> >  		nanoseconds. Time during which the vcpu is idle, will not be
> >> >  		reported as steal time.
> >> > +
> >> > +MSR_KVM_EOI_EN: 0x4b564d04
> >> > +	data: Bit 0 is 1 when PV end of interrupt is enabled on the vcpu; 0
> >> > +	when disabled.  When enabled, bits 63-1 hold 2-byte aligned physical address
> >> > +	of a 2 byte memory area which must be in guest RAM and must be zeroed.
> >> 
> >> 2 byte aligned means we must never access it on the host with a >2 byte
> >> instruction, or we risk touching unmapped memory.
> > 
> > Yes. So ... that's correct for any length.
> > The patch actually accesses a single byte only.
> > 
> > Could you clarify what you are saying here please?
> > 
> 
> It means, if we want to use __set_bit() (and if __set_bit wants to
> access this as a long) then we can get an exception.

We can't use __set_bit. It's in guest memory.

> The spec shouldn't limit us in this way, even if the implementation is okay.

This specific spec seems to create the smallest possible amount
of work for the hypervisor. You have an idea for an interface
that will make the hypervisor side even more compact?
Can you clarify?

> -- 
> error compiling committee.c: too many arguments to function
> 
