Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab0HQAzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 20:55:46 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:44748 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753753Ab0HQAzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 20:55:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qmta49UprUZ17eA16haa3LPqu1TcHXoBaYrlCzRq59o+qkpPMGx4fTq8LuFALqdCry7VVCTFsIvqa8szNNwzH2zg5pTkjuTa0ClueVdWsizTQV0N6qHBi5CxVJ4SAa5N;
Date: Mon, 16 Aug 2010 17:55:03 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Pavel Machek <pavel@ucw.cz>, Felipe Contreras <felipe.contreras@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, florian@mickler.org,
        rjw@sisk.pl, peterz@infradead.org, tglx@linutronix.de,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100816175503.1f9b72bc@virtuousgeek.org>
In-Reply-To: <20100817002032.GD21182@thunk.org>
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
	<AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
	<20100812125248.GA2763@thunk.org>
	<20100814075000.GB27430@elf.ucw.cz>
	<20100816081655.3e9e29f7@virtuousgeek.org>
	<20100817002032.GD21182@thunk.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Aug 2010 20:20:32 -0400
Ted Ts'o <tytso@mit.edu> wrote:

> On Mon, Aug 16, 2010 at 08:16:55AM -0700, Jesse Barnes wrote:
> > Fortunately in this case the problem doesn't seem to be fatal.  We've
> > already established that the userland API portion of suspend blockers
> > could be implemented in userspace with a bit more work, given that the
> > kernel problems with suspend/resume and events are addressed.
> > Hopefully Google is already developing a prototype userspace
> > implementation to make sure it's workable; being able to build stock
> > upstream kernels for my Droid and its Android userspace sure would be
> > nice.
> 
> You know, you don't have to wait for the Android engineers to do this
> work.  You (or others who want to be able to use stock upstream kernel
> with Android devices) could just as easily try to do the "bit more
> work" yourselves --- that is, do the open souce thing and scratch
> one's own itch.

Sure, I could.  And the Google guys could put together a whole Debian
distro with suspend blockers sprinkled throughout various apps.  But
for my part, I can't justify that kind of work at the moment.  Of
course I'd be happy if someone could and did do the work, it would be a
useful exercise and potentially allow Android to work well on stock
kernels.

> After all, Rafael is saying he's refusing to accept patches (or
> implement) in-kernel oppunsitic suspend for upstream unless it's
> proven to him that a userspace implementation isn't sufficient.  It
> might be just as fair for the Android userspace upstream to refuse to
> accept (or engineer) userspace changes unless it is proven that the
> userspace version of opporunistic suspend is just as good as the
> in-kernel version which is successfully been deployed in millions and
> millions of shipping units today...
> 
> Speaking personally, it's not clear to me how waking up a userspace
> suspend daemon and waiting for it to get scheduled will result in
> better power savings than simply handling it in the kernel, but as
> soon as someone is willing to do the work, we can find out for sure
> who is right.

Yeah it would add some overhead, since suspend blocker calls would use
IPC to a userspace daemon, which would also be responsible for
(periodically?) waking up to see if the system ought to be
suspended...  I agree coding it up would be a useful exercise.

-- 
Jesse Barnes, Intel Open Source Technology Center
