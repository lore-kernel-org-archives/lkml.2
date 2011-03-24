Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab1CXR1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:27:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35211 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab1CXR1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:27:04 -0400
Date: Thu, 24 Mar 2011 18:26:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
Message-ID: <20110324172653.GA28507@elte.hu>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
 <20110324142146.GA11682@elte.hu>
 <alpine.DEB.2.00.1103240940570.32226@router.home>
 <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> On Thu, Mar 24, 2011 at 4:41 PM, Christoph Lameter <cl@linux.com> wrote:
> > On Thu, 24 Mar 2011, Ingo Molnar wrote:
> >
> >> FYI, some sort of boot crash has snuck upstream in the last 24 hours:
> >>
> >>  BUG: unable to handle kernel paging request at ffff87ffc147e020
> >>  IP: [<ffffffff811aa762>] this_cpu_cmpxchg16b_emu+0x2/0x1c
> >
> > Hmmm.. This is the fallback code for the case that the processor does not
> > support cmpxchg16b.
> 
> How does alternative_io() work? Does it require
> alternative_instructions() to be executed. If so, the fallback code
> won't be active when we enter kmem_cache_init(). Is there any reason
> check_bugs() is called so late during boot? Can we do something like
> the totally untested attached patch?

Does the config i sent you boot on your box? I think the bug is pretty generic 
and should trigger on any box.

Thanks,

	Ingo
