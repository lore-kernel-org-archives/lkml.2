Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937576Ab0CPIZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 04:25:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34454 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936515Ab0CPIZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 04:25:32 -0400
Date: Tue, 16 Mar 2010 09:25:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
Message-ID: <20100316082507.GG18448@elte.hu>
References: <4B990496.4020002@kernel.org>
 <4B9F08AC.9030904@kernel.org>
 <20100316061718.GA22651@elte.hu>
 <84144f021003152358r41a79ccaxb18cf6368911266@mail.gmail.com>
 <b6fcc0a1003160015j2926b2a2w4e7808939c4144d6@mail.gmail.com>
 <4B9F39BE.40502@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F39BE.40502@cs.helsinki.fi>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Alexey Dobriyan kirjoitti:
> >On Tue, Mar 16, 2010 at 8:58 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >> We should avoid creating tree-wide breakage for this kind of cleanups.
> >
> > This is done by compile testing, not by being smartass.
> 
> I don't think compile testing is going to scale here because slab is used is 
> so many places of the kernel.

Yes. In large-scale conversions i typically used (rather extensive) 
build-testing as a tool to check a script's correctness - distinctly _not_ to 
create the actual patch itself.

I.e. it's an adaptive feedback loop in essence: the script gets perfected by 
repeated build tests, and the end result is that we have a scripted conversion 
that covers more code than build testing is able to reach (it covers not just 
x86, covers rare config combos, etc.), _plus_ we also have the final proof of 
the pudding via the actual build tests.

In the end it all converges nicely and the build breakage exported is minimal.

That is the mechanism i suggested. Alexey calls it 'smartass', i call it a 
defensive approach to large-scale changes, that we should practice more, not 
less.

[ Or, sometimes, for visibly trivial matters i just take the gamble, go into 
  cowboy mode and say 'to the heck, let others find those bugs' and do a 
  change based on a sed -i oneliner and build a few configs, fix up the 
  breakages it finds and hope for the best. I dont complain when i get slapped 
  for that though ;-) ]

	Ingo
