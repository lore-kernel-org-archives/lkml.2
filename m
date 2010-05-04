Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651Ab0EDUBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:01:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42889 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933575Ab0EDUBu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:01:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend blockers from user-space
Date: Tue, 4 May 2010 22:02:40 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Avi Kivity <avi@redhat.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
References: <Pine.LNX.4.44L0.1005021755320.30701-100000@netrider.rowland.org> <201005032349.00876.rjw@sisk.pl> <x2id6200be21005031501p7f151324wb8bbf928bc2cb25e@mail.gmail.com>
In-Reply-To: <x2id6200be21005031501p7f151324wb8bbf928bc2cb25e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005042202.40197.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 May 2010, Arve Hjønnevåg wrote:
> 2010/5/3 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Monday 03 May 2010, Arve Hjønnevåg wrote:
> >> On Mon, May 3, 2010 at 8:03 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Sunday 02 May 2010, Alan Stern wrote:
> >> >> On Sun, 2 May 2010, Rafael J. Wysocki wrote:
> >> >>
> >> >> > Hmm.  It doesn't seem to be possible to create two different suspend blockers
> >> >> > using the same file handle.  So, what exactly is a process supposed to do to
> >> >> > use two suspend blockers at the same time?
> >> >>
> >> >> Open the file twice, thereby obtaining two file handles.
> >> >
> >> > Well, that's what I thought.
> >> >
> >> > I must admit I'm not really comfortable with this interface.  IMO it would
> >> > be better if _open() created the suspend blocker giving it a name based on
> >> > the name of the process that called it.  Something like
> >> > "<process name>_<timestamp>" might work at first sight.
> >> >
> >> > Alternatively, "<process_name><number>", where <number> is 0 for the first
> >> > suspend blocker created by the given process, 1 for the second one etc., also
> >> > seems to be doable.
> >>
> >> I think it is important to let user-space specify the name. If a
> >> process uses multiple suspend blockers, it is impossible to tell what
> >> each one is used for if they are automatically named.
> >
> > Well, the problem is the only purpose of this is user space debugging, isn't it?
> >
> At the moment, yes.

OK

> But having an explicit init call also simplifies future expansion.

That's irrelevant.  Let's focus _only_ on the "at the moment" part, please.

And BTW, a "future expansion" is not relevant at all to the patchset at hand
and let's work with this assumption from now on.  OK?

> If we ever need to add back multiple types of
> suspend blockers, we can add an init call with a type argument and
> have the current init call use the default type. If the past we have
> had types that keeps the screen on and prevented idle sleep modes. In
> the future we could for instance want to specify if a suspend blocker
> should prevent suspend when the battery is low or when the lid is
> closed.

_If_ we ever do anything like thie, _then_ we will extend the interface.

> > Now, while I don't think it's generally bad to provide kernel interfaces
> > helping to debug user space, I'm not quite sure if that should be done at the
> > expense of the clarity of kernel-user space interfaces.
> >
> > I wonder how many cases there are in which distinguishing between suspend
> > blockers used by the same user space task is practically relevant.
> >
> 
> I think all of them (when more than one suspend blocker is used).

So how many user space processes use more than one suspend blocker right
now on Android?  I'm interested only in the order of magnitude.

Rafael
