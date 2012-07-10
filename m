Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2GJKtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:49:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab2GJKtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:49:11 -0400
Date: Tue, 10 Jul 2012 13:48:47 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: X86: remove read buffer for mmio read
Message-ID: <20120710104847.GD23898@redhat.com>
References: <4FFA9E16.10001@linux.vnet.ibm.com>
 <4FFABD59.2070108@redhat.com>
 <20120709112346.GA23898@redhat.com>
 <4FFAD341.3080508@redhat.com>
 <4FFADB37.4090705@linux.vnet.ibm.com>
 <4FFADDFA.5000603@redhat.com>
 <20120710103629.GC23898@redhat.com>
 <4FFC07BB.8080802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFC07BB.8080802@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 01:45:15PM +0300, Avi Kivity wrote:
> On 07/10/2012 01:36 PM, Gleb Natapov wrote:
> > On Mon, Jul 09, 2012 at 04:34:50PM +0300, Avi Kivity wrote:
> > > On 07/09/2012 04:23 PM, Xiao Guangrong wrote:
> > > > On 07/09/2012 08:49 PM, Avi Kivity wrote:
> > > >> On 07/09/2012 02:23 PM, Gleb Natapov wrote:
> > > >>>
> > > >>>> kvm-unit-tests.git has a test for xchg to mmio.  Does it still work?
> > > >>>>
> > > >>>> I agree this code has to go, but it needs to be replaced by something.
> > > >>>> Maybe a .valid flag in struct operand.
> > > >>>>
> > > >>> Valid will not enough for that.
> > > >> 
> > > >> If we make everything go through operands, any reason why not?
> > > >> 
> > > > 
> > > > I noticed some instructions need to read ESP for many times (e.g, iret_real),
> > > > maybe .valid flag is not enough for this case if the stack is in MMIO, yes?
> > > 
> > > Good catch.  We either have to fix it or to restrict stack operations to
> > > regular memory (->read_std).
> > > 
> > > > IIUC, I also noticed ESP is not reset back if it is emulated fail (mmio is needed).
> > > > If the stack located in mmio region, this kind of instruct will be broken, i know no
> > > > guest will use mmio as stack but SDM does not limit it, is it valid?
> > > 
> > > Stack in mmio (or task switch in mmio) is architecturally valid.  We
> > > don't have to support it if no guests do it.
> > > 
> > But the code is already here, why drop it?
> 
> The read cache is not effective for multiple disjunct reads.
What do you mean?

>                                                                The
> splitting into 8-byte groups is unneeded.
> 
Agree. Easy to fix.

--
			Gleb.
