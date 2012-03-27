Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab2C0QNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:13:47 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:27621 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751365Ab2C0QNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:13:46 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ZqDzEN0VM1nGdY08XxcjviNCzS5F0YZABuq_X.Q.B1rHdCL
 a.Z.fuL.kplZ80lKGGlSOScsNZBvMs8jIAmJYIasqBUfq9OZTctw6Pu7As7O
 RjqHCtJ4TSQzHDzy_y6Um3k1pWVa2y5oY3xiaM6kA3yHqmYKznlRdQfEN5QB
 QfeLM_EHE7EiKfMqm0cZk6ixpLKlbdms43TAO2xlIJO_EjlxrEbJuDQMOAXA
 zbViHcODWnJ15YgGXTnY2tPdR8blg4S9F8K3Grj2RyXdaGl6Dh4vbIwuPgb8
 9YNgL_q9iZr8W_gwc5sNkMBGf.NjrV4zH7AHLAmwcgozr_V3gBKEGITegfH2
 QUQBTQnHOBR4zoy.W6fxo1Rfd5iQYql8Ult7YcQAjh8HVe8kyIktm9VsFnaB
 Z
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 27 Mar 2012 11:13:39 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: Re: [PATCH 11/32] nohz/cpuset: Don't turn off the tick if rcu needs
 it
In-Reply-To: <20120327121341.GE13196@somewhere>
Message-ID: <alpine.DEB.2.00.1203271111110.1170@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com> <1332338318-5958-13-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1203210953220.20482@router.home> <20120327121341.GE13196@somewhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012, Frederic Weisbecker wrote:

> > Is there any way for userspace to know that the tick is not off yet due to
> > this? It would make sense for us to have busy loop in user space that
> > waits until the OS has completed all processing if that avoids future
> > latencies for the application.
>
> What is the usecase you have in mind? Is it for realtime purpose?

Please do not use "realtime" since I am not sure what you mean by that.
Its for a low latency applications that cannot use "realtime" because that
implies high latencies.

> The "tick stopped" is a volatile and relative state.

The use case is an application that cannot tolerate the latencies
introduced by timer tick processing. It will only start running when the
system is in a sufficiently quiet state.

> Relative because if a timer list is enqueued to fire 1 second later,
> the tick will be stopped until that happens. How do we consider this (common)
> case?
>
> Also as Chris noted it is volatile because the tick can be restarted anytime
> for random reasons: the CPU receives an IPI which makes it restart the
> periodic tick.

Ok some sort of notification would be good for that case. If a timer tick
happens and that was unavoidable then it would be good to log the reason
why this occured so that the system can be configured in such a way that
these interruptions are minimized.

