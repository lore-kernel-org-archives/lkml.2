Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab0ERSv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:51:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42996 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757599Ab0ERSvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:51:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
Date: Tue, 18 May 2010 20:52:28 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@fifo99.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Matthew Garrett <mjg@redhat.com>
References: <1273810273-3039-1-git-send-email-arve@android.com> <AANLkTilQ5wZ_7fMyDMpUBCtu9oD1Wh22JGllyS1EPlxB@mail.gmail.com> <87tyq5qj3v.fsf@deeprootsystems.com>
In-Reply-To: <87tyq5qj3v.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005182052.28778.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 May 2010, Kevin Hilman wrote:
> Arve Hjønnevåg <arve@android.com> writes:
> 
> >
> > PM: Opportunistic suspend support.
> >
> > Power management features present in the current mainline kernel are
> > insufficient to get maximum possible energy savings on some platforms,
> > such as Android, because low power states can only safely be entered
> > from idle.  Suspend, in its current form, cannot be used, since wakeup
> > events that occur right after initiating suspend will not be processed
> > until another possibly unrelated event wake up the system again.
> 
> I think the problems with wakeups in the current suspend path need to
> be described in more detail.  In particular, why check_wakeup_irqs()
> is not enough etc.

That one is really easy.: because some (the majority of?) architectures
don't even implement it.
 
> > On some systems idle combined with runtime PM can enter the same power
> > state as suspend, but periodic wakeups increase the average power
> > consumption. Suspending the system also reduces the harm caused by
> > apps that never go idle. On other systems suspend can enter a much
> > lower power state than idle.
> >
> > To allow Android and similar platforms to save more energy than they
> > currently can save using the mainline kernel, we introduce a mechanism
> > by which the system is automatically suspended (i.e. put into a
> > system-wide sleep state) whenever it's not doing useful work, called
> > opportunistic suspend.
> 
> A definition of "useful work" here would provide clarity and would
> also help clarify by what criteria other on-going work is determined
> to be not useful.

Probably "useful" is not the right word here.  I guess it's more like
"work that can be deferred without visible impact on functionality".

Rafael
