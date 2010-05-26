Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930Ab0EZJk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 05:40:59 -0400
Received: from ist.d-labs.de ([213.239.218.44]:51097 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab0EZJk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 05:40:58 -0400
Date: Wed, 26 May 2010 11:40:53 +0200
From: Florian Mickler <florian@mickler.org>
To: Peter Zijlstra <peterz@infradead.org>
Newsgroups: gmane.linux.kernel
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arve =?ISO-8859-15?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526114053.440c0559@schatten.dmk.lab>
In-Reply-To: <1274863533.5882.4864.camel@twins>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<201005240246.55043.rjw@sisk.pl>
	<1274863533.5882.4864.camel@twins>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 10:45:33 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2010-05-24 at 02:46 +0200, Rafael J. Wysocki wrote:
> > On Saturday 22 May 2010, Arve Hjønnevåg wrote:
> > > This patch series adds a suspend-block api that provides the same
> > > functionality as the android wakelock api. This version adds a
> > > delay before suspending again if no suspend blockers were used
> > > during the last suspend attempt.
> > 
> > Patches [1-6/8] applied to suspend-2.6/linux-next
> 
> So you're going to merge this junk?
> 
> 

Yes. By now, everyone reading the posts should know all points.
Raffael obviously was part of this discussion and came to the decision
to merge it. 

My take of the discussion:
_IF_ you want to suspend aggressively, I don't see another
way.

The thing is, this is a paradigm change. Suspend is not anymore
controlled by userspace. In order to let userspace control/work with
this scheme, it needs to know when a suspend will be successfull or
poll:

1. kernel sees suspend may be possible on his side of things

2. kernel sends a message to userspace that i could be possibly
possible to suspend, but it may well be that by the time
userspace suspends it is not possible anymore

3. userspace decides to suspend. 

<- system suspends...  or not ..-> 

4. userspace retries ... retries ... retries ... 

And then you have the whole can of worms and races.



Or you have the suspend-blocker scheme:

1. kernel sees suspend is possible.
2. kernel suspends.
3. bingo.

Cheers,
Flo
