Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843Ab1D2SXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:23:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774Ab1D2SXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:23:50 -0400
Date: Fri, 29 Apr 2011 21:23:47 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] rcu: export rcu_note_context_switch() function
Message-ID: <20110429182347.GB32566@redhat.com>
References: <1303984323-3203-1-git-send-email-gleb@redhat.com>
 <1303984323-3203-2-git-send-email-gleb@redhat.com>
 <20110429083618.GL2191@linux.vnet.ibm.com>
 <20110429083904.GA12987@linux.vnet.ibm.com>
 <20110429180239.GA32566@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110429180239.GA32566@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 09:02:39PM +0300, Gleb Natapov wrote:
> On Fri, Apr 29, 2011 at 01:39:04AM -0700, Paul E. McKenney wrote:
> > On Fri, Apr 29, 2011 at 01:36:18AM -0700, Paul E. McKenney wrote:
> > > On Thu, Apr 28, 2011 at 12:52:02PM +0300, Gleb Natapov wrote:
> > > 
> > > Hmmm....  This is interesting.  KVM being a module, we either expand
> > > TINY_RCU's size a bit by making rcu_note_context_switch() be a real
> > > function in rcutiny.c and adding an export, or we expand it by adding
> > > two exports.
> > > 
> > > I would like to solve this without making TINY_RCU larger, and preferably
> > > by making it smaller.  Any ideas come to mind?  (Other than making
> > > KVM depend on CONFIG_SMP, which sounds too much like throwing out the
> > > baby with the bathwater.)
> > 
> > Nothing quite like hitting "send" to make an idea show up...
> > 
> > In a UP kernel, does it actually help anything to have KVM
> > tell RCU about executing in a guest?  If not, could we have a
> > rcu_note_context_switch_kvm() that is a static inline empty function in
> > TINY_RCU and maps to rcu_note_context_switch() for TREE_RCU?
> > 
> That will work, but does making rcu_note_context_switch() out of line
> actually increase kernel size? The function is called in two places
> currently, so by making it out of line we make two calling site smaller.
> Will measure it next week.
> 
Why wait for so long? Here is the result:
   text    data     bss     dec     hex filename
4544134  590596 2023424 7158154  6d398a vmlinux     inline
4544198  590532 2023424 7158154  6d398a vmlinux.ol  out of line

So in out of line version text is 64 byte bigger, but data is 64 byte
smaller. Hmm.

--
			Gleb.
