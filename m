Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1JQH3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 03:29:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:53269 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab1JQH3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 03:29:24 -0400
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
From: Peter Zijlstra <peterz@infradead.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, harald@redhat.com, david@fubar.dk,
        greg@kroah.com, Matthew Garrett <mjg@redhat.com>
Date: Mon, 17 Oct 2011 09:28:49 +0200
In-Reply-To: <20111017013921.GA30035@tango.0pointer.de>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
	 <1318349729-3108-4-git-send-email-kirill@shutemov.name>
	 <20111014154348.ae6267aa.akpm@linux-foundation.org>
	 <20111015112006.GA10173@tango.0pointer.de> <1318705910.2664.5.camel@laptop>
	 <20111017013921.GA30035@tango.0pointer.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318836529.6594.20.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 03:39 +0200, Lennart Poettering wrote:

> Well, maybe that works in fantasy land. In real life however there's
> stuff like closed source crap, and all kinds of other things you cannot
> fix. In a world where everybody wants "apps" (i.e. 3rd party code
> running with limited privileges) your chance to fix every bit of code is
> gone.

I don't care for closed source crap, and I'm the proof your stmt is
false since I don't want no fucking apps. That's the same kind of
'everybody' that makes GNOME the utter head-up-arse crap it is.

> Despite that: even if all software was open source, and even if we had
> the manpower to fix every single project: do you honestly believe it is
> such a good idea to build the idle state tracking into each program so
> that it can change the timer slack from the inside, if this could be
> done in a much much simpler way from the outside?

That would be doing it wrong. You want your runtime enforcing this
stuff. Simply let X kill whomever issues a drawing request for a
nonvisible surface.

Also, no apps shouldn't change their timer slack, if you think that you
really just don't get it, go away! They shouldn't be using those timers
to begin with. Increasing the slack is a bandaid trying to sort of
compensate for wrong timer usage.

There's absolutely no point in firefox trying to animate a GIF in a
non-visible tab (all are non-visible when the screen if off). Yet it
does. Go and fix that.

As to the proprietary plugins, let firefox spawn one per tab and simply
SIGSTOP the thing when the tab becomes invisible or so, dunno.

> So yeah, because there'll always be closed source userspace, and because
> I believe hacking userspace software should be easy and accessible to
> everybody, and because we also should make it difficult to fuck up
> runtime behaviour of the machine (such as power usage) I believe
> enforcing logic the way we can do it with timerslack cgroups is a good
> thing, not a bad thing.

I'm of the absolute opposite camp, make the runtime unforgiving of
fuckups, like we are for memory protection violations. Apps that crash a
lot aren't popular like you can see in various app markets.

So improve the runtime to detect power unfriendly behaviour and simply
kill.

> > Also, the downside of your approach is that you treat all applications
> > the same, what if there is a genuine need for reasonable timer response
> > and your 'policy' wrecks things?
> 
> Well, if some thread needs reasonable timer response, then they probably
> should be enabling RT anyway and IIRC the patch excludes RT threads when
> it mucks with the timer slack. But I guess Kirill can comment on this
> much better than I could.

That's nonsense, you shouldn't need RT privs in order to get a timer to
fire more than once every few seconds just because the screen if off.
