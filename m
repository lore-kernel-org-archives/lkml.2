Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab1AVDWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 22:22:38 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:40167 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754652Ab1AVDWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 22:22:37 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18y3wRZ1kMyZ7cVuwnAslNbRSVC3fTUSY1mzkX4DL
	fqVyQMZNcQc8e6
Subject: Re: 'autogroup' sched code KILLING responsiveness
From: Mike Galbraith <efault@gmx.de>
To: Michael Witten <mfwitten@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTini15poUNM54UrM5KmGAoyJOznReYAFCkoxKEyN@mail.gmail.com>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com>
	 <1295648870.23779.15.camel@marge.simson.net>
	 <AANLkTini15poUNM54UrM5KmGAoyJOznReYAFCkoxKEyN@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Jan 2011 04:22:34 +0100
Message-ID: <1295666554.8265.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 16:39 -0600, Michael Witten wrote:
> On Fri, Jan 21, 2011 at 16:27, Mike Galbraith <efault@gmx.de> wrote:
> > On Fri, 2011-01-21 at 10:20 -0800, Michael Witten wrote:
> >> Bisecting shows that this commit:
> >>
> >>   5091faa449ee0b7d73bc296a93bca9540fc51d0a
> >>   sched: Add 'autogroup' scheduling feature: automated per session task groups
> >>   Date:   Tue Nov 30 14:18:03 2010 +0100
> >>
> >> is the reason that my computer has become unusable.
> >>
> >> With that code in place, a resource-intensive activity (such as
> >> compiling the Linux kernel) causes my computer to become
> >> unresponsive for many seconds at a time; the entire screen
> >> does not refresh, typed keys are dropped or are handled very
> >> late, etc (even in Linux's plain virtual consoles).
> >
> > That's not what I'm experiencing with a UP kernel...
> 
> Before I try to gather any data, I'd like to point out that the
> problem disappears when I disable CONFIG_SCHED_AUTOGROUP (General
> setup -> Automatic process group scheduling).
> 
> Do you have it disabled?

No, ff I did, mplayer wouldn't be able to get more than 1% cpu.

top - 22:34:38 up 33 min, 22 users,  load average: 104.07, 101.73, 78.13
Tasks: 675 total, 101 running, 574 sleeping,   0 stopped,   0 zombie
Cpu(s): 95.2%us,  4.8%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND                                                              
 6770 root      20   0  401m  79m  29m R 46.9  1.0   3:22.66 0 mplayer                                                              
 6100 root      20   0  449m  94m  18m S  2.9  1.2   1:33.82 0 Xorg                                                                 
 7486 root      20   0  374m  46m  17m S  2.9  0.6   0:54.02 0 konsole

	-Mike


