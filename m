Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934444Ab0EZLfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:35:21 -0400
Received: from ist.d-labs.de ([213.239.218.44]:48026 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934418Ab0EZLfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:35:20 -0400
Date: Wed, 26 May 2010 13:35:14 +0200
From: Florian Mickler <florian@mickler.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arve =?ISO-8859-15?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526133514.3d018520@schatten.dmk.lab>
In-Reply-To: <1274867677.5882.5127.camel@twins>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<201005240246.55043.rjw@sisk.pl>
	<1274863533.5882.4864.camel@twins>
	<20100526114053.440c0559@schatten.dmk.lab>
	<1274867677.5882.5127.camel@twins>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 11:54:37 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-05-26 at 11:40 +0200, Florian Mickler wrote:
> > _IF_ you want to suspend aggressively, I don't see another
> > way.
> > 
> > The thing is, this is a paradigm change. Suspend is not anymore
> > controlled by userspace. In order to let userspace control/work with
> > this scheme, it needs to know when a suspend will be successfull or
> > poll:
> > 
> > 1. kernel sees suspend may be possible on his side of things
> > 
> > 2. kernel sends a message to userspace that i could be possibly
> > possible to suspend, but it may well be that by the time
> > userspace suspends it is not possible anymore
> > 
> > 3. userspace decides to suspend. 
> > 
> > <- system suspends...  or not ..-> 
> > 
> > 4. userspace retries ... retries ... retries ... 
> > 
> > And then you have the whole can of worms and races.
> 
> I don't see any races, nor retry loops. 

What about the worms?  :)

I referred to retrying steps 1 through 3 as being the loop. 

> 
> There is always the race of an event arriving whilst in the process of
> suspending, that is not solved by either the kernel nor user part of
> suspend-blockers. The only thing is not to loose the event.
> 
> You simply have to deal with that, the suspend gets canceled, you do
> deal with the event, and suspend again. How does making that 'retry' as
> you call it happen from a kernel thread or from a userspace thread any
> difference?
> 
You have a point there. But what follows?

You either need to let userspace know that the kernel is now able to
suspend or you let the kernel know that userspace is now able to
suspend.
Else you can not make a well informed suspend-decision and have to
guess and retry.

Why not look at blocking and unblocking as these events you want
to have? Without wiggle room and retrying.

And not having to route through userspace simplifies the auto-suspend
scheme further.

Cheers,
Flo
