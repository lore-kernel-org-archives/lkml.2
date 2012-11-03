Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab2KCLcw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 07:32:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56259 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752952Ab2KCLcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 07:32:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19iAlUvP0ZiegOH8PyFAfdBrycJbXN3zklVv6SaMj
	WJKZph/FJ+tfQA
Message-ID: <1351942405.16850.23.camel@maggy.simpson.net>
Subject: Re: Fwd: Nice processes prevent frequency increases - possible
 scheduler regression (known good in 2.6.35)
From: Mike Galbraith <efault@gmx.de>
To: Michal Zatloukal <myxal.mxl@gmail.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Date: Sat, 03 Nov 2012 04:33:25 -0700
In-Reply-To: <CAKKZj2Av0TN9MbYk=-2ZB_jxDnUCWfrN5tJNZ7azgSHyOrMzvg@mail.gmail.com>
References: <CAKKZj2Do+ViFbdmeA9y4qZ4Dd_CrW_wmVWc0_CB4BAAwO6SfJg@mail.gmail.com>
	 <CAKKZj2Av0TN9MbYk=-2ZB_jxDnUCWfrN5tJNZ7azgSHyOrMzvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 21:09 +0100, Michal Zatloukal wrote:

> On the new kernel, the nice processes are never starved - even when
> starting a tab-laden chromium session, the processes for BOINC keep
> about 20% CPU each (that is normalized to all CPUs, ie 40% nice load
> on each core). The problem is, the governor now seems to consider the
> non-nice task unable to saturate the CPU, and the cores' frequencies
> are hovering between 1.0 and 1.8 GHz. The scheduler keeps scheduling
> the nice tasks, and the non-nice tasks are progressing much slower,
> caused by the lower CPU speed as well as less processing time
> allocated to them. HD video stutters often, and Chromium takes at
> least 2-3 times longer to fully load.

Your nice 19 tasks receiving 'too much' CPU when there are other
runnable tasks around sounds like you have SCHED_AUTOGROUP enabled.

With this enabled (or if tasks are placed in cgroups by another means),
group A and group B will each receive equal CPU if group shares/weight
are equal, regardless of group content.  Task nice level will affect CPU
distribution within a group, but group A containing a gaggle of nice 19
tasks will receive the same amount of CPU as group B containing your
nice 0 browser with zillion tabs.  Add nice 0 hogs to group A, the nice
19 tasks will receive much less CPU, but the total for group A will
remain unchanged relative to group B, unless group shares/weights are
twiddled.

(no idea what's going on with ondemand)

-Mike

