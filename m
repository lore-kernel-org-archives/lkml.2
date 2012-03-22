Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031036Ab2CVRB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:01:28 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:43462 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751023Ab2CVRB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:01:26 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: q3jnHGcVM1kM2OuMRpdUB2LSM2w7DDpV4faLIlVLaAcd3xR
 m43E00Z6ricU2el4wtmURcNN_rlkEsChsPxx8HK0a_0PXq2a6jDBlm3vFCsv
 NWyIsPk7rSAMFOG8sgBSL_TkSZt5I0VxIh3EoFOFINvEcsVWeSO9TAgPllCt
 OIlvjmYAvHvpG4oaCLNTJUiXt0.sfIsz5yEuCHELcWgyHaDjZFLpwiIPr1o1
 WBb91Cf0KkIZGT7coiATGr40gevYmP0fljLA1kNdWPo9z.BiaAqtS6BIyK2_
 48ICPsaV9FzQR_A68yRuGhycfhw3oFK0QSwC6foBdjnOK6OCdDkozTTFaC5A
 neB.dL6k0evWXUFicdO98Zlu16pavdtE5SjsBkYOlw1ExMTbuOWx9_efCcsU
 x
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 22 Mar 2012 11:18:42 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: Re: [PATCH 11/32] nohz/cpuset: Don't turn off the tick if rcu needs
 it
In-Reply-To: <CAOtvUMdkU92t0nj9OXsnzCenuOyjb12x6s11xR_GGJu1aJJ7GA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1203221117100.25011@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com> <1332338318-5958-13-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1203210953220.20482@router.home> <CAOtvUMdkU92t0nj9OXsnzCenuOyjb12x6s11xR_GGJu1aJJ7GA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012, Gilad Ben-Yossef wrote:

> > Is there any way for userspace to know that the tick is not off yet due to
> > this? It would make sense for us to have busy loop in user space that
> > waits until the OS has completed all processing if that avoids future
> > latencies for the application.
> >
>
> I previously suggested having the user register to receive a signal
> when the tick
> is turned off. Since the tick is always turned off the user task is
> the current task
> by design, *I think* you can simply mark the signal pending when you
> turn the tick off.

Ok that sounds good. You would define a new signal for this?

So we would startup the application. App will do all prep work (memory
allocation, device setup etc etc) and then wait for the signal to be
received. After that it would enter the low latency processing phase.

Could we also get a signal if something disrupts the peace and switches
the timer interrupt on again?

