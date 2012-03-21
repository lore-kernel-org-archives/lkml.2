Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016Ab2CUOwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:52:32 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:36440 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750863Ab2CUOwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:52:30 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: JlV5764VM1mskzqGzZp_860CCYdCJashKc4yAPzMIeTOX8Z
 ix7YaBCkfGiiVEMeOXHlG5QVcy.lBrOqmPBPz7WSytSSAJTXdLvcbhTydFvG
 a7BTt1Zmqi0UxTJ4KsEVTPN9.McdBbqis.SqWcm8X1WIKobwleB9d7MfRY2c
 DViFH1a5r0fuWYUsA741489_Ydkby3hKCw1K33kGR.TlcgFoLBcsejYObKUk
 m5I6Dntfud10n6CAXeKLFNFuEdkWk_w.ETmXmWX7wLg8Pe.W4lOZOBj.dnsE
 tvYkaW.AwWbwusYFlxFsdFf_ma78bb0cH3Zeez9jKO9TaX9wXbtKzw6nl_Eu
 iHFrItXlN1UxmI.yX8sV92US.81AhTUlnNyqoVxgDCJEIqhm74OalOgeYkMK
 oJ3BzyczXb3CJIMoGSHhD4oMhybLxTdI9ujG0
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 21 Mar 2012 09:52:24 -0500 (CDT)
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
Subject: Re: [PATCH 08/32] nohz: Try not to give the timekeeping duty to an
 adaptive tickless cpu
In-Reply-To: <1332338318-5958-10-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.1203210950500.20482@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com> <1332338318-5958-10-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012, Frederic Weisbecker wrote:

> Try to give the timekeeing duty to a CPU that doesn't belong
> to any nohz cpuset when possible, so that we increase the chance
> for these nohz cpusets to run their CPUs out of periodic tick
> mode.

Any way to manually specify which cpu? We f.e. always "sacrifice" cpu 0
for OS activities. We would like to have all Os processing things
restricted to cpu 0 so that the rest of the processors do not experience
the OS noise.
