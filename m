Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab1GWAIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 20:08:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab1GWAID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 20:08:03 -0400
Date: Sat, 23 Jul 2011 10:07:50 +1000
From: NeilBrown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Nanosecond fs timestamp support: sad
Message-ID: <20110723100750.12e1a2a1@notabene.brown>
In-Reply-To: <20110722234921.GE10749@fieldses.org>
References: <m2pql2c0qz.fsf@firstfloor.org>
	<20110722163335.2df4f6ca@notabene.brown>
	<1311363269.14555.261.camel@calx>
	<20110722205922.GS8006@one.firstfloor.org>
	<1311369102.14555.268.camel@calx>
	<20110722214732.GW8006@one.firstfloor.org>
	<20110722221039.GB10749@fieldses.org>
	<20110722223158.GC10749@fieldses.org>
	<20110723085915.308ddc02@notabene.brown>
	<20110722230612.GD10749@fieldses.org>
	<20110722234921.GE10749@fieldses.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011 19:49:21 -0400 "J. Bruce Fields" <bfields@fieldses.org>
wrote:

> On Fri, Jul 22, 2011 at 07:06:12PM -0400, J. Bruce Fields wrote:
> > On Sat, Jul 23, 2011 at 08:59:15AM +1000, NeilBrown wrote:
> > > But does anyone apart from NFSv4 actually *want* i_version as opposed to the
> > > more-generally-useful precise timestamps?
> > 
> > It *seems* like a generally useful idea, but I don't know of any other
> > users.
> 
> (Out of curiosity: what actually *needs* real timestamps?:
> 	- They're generally useful to people, of course; ("what did I
> 	  change last tuesday?")

In the same vein they are useful for archiving.  "what has changed since I
last started an archive?"

NFSv3 caching obviously uses them too.

> 	- Make uses them, though in theory perhaps it could do the same
> 	  job by caching records like "object X was built from
> 	  versions a, b, and c of objects A, B, and C respectively".

In theory....

> 
> But a lot of uses are probably just to answer the question "did this
> file change since the last time I looked at it"?

I think everything could fall in two one of two categories.
 a/ did this file change since the last time I looked at it?
 b/ did this file change since the last time that file changed?

The former can be achieved with versions or timestamps.
The latter requires globally coherent high precision timestamps... or
something like dependency tracking which would probably be even more
expensive and - as you say - non-standard.

NeilBrown


> 
> Of course, however theoretically useful, there's always the argument
> that linux-specific interfaces are unlikely to be used by anyone except
> Lennart Poettering.)
> 
> --b.

