Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab1EMIF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 04:05:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:38939 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757804Ab1EMIFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 04:05:55 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/x8vBKv4nxnknkJj/vBBTMkAjJKypdApBN12D8dr
	I2hSyy1Kw4RMBs
Subject: Re: Sched_autogroup and niced processes
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Carl-Johan Kjellander <carl-johan@klarna.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTi=ckPK3BV07n=hmwOeqFUs3mrazFQ@mail.gmail.com>
References: <BANLkTimCpH3Nn2XnOJUKnK=dMObj1r8KEg@mail.gmail.com>
	 <BANLkTi=ckPK3BV07n=hmwOeqFUs3mrazFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 10:05:50 +0200
Message-ID: <1305273950.15080.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 15:53 +0800, Yong Zhang wrote:
> Cc'ing more people.
> 
> On Fri, May 13, 2011 at 3:39 PM, Carl-Johan Kjellander
> <carl-johan@klarna.com> wrote:
> > I've been running seti@home niced to 19 in the background since 1999
> > without any problems. No noticeable effect even when playing a movie
> > or a game. But since 2.6.38 the new fix-all-problems automatic
> > grouping has been messing a bit with me. These are some timed compiles
> > on my 8 cores.

Heh, it's not a fix-all-problems thingy, and was never intended to be.
It's also not enabled by default.

> > time make -j12 # with seti@home running
> > real    4m16.753s
> > user    10m33.770s
> > sys     1m39.710s
> >
> > time make -j12 # without seti@home running
> > real    2m12.480s
> > user    10m11.580s
> > sys     1m39.980s
> >
> > echo 0 > /proc/sys/kernel/sched_autogroup_enabled
> > time make -j12 # no autogroup, seti@home running again
> > real    2m33.276s
> > user    10m37.540s
> > sys     1m43.190s
> >
> > All compiles already had all files cached in RAM.
> >
> > Now I can take the 10% performance hit, but not the 100% hit of
> > running stuff super niced in the background. Processes niced to 19
> > should only use spare cycles and not take up half of the cores even
> > with autogroup. I would really like to run autogroup since it is a
> > neat idea, but it can't mess up running niced processes in the
> > background which have been working fine for 12 years.
> 
> Then how about change the nice value of seti@home->autogroup?
> echo 19 > /proc/'pid of seti@home'/autogroup

Yup.  Overhead and whatnot is the dark side of group scheduling.  The
thing to do is to turn group scheduling off if you don't like what it
does for/to you.

	-Mike

