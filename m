Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab2CUOyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:54:47 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:32721 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753728Ab2CUOyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:54:45 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: UVy6xMwVM1nh3yQiPv1K7yq4No3d5tVA4ACDDWb9fFq7kff
 SKedNw27GmYGa42ynPvpnhNcgm_oUQXyqBYbAUWJC4BilIVA9pmJmIh2L0nK
 WGwDZC1yPttakpVrNKEe3yVDDAsj5WO6K3eskXPkX0wos9NXa.OapAZZ3CVp
 V88XGG0mMWVW5lXNWpiJjkn0u4ZlUqufqSMPAku4JpdUKxZ29dJ.FixPu_Az
 t5UO_FJIXjs4_pDlou2XYf7UKkxpopWlXVq.ywIqXrtpwS_FtOI0C7N.XqSZ
 dO263ROkLWUuAmERCj6bosbExI7h6PVarfcYz3vqOLga2Zb9vGz8_7BHVBJz
 o79xr_Sn0gi44qufhDkjKD_2FJoMxGA5oT47fEv278lDjNy.Dpz4owfVtLZq
 c
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 21 Mar 2012 09:54:39 -0500 (CDT)
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
In-Reply-To: <1332338318-5958-13-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.1203210953220.20482@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com> <1332338318-5958-13-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012, Frederic Weisbecker wrote:

> If RCU is waiting for the current CPU to complete a grace
> period, don't turn off the tick. Unlike dynctik-idle, we
> are not necessarily going to enter into rcu extended quiescent
> state, so we may need to keep the tick to note current CPU's
> quiescent states.

Is there any way for userspace to know that the tick is not off yet due to
this? It would make sense for us to have busy loop in user space that
waits until the OS has completed all processing if that avoids future
latencies for the application.

