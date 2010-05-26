Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763Ab0EZKCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:02:50 -0400
Received: from ist.d-labs.de ([213.239.218.44]:37351 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab0EZKCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:02:49 -0400
Date: Wed, 26 May 2010 12:02:42 +0200
From: Florian Mickler <florian@mickler.org>
To: Peter Zijlstra <peterz@infradead.org>
Newsgroups: gmane.linux.ports.arm.omap,gmane.linux.kernel
Cc: Arve =?ISO-8859-15?B?SGr4bm5lduVn?= <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>, felipe.balbi@nokia.com,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526120242.5c9b73ad@schatten.dmk.lab>
In-Reply-To: <1274867106.5882.5090.camel@twins>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<201005242049.18920.rjw@sisk.pl>
	<87wrusvrqe.fsf@deeprootsystems.com>
	<201005250138.16293.rjw@sisk.pl>
	<1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 11:45:06 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-05-26 at 02:41 -0700, Arve Hjønnevåg wrote:
> > On Wed, May 26, 2010 at 1:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Tue, 2010-05-25 at 01:38 +0200, Rafael J. Wysocki wrote:
> > >> > This of course will lead to a scattering of suspend blockers into any
> > >> > drivers/subsystems considered "useful", which by looking through current
> > >> > Android kernels is many of them.
> > >>
> > >> That depends on the maintainers of these subsystems, who still have the power
> > >> to reject requested changes.
> > >
> > > So as a scheduler maintainer I'm going to merge a patch that does a
> > > suspend_blocker when the runqueue's aren't empty... how about that?
> > >
> > 
> > I don't know if you are serious, since the all the runqueues are never
> > empty while suspending, this would disable opportunistic suspend
> > altogether.
> 
> So why again was this such a great scheme? Go fix your userspace to not
> not run when not needed.

Hi Peter!

This was already mentioned in one of these threads. 

The summary is: The device this kernel is running on dosn't want to
(or can) rely on userspace to save power. This is because it is an open
system, without an app-store or the like. Everyone can run what he
wants.

So anything relying on (all) userspace solves a different problem.

Cheers,
Flo




> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
