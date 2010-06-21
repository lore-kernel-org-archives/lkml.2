Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab0FURzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:55:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:63819 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758059Ab0FURzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:55:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,454,1272870000"; 
   d="scan'208";a="578409905"
Subject: Re: [patch] x86, pat: freeing invalid memtype messages
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Xiaotian Feng <dfeng@redhat.com>, Dan Carpenter <error27@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H.PeterA" <nvinhpa@zytor.com>, Venkatesh Pallipadi <venki@google.com>,
       Jack Steiner <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <1277134873.1875.520.camel@laptop>
References: <20100617134559.GA29824@bicker> <20100617161728.GA2741@joi.lan>
	 <4C1B1691.6020809@redhat.com> <20100618175726.GA2785@joi.lan>
	 <4C1F455E.6050502@redhat.com> <1277118155.1875.508.camel@laptop>
	 <4C1F47EF.2060509@redhat.com>  <20100621153303.GA2754@joi.lan>
	 <1277134873.1875.520.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 21 Jun 2010 10:54:20 -0700
Message-Id: <1277142860.3017.22.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 08:41 -0700, Peter Zijlstra wrote:
> On Mon, 2010-06-21 at 17:33 +0200, Marcin Slusarz wrote:
> > On Mon, Jun 21, 2010 at 07:07:27PM +0800, Xiaotian Feng wrote:
> > > On 06/21/2010 07:02 PM, Peter Zijlstra wrote:
> > > > On Mon, 2010-06-21 at 18:56 +0800, Xiaotian Feng wrote:
> > > >
> > > >> I guess there might be something wrong between the augmented rbtree insert/remove ..
> > > >
> > > > The easiest thing is to revert that change and try again, the next step
> > > > would be to print the full RB tree on each modification and look where
> > > > it goes wrong.
> > > >
> > > > That said, I did print my fair share of (augmented) RB trees while
> > > > playing with scheduler patches and I can't remember it ever having
> > > > messed up like that.
> > > He's using 2.6.35-rc2+, without your "rbtree: Undo augmented trees 
> > > performance damage" patch ;-)
> > 
> > I applied it manually (commit 2463eb8b3093995e09a0d41b3d78ee0cf5fb4249 from -tip)
> > to 2.6.35-rc3 and it fixed both acpi's and nouveau's "invalid memtype" messages.
> > Thanks.
> 
> Oh neat, so it actually fixes a bug in the previous augmented rb-tree
> implementation?

When I was reviewing your fix, it looked like that prior to your fix we
were re-augmenting only at points where we do the tree rotations/color
change and at the points of node insertion/removal. I don't think we
were re-augmenting all the parent nodes in the path of the selected-node
that is going to replace the deleted node.

Perhaps we were hitting this issue here.

thanks,
suresh

