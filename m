Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab2BIQGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:06:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab2BIQGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:06:33 -0500
Message-ID: <4F33EEB3.4080807@redhat.com>
Date: Thu, 09 Feb 2012 18:05:07 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
References: <alpine.DEB.2.00.1202011404500.2074@router.home> <20120201201336.GI2382@linux.vnet.ibm.com> <4F2A58A1.90800@redhat.com> <20120202153437.GD2518@linux.vnet.ibm.com> <4F2AB66C.2030309@redhat.com> <20120202170134.GM2518@linux.vnet.ibm.com> <4F2AC69B.7000704@redhat.com> <20120202175155.GV2518@linux.vnet.ibm.com> <4F2E7311.8060808@redhat.com> <20120205165927.GH2467@linux.vnet.ibm.com> <20120209152155.GA22552@somewhere.redhat.com>
In-Reply-To: <20120209152155.GA22552@somewhere.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 05:22 PM, Frederic Weisbecker wrote:
> > > 
> > > Looks like there are new rcu_user_enter() and rcu_user_exit() APIs which
> > > we can use.  Hopefully they subsume rcu_virt_note_context_switch() so we
> > > only need one set of APIs.
> > 
> > Now that you mention it, that is a good goal.  However, it requires
> > coordination with Frederic's code as well, so some investigation
> > is required.  Bad things happen if you tell RCU you are idle when you
> > really are not and vice versa!
> > 
> > 							Thanx, Paul
> > 
>
> Right. Avi I need to know more about what you need. rcu_virt_note_context_switch()
> notes a quiescent state while rcu_user_enter() shuts down RCU (it's in fact the same
> thing than rcu_idle_enter() minus the is_idle_cpu() checks).

I don't know enough about RCU to say if it's okay or not (I typically
peek at the quick quiz answers).  However, switching to guest mode is
very similar to exiting to user mode: we're guaranteed not to be in an
rcu critical section, and to remain so until the guest exits back to
us.  What guarantees does rcu_user_enter() provide?  With luck guest
entry satisifies them all.

-- 
error compiling committee.c: too many arguments to function

