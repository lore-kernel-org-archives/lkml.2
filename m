Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab2FRUZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 16:25:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab2FRUZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 16:25:46 -0400
Date: Mon, 18 Jun 2012 17:25:05 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] KVM: introduce readonly memslot
Message-ID: <20120618202505.GA3650@amt.cnet>
References: <4FD6ADA6.40008@linux.vnet.ibm.com>
 <4FD6AE3B.9020508@linux.vnet.ibm.com>
 <20120616021150.GA3870@amt.cnet>
 <4FDEF9D2.3000909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDEF9D2.3000909@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 12:50:10PM +0300, Avi Kivity wrote:
> On 06/16/2012 05:11 AM, Marcelo Tosatti wrote:
> > 
> > Can you introduce a separate exit reason, say KVM_EXIT_READ_FAULT, with
> > information about the fault?
> 
> I think you mean WRITE_FAULT.  

Yes.

> But what's wrong with the normal mmio exit?

It is necessary to perform an address->mmio region lookup, to verify
whether the mmio exit is due to an actual mmio (no memory slot) or from
a write access to a write protected slot. That information is readily
available in the kernel but is lost if the mmio exit is used to transmit 
the information.

Moreover, i'd argue the uses are different: one is an mmio emulation
exit, the other is more like handling a pagefault in qemu.

> > Then perform this exit only if userspace allows it by explicit enable, 
> > and by default have the exit_read_fault handler jump to the mmio
> > handler. 
> 
> 
> I don't get this.


CAN USERSPACE HANDLE WRITE FAULT EXITS?
YES: WRITE FAULT EXIT.
NO: MMIO EXIT.

But then again userspace won't set read-only slots if it does not know
about them. So it is not necessary.

