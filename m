Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab1BAGj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 01:39:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828Ab1BAGj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 01:39:27 -0500
Date: Mon, 31 Jan 2011 22:38:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Paul Walmsley <paul@pwsan.com>,
        Hari Kanigeri <hari.kanigeri@gmail.com>,
        Simon Que <simonque@gmail.com>, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH v4 1/4] drivers: hwspinlock: add framework
Message-Id: <20110131223859.27169db0.akpm@linux-foundation.org>
In-Reply-To: <AANLkTik-fgCF_W0-DBE6UVTpjqF6Jf=u7bQYkcweEegQ@mail.gmail.com>
References: <1296470024-26854-1-git-send-email-ohad@wizery.com>
	<1296470024-26854-2-git-send-email-ohad@wizery.com>
	<20110131153831.dca62146.akpm@linux-foundation.org>
	<AANLkTik-fgCF_W0-DBE6UVTpjqF6Jf=u7bQYkcweEegQ@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 08:20:13 +0200 Ohad Ben-Cohen <ohad@wizery.com> wrote:

> On Tue, Feb 1, 2011 at 1:38 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > It's a little irritating having two hwspinlock.h's.
> > hwspinlock_internal.h wold be a conventional approach. __But it's not a
> > big deal.
> ...
> 
> >> +/**
> >> + * __hwspin_lock_timeout() - lock an hwspinlock with timeout limit
> >> + * @hwlock: the hwspinlock to be locked
> >> + * @timeout: timeout value in jiffies
> >
> > hm, why in jiffies?
> >
> > The problem here is that lazy programmers will use
> >
> > __ __ __ __hwspin_lock_timeout(lock, 10, ...)
> >
> > and their code will work happily with HZ=100 but will explode with HZ=1000.
> >
> > IOW, this interface *requires* that all callers perform a
> > seconds-to-jiffies conversion before calling hwspin_lock_timeout(). __So
> > why not reduce their effort and their ability to make mistakes by
> > defining the API to take seconds?
> 
> I considered that, but then decided to use jiffies in order to be
> consistent with wait_event_timeout/schedule_timeout (although I don't
> return the remaining jiffies in case the lock is taken before the
> timeout elapses), and also to allow user-selected granularity.
> 
> But I do kind of like the idea of not using jiffies. We can probably
> even move to msecs, since anyway this is an error condition, and
> people who needs a quick check should just use the trylock() version.
> 
> I'll do a quick respin of the patches with that and the
> hwspinlock_internal.h comment above.

OK..

The patch series looks OK to me.  But there isn't a lot of point in me
putting them into my tree.  Maybe Tony or Russell or Greg can grab them
if they like the look of it all?

