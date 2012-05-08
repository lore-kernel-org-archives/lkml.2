Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab2EHHRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:17:46 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:50042 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab2EHHRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:17:44 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: Avi Kivity <avi@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Attilio Rao <attilio.rao@citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>, linux-doc@vger.kernel.org,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH RFC V8 0/17] Paravirtualized ticket spinlocks
In-Reply-To: <alpine.LFD.2.02.1205072240020.6271@ionos>
References: <4FA7BABA.4040700@redhat.com> <4FA7CC05.50808@linux.vnet.ibm.com> <4FA7CCA2.4030408@redhat.com> <4FA7D06B.60005@linux.vnet.ibm.com> <20120507134611.GB5533@linux.vnet.ibm.com> <4FA7D2E5.1020607@redhat.com> <4FA7D3F7.9080005@linux.vnet.ibm.com> <4FA7D50D.1020209@redhat.com> <4FA7E06E.20304@linux.vnet.ibm.com> <4FA7E1C8.7010509@redhat.com> <20120507172527.GA5357@gmail.com> <alpine.LFD.2.02.1205072240020.6271@ionos>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Tue, 08 May 2012 12:16:46 +0530
Message-ID: <878vh3rwyx.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12050806-5564-0000-0000-0000028AFCC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2012 22:42:30 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 7 May 2012, Ingo Molnar wrote:
> > * Avi Kivity <avi@redhat.com> wrote:
> > 
> > > > PS: Nikunj had experimented that pv-flush tlb + 
> > > > paravirt-spinlock is a win on PLE where only one of them 
> > > > alone could not prove the benefit.
> > > 
Do not have PLE numbers yet for pvflush and pvspinlock. 

I have seen on Non-PLE having pvflush and pvspinlock patches -
kernbench, ebizzy, specjbb, hackbench and dbench all of them improved. 

I am chasing a race currently on pv-flush path, it is causing
file-system corruption. I will post these number along with my v2 post.

> > > I'd like to see those numbers, then.
> > > 
> > > Ingo, please hold on the kvm-specific patches, meanwhile.
> > 
> > I'll hold off on the whole thing - frankly, we don't want this 
> > kind of Xen-only complexity. If KVM can make use of PLE then Xen 
> > ought to be able to do it as well.
> > 
> > If both Xen and KVM makes good use of it then that's a different 
> > matter.
> 
> Aside of that, it's kinda strange that a dude named "Nikunj" is
> referenced in the argument chain, but I can't find him on the CC list.
> 
/me waves my hand

Regards
Nikunj

