Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310Ab0EZJyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 05:54:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:56313 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566Ab0EZJyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 05:54:41 -0400
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Florian Mickler <florian@mickler.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100526114053.440c0559@schatten.dmk.lab>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	 <201005240246.55043.rjw@sisk.pl> <1274863533.5882.4864.camel@twins>
	 <20100526114053.440c0559@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 11:54:37 +0200
Message-ID: <1274867677.5882.5127.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 11:40 +0200, Florian Mickler wrote:
> On Wed, 26 May 2010 10:45:33 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2010-05-24 at 02:46 +0200, Rafael J. Wysocki wrote:
> > > On Saturday 22 May 2010, Arve Hjønnevåg wrote:
> > > > This patch series adds a suspend-block api that provides the same
> > > > functionality as the android wakelock api. This version adds a
> > > > delay before suspending again if no suspend blockers were used
> > > > during the last suspend attempt.
> > > 
> > > Patches [1-6/8] applied to suspend-2.6/linux-next
> > 
> > So you're going to merge this junk?
> > 
> > 
> 
> Yes. By now, everyone reading the posts should know all points.
> Raffael obviously was part of this discussion and came to the decision
> to merge it. 
> 
> My take of the discussion:
> _IF_ you want to suspend aggressively, I don't see another
> way.
> 
> The thing is, this is a paradigm change. Suspend is not anymore
> controlled by userspace. In order to let userspace control/work with
> this scheme, it needs to know when a suspend will be successfull or
> poll:
> 
> 1. kernel sees suspend may be possible on his side of things
> 
> 2. kernel sends a message to userspace that i could be possibly
> possible to suspend, but it may well be that by the time
> userspace suspends it is not possible anymore
> 
> 3. userspace decides to suspend. 
> 
> <- system suspends...  or not ..-> 
> 
> 4. userspace retries ... retries ... retries ... 
> 
> And then you have the whole can of worms and races.

I don't see any races, nor retry loops.

There is always the race of an event arriving whilst in the process of
suspending, that is not solved by either the kernel nor user part of
suspend-blockers. The only thing is not to loose the event.

You simply have to deal with that, the suspend gets canceled, you do
deal with the event, and suspend again. How does making that 'retry' as
you call it happen from a kernel thread or from a userspace thread any
difference?


