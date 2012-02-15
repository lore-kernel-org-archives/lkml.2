Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab2BOPTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:19:14 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51313 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2BOPTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:19:13 -0500
MIME-Version: 1.0
X-Originating-IP: [109.64.24.177]
In-Reply-To: <1329318679.2293.140.camel@twins>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
	<1327591185.2446.102.camel@twins>
	<CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>
	<20120201170443.GE6731@somewhere.redhat.com>
	<CAOtvUMc8L1nh2eGJez0x44UkfPCqd+xYQASsKOP76atopZi5mw@mail.gmail.com>
	<4F2AAEB9.9070302@tilera.com>
	<1328899105.25989.37.camel@laptop>
	<CAOtvUMf11CxFV+FR8YCjqaoEWojGT7oX46_QamjCkXkHzsW3-A@mail.gmail.com>
	<1329318679.2293.140.camel@twins>
Date: Wed, 15 Feb 2012 17:19:11 +0200
Message-ID: <CAOtvUMeo1=P-4g4ACG3MdSMv_pkQJiDEJQ4cuLTEhrUa+kKGyA@mail.gmail.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 5:11 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Fri, 2012-02-10 at 22:24 +0200, Gilad Ben-Yossef wrote:
> > I think the concept of giving the task some way to know if the tick is
> > disabled or not is nice.
> > Not sure the exact feature and surely not the interface are what we
> > should adopt - maybe
> > allow registering to receive a signal at the end of the tick when it
> > is disabled an re-enabled?
>
> Fair enough, I indeed missed that property. And yes that makes sense.
>
> It might be a tad tricky to implement as things currently stand, because
> AFAICR Frederic's stuff re-enables the tick on kernel entry (syscall)
> things like signal delivery or a blocking wait for it might be 'fun'.
>
> But I'll have to defer to Frederic, its been too long since I've seen
> his patches to remember most details.

Yes, what I had in mind is that since Frederic's patch set always
disables the tick
from inside the (last) timer tick, we can have the tick return to user
code from the timer
with a signal whenever it is disabled or re-enabled. Basically, have
the timer code make
the signal pending from inside the timer, so that the return to user
space on the special
timer ticks (the last before disable or the first after re-enable)
will be to a signal handler.

I don't know if what I wrote above actually makes sense or not :-)
I'll try to hack something
up and see.

Thanks,
Gilad

--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
