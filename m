Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab0HPPRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:17:32 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:37348 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751109Ab0HPPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:17:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MvuJtl58UYP/+9hcm/wLxYrcYL+fn+XzUy2wEre2bAfXPMc+OaApgl6QoyX4sjlevhQKv986ffeSmbaiUY13Ej9FuHxT3MTwL1Qhsb3YddP439iSoFN++1s+kNsQtNzJ;
Date: Mon, 16 Aug 2010 08:16:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Ted Ts'o" <tytso@mit.edu>, Felipe Contreras <felipe.contreras@gmail.com>,
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
Message-ID: <20100816081655.3e9e29f7@virtuousgeek.org>
In-Reply-To: <20100814075000.GB27430@elf.ucw.cz>
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
	<AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
	<20100812125248.GA2763@thunk.org>
	<20100814075000.GB27430@elf.ucw.cz>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Aug 2010 09:50:00 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> On Thu 2010-08-12 08:52:49, Ted Ts'o wrote:
> > On Thu, Aug 12, 2010 at 03:28:01PM +0300, Felipe Contreras wrote:
> > > 
> > > The question is why are we adding a user-space API that:
> > >  1) no user-space beside Android has expresses interest in implementing
> > >  2) is dubious whether the benefits are worth the pain for non-Android
> > > user-space
> > >  3) will become less and less attractive as dynamic PM gets closer to
> > > the sweet-spot, and then surpass it
> > >  4) Android can keep in a separate tree until it's clear in the linux
> > > community that it's useful (if it ever happens)
> > 
> > So, Felipe,
> > 
> > Do you believe you speak for all of LKML?
> > 
> > Are you willing to tell ZDNet and the Slashdot fanboys that it's OK
> > for Suspend blockers to live in a separate tree, and it's not a case
> > of OMG!  Google is forking the kernel?
> > 
> > If you could speak out a passionately on those forums as you have
> > here, that would be great.
> 
> Ted, what is going on here? Are you suggesting people disagreeing with
> Google patches suddenly have to do advocacy for Google?
> 
> And yes, for the record Felipe speaks for me pretty well.
> 
> Normal path of merging stuff to the kernel is
> 
> "Google develops it, then modifies it to address the review comments,
> then it is merged, then it is deployed".

Pavel, you should know better than this.  You've been working on Linux
long enough to know that development doesn't happen this way.

It's far more common (and prudent, business-wise) for companies to
develop changes against upstream Linux, ship them, and then try to get
them or something like them integrated upstream.  This often works
fine, but big problems arise when either the company in question
doesn't bother to ever push upstream (Linux loses out on support for a
given feature or hardware) or ships changes that have very little
chance of getting upstream (we end up with a fork).

> Unfortunately what Google did here is:
> 
> "Google develops it behind the closed door, then deploys it. When
> asked for changes, Google expects someone else to create system
> compatible with their existing solution, or else their patches being
> merged."

Although it would have been nice for Google to work more directly with
upstream on their suspend blockers for Android, I don't think they
could have made their product development cycle a slave to the politics
of upstream development.

Fortunately in this case the problem doesn't seem to be fatal.  We've
already established that the userland API portion of suspend blockers
could be implemented in userspace with a bit more work, given that the
kernel problems with suspend/resume and events are addressed.
Hopefully Google is already developing a prototype userspace
implementation to make sure it's workable; being able to build stock
upstream kernels for my Droid and its Android userspace sure would be
nice.

-- 
Jesse Barnes, Intel Open Source Technology Center
