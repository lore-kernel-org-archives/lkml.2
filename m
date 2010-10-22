Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab0JVUck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:32:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754186Ab0JVUcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:32:39 -0400
Date: Fri, 22 Oct 2010 13:31:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Luca Barbieri <luca@luca-barbieri.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/atomic64_test: do not build on non-atomic64 systems
Message-Id: <20101022133138.6d82f79a.akpm@linux-foundation.org>
In-Reply-To: <AANLkTikGbK7=eW9L4A62Rin-E3usq4Ke_dPoCdStDyEw@mail.gmail.com>
References: <1287250035-30404-1-git-send-email-vapier@gentoo.org>
	<20101021150250.f6499506.akpm@linux-foundation.org>
	<201010211823.38287.vapier@gentoo.org>
	<20101021155528.b3d6d027.akpm@linux-foundation.org>
	<AANLkTim6AFDw_1V9rtF4e_2tmgctbKHziQa-1e3=q7og@mail.gmail.com>
	<20101021162410.5c0d6720.akpm@linux-foundation.org>
	<AANLkTikGbK7=eW9L4A62Rin-E3usq4Ke_dPoCdStDyEw@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 16:14:49 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> On Thu, Oct 21, 2010 at 19:24, Andrew Morton wrote:
> > On Thu, 21 Oct 2010 19:04:36 -0400 Mike Frysinger wrote:
> >> you can say "lazy" all you like. __i dont see the point in going that route.
> >
> > Try
> >
> > __ __ __ __grep HAVE arch/x86/Kconfig
> >
> > If all of those were instead to use some random #define which the
> > particular feature happened to define in some header file then we would
> > have a mess on our hands.
> 
> fun times.  new tact.
> 
> Luca: your new atomic64_t test build fails on all arches that lack
> atomic64_t.  please fix.

That's only part of the problem.  The following won't build also:

net/rds
kernel/perf_event.c
drivers/staging/octeon
drivers/infiniband/hw

with more to come.  These things should be made dependent upon
CONFIG_HAVE_ATOMIC64 in Kconfig.  (Can't use #ifdef ATOMIC64_INIT for this!)

Or, much better, we implement atomic64 on the offending architectures.
