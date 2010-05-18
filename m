Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab0ERQZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:25:03 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48621 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab0ERQZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:25:00 -0400
To: Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@fifo99.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
References: <1273810273-3039-1-git-send-email-arve@android.com>
	<201005142308.48386.rjw@sisk.pl>
	<AANLkTilX0uhqrJtUSOC4smdH1M8V-h14J7YtRG4PPxOQ@mail.gmail.com>
	<201005172342.52660.rjw@sisk.pl>
	<AANLkTilQ5wZ_7fMyDMpUBCtu9oD1Wh22JGllyS1EPlxB@mail.gmail.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 18 May 2010 09:18:12 -0700
In-Reply-To: <AANLkTilQ5wZ_7fMyDMpUBCtu9oD1Wh22JGllyS1EPlxB@mail.gmail.com>
 ("Arve =?iso-8859-1?Q?Hj=F8nnev=E5g=22's?= message of "Mon\, 17 May 2010
 17\:52\:46 -0700")
Message-ID: <87tyq5qj3v.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arve Hjønnevåg <arve@android.com> writes:

>
> PM: Opportunistic suspend support.
>
> Power management features present in the current mainline kernel are
> insufficient to get maximum possible energy savings on some platforms,
> such as Android, because low power states can only safely be entered
> from idle.  Suspend, in its current form, cannot be used, since wakeup
> events that occur right after initiating suspend will not be processed
> until another possibly unrelated event wake up the system again.

I think the problems with wakeups in the current suspend path need to
be described in more detail.  In particular, why check_wakeup_irqs()
is not enough etc.

> On some systems idle combined with runtime PM can enter the same power
> state as suspend, but periodic wakeups increase the average power
> consumption. Suspending the system also reduces the harm caused by
> apps that never go idle. On other systems suspend can enter a much
> lower power state than idle.
>
> To allow Android and similar platforms to save more energy than they
> currently can save using the mainline kernel, we introduce a mechanism
> by which the system is automatically suspended (i.e. put into a
> system-wide sleep state) whenever it's not doing useful work, called
> opportunistic suspend.

A definition of "useful work" here would provide clarity and would
also help clarify by what criteria other on-going work is determined
to be not useful.

Kevin
