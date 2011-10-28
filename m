Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1J1BpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 21:45:09 -0400
Received: from mail.solarflare.com ([216.237.3.220]:46051 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1J1BpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 21:45:07 -0400
Message-ID: <1319766293.6759.17.camel@deadeye>
Subject: Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
From: Ben Hutchings <bhutchings@solarflare.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 28 Oct 2011 02:44:53 +0100
In-Reply-To: <CA+55aFy9oJSK99K=brRzSfSnLocO=PuS7yuKkAcw3t5hATJrfw@mail.gmail.com>
References: <1319764761.23112.14.camel@edumazet-laptop>
	 <20111028012521.GF25795@one.firstfloor.org>
	 <CA+55aFy9oJSK99K=brRzSfSnLocO=PuS7yuKkAcw3t5hATJrfw@mail.gmail.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18474.005
X-TM-AS-Result: No--22.788800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 28 Oct 2011 01:45:07.0060 (UTC) FILETIME=[386EBB40:01CC9513]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-27 at 18:34 -0700, Linus Torvalds wrote:
> On Thu, Oct 27, 2011 at 6:25 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > Seems reasonable too. In fact we usually should have memory barriers
> > for this anyways which obsolete the volatile.
> 
> No we shouldn't. Memory barriers are insanely expensive, and pointless
> for atomics - that aren't ordered anyway.
> 
> You may mean compiler barriers.
> 
> That said, removing the volatile entirely might be a good idea, and
> never mind any barriers at all. The ordering for atomics really isn't
> well enough specified that we should care. So I wouldn't object to a
> patch that just removes the volatile entirely, but it would have to be
> accompanied with quite a bit of testing, in case some odd case ends up
> depending on it. But nothing *should* be looping on those things
> anyway.

Whether or not it needs to provide any ordering guarantee, atomic_read()
must never read more than once, and I think that requires the volatile
qualification.  It might be clearer to use the ACCESS_ONCE macro,
however.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

