Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab0FCHsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:48:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:47810 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab0FCHsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:48:24 -0400
Subject: Re: [PATCH] rbtree: undo augmented damage -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <1275549226.27810.34762.camel@twins>
References: <20100210232343.GA11465@linux-os.sc.intel.com>
	 <tip-17d9ddc72fb8bba0d4f67868c9c612e472a594a9@git.kernel.org>
	 <1275136178.27810.13539.camel@twins> <1275139902.27810.13737.camel@twins>
	 <AANLkTimZkyRwP5k290rUr-DUMhsynl9fzBkS68x-57KM@mail.gmail.com>
	 <1275412748.27810.27883.camel@twins>
	 <AANLkTilGfY1PnNgpEeB3AQEqTNoDJQfPTxK5LNUYb7ZA@mail.gmail.com>
	 <1275414172.27810.27961.camel@twins>
	 <AANLkTil8ly_3P2DgEI9oI_ZbYP6FkwP2lCY2v47iAn9-@mail.gmail.com>
	 <1275417720.27810.28160.camel@twins>
	 <1275513074.2913.258.camel@sbs-t61.sc.intel.com>
	 <1275549226.27810.34762.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Jun 2010 09:48:34 +0200
Message-ID: <1275551314.27810.34894.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 09:13 +0200, Peter Zijlstra wrote:
> On Wed, 2010-06-02 at 14:11 -0700, Suresh Siddha wrote:
> >       P                       SL
> >     /  \                     /  \
> >    N    S       --->        N    S
> >   /   /  \                 /      \
> >  C   SL  SR               C        SR
> > 
> > If P needs to be removed, we need to re-augment S also in this case,
> > right? It looks like we are not handling this case.
> 
> 
> rb_augment_erase_begin(P) will return S if I read the code right, so
> rb_augment_path(S) will the re-augment S, SL, N.

To be more explicit: P has two children, so we select the next entry,
SL, as its substitute. Since SL doesn't have a right child we select its
parent, S.

If SL were to represent a subtree with a right child, then we'd select
that, lets call it SLR. SLR would then end up being a direct descendant
of S, and hence rb_augment_path(SLR) would still pass S on its way up.


