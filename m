Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2KCLsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 07:48:18 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45665 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750875Ab2KCLsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 07:48:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+wNbAAqpmwwby+t725P+Wd2j2UAPNwG8C4Rzj4wj
	JvtURKLFDP2Fq6
Message-ID: <1351943332.16850.25.camel@maggy.simpson.net>
Subject: Re: Fwd: Nice processes prevent frequency increases - possible
 scheduler regression (known good in 2.6.35)
From: Mike Galbraith <efault@gmx.de>
To: Michal Zatloukal <myxal.mxl@gmail.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Date: Sat, 03 Nov 2012 04:48:52 -0700
In-Reply-To: <1351942405.16850.23.camel@maggy.simpson.net>
References: <CAKKZj2Do+ViFbdmeA9y4qZ4Dd_CrW_wmVWc0_CB4BAAwO6SfJg@mail.gmail.com>
	 <CAKKZj2Av0TN9MbYk=-2ZB_jxDnUCWfrN5tJNZ7azgSHyOrMzvg@mail.gmail.com>
	 <1351942405.16850.23.camel@maggy.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-03 at 04:33 -0700, Mike Galbraith wrote: 
> On Fri, 2012-11-02 at 21:09 +0100, Michal Zatloukal wrote:
> 
> > On the new kernel, the nice processes are never starved - even when
> > starting a tab-laden chromium session, the processes for BOINC keep
> > about 20% CPU each (that is normalized to all CPUs, ie 40% nice load
> > on each core). The problem is, the governor now seems to consider the
> > non-nice task unable to saturate the CPU, and the cores' frequencies
> > are hovering between 1.0 and 1.8 GHz. The scheduler keeps scheduling
> > the nice tasks, and the non-nice tasks are progressing much slower,
> > caused by the lower CPU speed as well as less processing time
> > allocated to them. HD video stutters often, and Chromium takes at
> > least 2-3 times longer to fully load.
> 
> Your nice 19 tasks receiving 'too much' CPU when there are other
> runnable tasks around sounds like you have SCHED_AUTOGROUP enabled.

(forgot to mention: if that's the case, you can add noautogroup to your
kernel command line to turn it off if distro turned it on in .config)

