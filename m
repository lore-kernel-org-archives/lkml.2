Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0KNUtI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 15:49:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751912Ab0KNUtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 15:49:06 -0500
MIME-Version: 1.0
In-Reply-To: <20101114202734.GA1627@arch.trippelsdorf.de>
References: <1289489200.11397.21.camel@maggy.simson.net> <20101111202703.GA16282@redhat.com>
 <1289514000.21413.204.camel@maggy.simson.net> <20101112181240.GB8659@redhat.com>
 <1289648524.22764.149.camel@maggy.simson.net> <1289755150.3228.44.camel@maggy.simson.net>
 <20101114174921.GA1569@arch.trippelsdorf.de> <1289758238.17491.12.camel@maggy.simson.net>
 <AANLkTimy5DdF8qwGuk09iT3wHfXMjkiwRKxo-LuvEJzW@mail.gmail.com>
 <AANLkTikjSCbcRnKOU=nd4os1sdW-GJkD6QVj=U5zPyu8@mail.gmail.com> <20101114202734.GA1627@arch.trippelsdorf.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 14 Nov 2010 12:48:18 -0800
Message-ID: <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 12:27 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2010.11.14 at 12:20 -0800, Linus Torvalds wrote:
>>
>> It isn't like it's some traditional kernel debug feature that makes
>> things slower or adds tons of debug output.
>
> It also enables the sched_autogroup_handler, that you disliked seeing in
> the previous version.

Yes, but that one exists only to make things "exact". I don't really
see why it exists. What's the point of doing the task movement, if the
group information is just going to be ignored anyway?

IOW, my dislike of the sched_autogroup_handler is not about the debug
option per se, it's about the same thing I said about tty hangups etc:
why do we care so deeply?

I think it would be perfectly acceptably to make the "enable" bit just
decide whether or not to take that autogroup information into account
for scheduling decision. Why do we care so deeply about having to move
the groups around right _then_?

Maybe there is some really deep reason for actually having to do the
reclassification and the sched_move_task() thing for each thread
synchronously when disabling/enabling that thing. If so, I'm just not
seeing it.  Why can't we just let things be, and next time things get
scheduled they'll move on their own?

So my objection was really about the same "why do we have to try so
hard to keep the autogroups so 1:1 with the tty's"? It's just a
heuristic, trying to be exact about it seems to miss the point.

                            Linus
