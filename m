Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab2EGQCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:02:34 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:34527 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756571Ab2EGQCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:02:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rBpav8wVM1nb4wF_t0TQDnLjPRLfoyUc4dzyn5K.0L5MKvN
 CkJBQSG8LsCkNag9O502uAxhoLUIRll7921tETePMYEf8iMfZJGLUBGDhr95
 Y1L3RfQ0bvQSRyyxeZ9z.lSB.Z1zeqqQ0OnMqz9iFlflyoWDrfdFPV9Jn40r
 HmFRym83zdf2EIDmOqLY7SPlsaogwZpRO_xelEJcAcHKJxR3qhD0Xd1I3NL5
 y30SPpFSeT50w05TIvqSpM33ixAqub_Chw9pVirDC.PBp_eWH6s0uZPHJ97o
 4tO1QPsB7fsKZ.fYVT4S0koxWJc3Rmg9KVVb1_BI2wbMMJNHrp9ZVB15MG.e
 K7xWxTgVqm4zRVhtTqqdmoGbGv15rHGHRJLtWtmsSBh5AW9fI49YXSO5orJC
 f
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 7 May 2012 11:02:26 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 08/41] nohz: Try not to give the timekeeping duty to an
 adaptive tickless cpu
In-Reply-To: <1335830115-14335-9-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.1205071055370.1060@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com> <1335830115-14335-9-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2012, Frederic Weisbecker wrote:

> Try to give the timekeeing duty to a CPU that doesn't belong
> to any nohz cpuset when possible, so that we increase the chance
> for these nohz cpusets to run their CPUs out of periodic tick
> mode.
>
> [TODO: We need to find a way to ensure there is always one non-nohz
> running CPU maintaining the timekeeping duty if every non-idle CPUs are
> adaptive tickless]

I sure wish this would also be pinnable to a specific cpu.
