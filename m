Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1LMLym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 06:54:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab1LMLyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 06:54:40 -0500
Date: Tue, 13 Dec 2011 13:54:36 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Liu Ping Fan <kernelfans@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, aliguori@us.ibm.com,
        jan.kiszka@web.de
Subject: Re: [PATCH v3] kvm: make vcpu life cycle separated from kvm instance
Message-ID: <20111213115436.GE12029@redhat.com>
References: <20111209142303.GC31323@redhat.com>
 <1323657683-13934-1-git-send-email-kernelfans@gmail.com>
 <20111213113628.GB31138@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111213113628.GB31138@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 09:36:28AM -0200, Marcelo Tosatti wrote:
> On Mon, Dec 12, 2011 at 10:41:23AM +0800, Liu Ping Fan wrote:
> > From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> > 
> > Currently, vcpu can be destructed only when kvm instance destroyed.
> > Change this to vcpu's destruction taken when its refcnt is zero,
> > and then vcpu MUST and CAN be destroyed before kvm's destroy.
> > 
> > Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> > ---
> >  arch/x86/kvm/i8254.c     |   10 ++++--
> >  arch/x86/kvm/i8259.c     |   12 +++++--
> >  arch/x86/kvm/mmu.c       |    7 ++--
> >  arch/x86/kvm/x86.c       |   54 +++++++++++++++++++----------------
> >  include/linux/kvm_host.h |   71 ++++++++++++++++++++++++++++++++++++++++++----
> >  virt/kvm/irq_comm.c      |    7 +++-
> >  virt/kvm/kvm_main.c      |   62 +++++++++++++++++++++++++++++++++------
> >  7 files changed, 170 insertions(+), 53 deletions(-)
> 
> This needs a full audit of paths that access vcpus. See for one example
> bsp_vcpu pointer.
> 
Yes. For now we should probably disallow removal of bsp, but we need to
get rid of bsp_vcpu at all. It is used only in two places. IOAPIC can be
changed to use kvm->bsp_vcpu_id and pic's use looks incorrect anyway.

--
			Gleb.
