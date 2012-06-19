Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab2FSHUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:20:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab2FSHUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:20:33 -0400
Date: Tue, 19 Jun 2012 10:20:30 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] KVM: introduce readonly memslot
Message-ID: <20120619072030.GM6533@redhat.com>
References: <4FD6ADA6.40008@linux.vnet.ibm.com>
 <4FD6AE3B.9020508@linux.vnet.ibm.com>
 <20120616021150.GA3870@amt.cnet>
 <4FDEF9D2.3000909@redhat.com>
 <20120618202505.GA3650@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120618202505.GA3650@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 05:25:05PM -0300, Marcelo Tosatti wrote:
> On Mon, Jun 18, 2012 at 12:50:10PM +0300, Avi Kivity wrote:
> > On 06/16/2012 05:11 AM, Marcelo Tosatti wrote:
> > > 
> > > Can you introduce a separate exit reason, say KVM_EXIT_READ_FAULT, with
> > > information about the fault?
> > 
> > I think you mean WRITE_FAULT.  
> 
> Yes.
> 
> > But what's wrong with the normal mmio exit?
> 
> It is necessary to perform an address->mmio region lookup, to verify
> whether the mmio exit is due to an actual mmio (no memory slot) or from
> a write access to a write protected slot. That information is readily
> available in the kernel but is lost if the mmio exit is used to transmit 
> the information.
> 
Why is it necessary though? Write access to a write protected slot is
MMIO by (our) definition.

> Moreover, i'd argue the uses are different: one is an mmio emulation
> exit, the other is more like handling a pagefault in qemu.
> 
What do you mean by "handling a pagefault in qemu"?

--
			Gleb.
