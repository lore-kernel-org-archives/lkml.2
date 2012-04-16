Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2DPOPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:15:03 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43206 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab2DPOPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:15:00 -0400
Date: Mon, 16 Apr 2012 23:14:55 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 04/16] KVM: MMU: return bool in __rmap_write_protect
Message-Id: <20120416231455.f978b3ac9fb995cfce2853ae@gmail.com>
In-Reply-To: <4F8AB02A.9020601@redhat.com>
References: <4F87FA69.5060106@linux.vnet.ibm.com>
	<4F87FBC1.5010907@linux.vnet.ibm.com>
	<20120414110031.38450bebfe712215f01d529f@gmail.com>
	<4F8AB02A.9020601@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Apr 2012 14:25:30 +0300
Avi Kivity <avi@redhat.com> wrote:

> > > @@ -1689,7 +1690,7 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
> > > 
> > >  	kvm_mmu_pages_init(parent, &parents, &pages);
> > >  	while (mmu_unsync_walk(parent, &pages)) {
> > > -		int protected = 0;
> > > +		bool protected = false;
> > > 
> > >  		for_each_sp(pages, sp, parents, i)
> > >  			protected |= rmap_write_protect(vcpu->kvm, sp->gfn);
> >
> > Isn't this the reason we prefer int to bool?
> >
> > Not sure people like to use |= with boolean.
> >
> 
> Why not?
> 

The code "bitwise OR assignment" is assuming the internal representations
of true and false: true=1, false=0.

I might have seen some point if it had been
	protected = protected || rmap_...


But the real question is whether there is any point in re-writing completely
correct C code: there are tons of int like this in the kernel code.

__rmap_write_protect() was introduced recently, so if this conversion is
really worthwhile, I should have been told to use bool at that time, no?


Thanks,
	Takuya
