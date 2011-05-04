Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab1EDNLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:11:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab1EDNK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:10:59 -0400
Date: Wed, 4 May 2011 16:10:46 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] rcu: export rcu_note_context_switch() function
Message-ID: <20110504131041.GY2265@redhat.com>
References: <1303984323-3203-1-git-send-email-gleb@redhat.com>
 <1303984323-3203-2-git-send-email-gleb@redhat.com>
 <20110429083618.GL2191@linux.vnet.ibm.com>
 <20110429083904.GA12987@linux.vnet.ibm.com>
 <20110429180239.GA32566@redhat.com>
 <20110430125928.GJ2297@linux.vnet.ibm.com>
 <20110502105612.GJ18376@redhat.com>
 <20110502133608.GA4197@linux.vnet.ibm.com>
 <20110502141002.GK18376@redhat.com>
 <20110503062528.GV2294@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503062528.GV2294@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 11:25:28PM -0700, Paul E. McKenney wrote:
> > > > How significantly? As I wrote in other mail I compiled two TINY_RCU
> > > > kernel with and without the patch and I didn't see memory footprint
> > > > increase at all. May be I measure it incorrectly, but what I see is that
> > > > with out of line function + export text section becomes 64 byte bigger, but
> > > > data section becomes 64 byte smaller:
> > > > 
> > > >    text    data     bss     dec     hex filename
> > > > 4544134  590596 2023424 7158154  6d398a vmlinux     inline
> > > > 4544198  590532 2023424 7158154  6d398a vmlinux.ol  out of line
> > > 
> > > Did you add the exports that would be needed to allow KVM to call
> > > the functions in the inline case?
> > > 
> > Yes, this is with and without patch applied. When patch is applied the
> > function is out of line and exported.
> 
> OK, here is what I am suggesting -- create a separate API for virtualization,
> make it be an empty static inline function for TINY, and make it a wrapper
> for TREE.  This gets rid of the export in the TINY case, and takes advantage
> of the single-CPU constraint in the TINY case.  So this gains the benefit
> of uninlining rcu_note_context_switch(), but avoids paying the cost of the
> EXPORT_SYMBOL_GPL().
> 
> Then you call rcu_virt_note_context_switch() in place of
> rcu_note_context_switch() from KVM.
> 
> Does this make sense?
> 
If TINY RCU has such strict code size requirement then yes. I will make
another patch based on this and resend.

--
			Gleb.
