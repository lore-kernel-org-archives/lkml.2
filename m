Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab2JKINi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:13:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51711 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756263Ab2JKINe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:13:34 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18M58Vpxv8MZ78OT/sn2gsZZrLhl3MF6EJbn7aR8T
	SUDj8BXi+ieMD7
Message-ID: <1349943207.6989.77.camel@marge.simpson.net>
Subject: Re: Meaningless load?
From: Mike Galbraith <efault@gmx.de>
To: Simon Klinkert <simon.klinkert@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        mingo@redhat.com, Trond.Myklebust@netapp.com
Date: Thu, 11 Oct 2012 10:13:27 +0200
In-Reply-To: <8CCB73B0-34AD-47E2-9379-DB6F02DB35F5@gmail.com>
References: <98F2F644-D531-42FE-B080-9561142D71C8@gmail.com>
	 <1349886164.1279.20.camel@twins>
	 <8CCB73B0-34AD-47E2-9379-DB6F02DB35F5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 09:19 +0200, Simon Klinkert wrote:
> On 10.10.2012, at 18:22, Peter Zijlstra wrote:
> 
> > On Wed, 2012-10-10 at 17:44 +0200, Simon Klinkert wrote:
> >> I'm just wondering if the 'load' is really meaningful in this
> >> scenario. The machine is the whole time fully responsive and looks
> >> fine to me but maybe I didn't understand correctly what the load
> >> should mean. Is there any sensible interpretation of the load?
> > 
> > I'll leave meaningful aside, but uninterruptible (D state) is part
> of
> > how the load thing is defined, so your 500 result is correct.
> 
> Yes, the calculation of the load is correct but I still don't know how
> I should interpret the load…
> 
> On 11.10.2012, at 06:02, Mike Galbraith wrote:
> 
> > Makes perfect sense to me. Work _is_ stack this high. We don't and
> > can't know whether the mountain is made of popcorn balls or
> boulders.
> 
> That's the point. Afaik the D state never represents 'work'. These
> processes are waiting for something.

Yeah, the whole pile is waiting, but they're not idle.  There are N
tasks pointed at CPUs.
> 
> Let's say we have 10,000 processes in the D state (and thus a load of
> ~10,000) doing nothing. What should the load tell me? The machine is
> under fire? There is nothing to do? There might be something to do but
> the machine doesn't know?

They are doing something, just not at the particular instant you see
them in D state.  D state pushing load through the roof tells you that
you have a bottleneck.  Whether the bottleneck is a bit of spinning rust
or insufficient NR_CPUS doesn't matter much, both are bottlenecks.

-Mike

