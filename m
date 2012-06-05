Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab2FENJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:09:54 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36654 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2FENJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:09:52 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "peterz\@infradead.org" <peterz@infradead.org>
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "mingo\@elte.hu" <mingo@elte.hu>,
        "mtosatti\@redhat.com" <mtosatti@redhat.com>,
        "avi\@redhat.com" <avi@redhat.com>,
        "raghukt\@linux.vnet.ibm.com" <raghukt@linux.vnet.ibm.com>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>,
        "jeremy\@goop.org" <jeremy@goop.org>,
        "vatsa\@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "hpa\@zytor.com" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 6/7] kvm,x86: RCU based table free
In-Reply-To: <alpine.DEB.2.02.1206051232270.6030@kaball.uk.xensource.com>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com> <20120604050822.4560.54662.stgit@abhimanyu.in.ibm.com> <alpine.DEB.2.02.1206051137270.6030@kaball.uk.xensource.com> <87ehpuqam8.fsf@linux.vnet.ibm.com> <alpine.DEB.2.02.1206051232270.6030@kaball.uk.xensource.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Tue, 05 Jun 2012 18:34:31 +0530
Message-ID: <878vg1rjts.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12060502-0260-0000-0000-0000014C63EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012 12:58:32 +0100, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> On Tue, 5 Jun 2012, Nikunj A Dadhania wrote:
> > On Tue, 5 Jun 2012 11:48:02 +0100, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > > 
> > > I am also interested in introducing HAVE_RCU_TABLE_FREE on x86 for Xen.
> > > Maybe we can pull our efforts together :-)
> > > 
> > > Giving a look at this patch, it doesn't look like it is introducing
> > > CONFIG_HAVE_RCU_TABLE_FREE anywhere under arch/x86.
> > > How is the user supposed to set it?
> > >
> > I am doing that in the next patch only for KVM-ParavirtTLB flush, as
> > there is a bug in this implementation that patch [7/7] fixes.
> > 
> > Refer following thread for details:
> > http://mid.gmane.org/1337254086.4281.26.camel@twins
> > http://mid.gmane.org/1337273959.4281.62.camel@twins
> 
> Thanks, somehow I missed the 7/7 patch.
> 
> From the Xen POV, your patch is fine because we'll just select
> PARAVIRT_TLB_FLUSH on CONFIG_XEN (see appended patch for completeness).
> 
Selecting ARCH_HW_WALKS_PAGE_TABLE in place of PARAVIRT_TLB_FLUSH should
suffice.

> The main difference between the two approaches is that a kernel with
> PARAVIRT_TLB_FLUSH and/or CONFIG_XEN enabled is going to have
> HAVE_RCU_TABLE_FREE even when running on native.
> 
> Are you proposing this series for 3.5?
> If not (because it depends on ticketlocks and KVM Paravirt Spinlock
> patches), 
>
3.6 I suppose as the merge window is already closed and we are having
some discussions on PLE results.

> could you extract patch 6/7 and 7/7 and send them out
> separately?
>
> I am saying this because Xen needs the HAVE_RCU_TABLE_FREE fix even if
> pv ticketlock are not accepted. This is an outstanding bug for us
> unfortunately.
> 
PeterZ has a patch in his tlb-unify:

    mm, x86: Add HAVE_RCU_TABLE_FREE support
    
    Implements optional HAVE_RCU_TABLE_FREE support for x86.
    
    This is useful for things like Xen and KVM where paravirt tlb flush
    means the software page table walkers like GUP-fast cannot rely on
    IRQs disabling like regular x86 can.
    
    Cc: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
    Cc: Jeremy Fitzhardinge <jeremy@goop.org>
    Cc: Avi Kivity <avi@redhat.com>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

http://git.kernel.org/?p=linux/kernel/git/peterz/mmu.git;a=commit;h=8a7e6fa5be9d2645c3394892c870113e6e5d9309

PeterZ, is 7/7 alright to be picked?

Regards
Nikunj


