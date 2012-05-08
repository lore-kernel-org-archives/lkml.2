Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab2EHRfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:35:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2EHRfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:35:45 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205071055370.1060@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
	<1335830115-14335-9-git-send-email-fweisbec@gmail.com>
	<alpine.DEB.2.00.1205071055370.1060@router.home>
Date: Tue, 8 May 2012 19:35:45 +0200
Message-ID: <CAFTL4hzM0socf0BphDmD7qv8W8wyJnBNkuXV9tv+yo=AJUYMRg@mail.gmail.com>
Subject: Re: [PATCH 08/41] nohz: Try not to give the timekeeping duty to an
 adaptive tickless cpu
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/7 Christoph Lameter <cl@linux.com>:
> On Tue, 1 May 2012, Frederic Weisbecker wrote:
>
>> Try to give the timekeeing duty to a CPU that doesn't belong
>> to any nohz cpuset when possible, so that we increase the chance
>> for these nohz cpusets to run their CPUs out of periodic tick
>> mode.
>>
>> [TODO: We need to find a way to ensure there is always one non-nohz
>> running CPU maintaining the timekeeping duty if every non-idle CPUs are
>> adaptive tickless]
>
> I sure wish this would also be pinnable to a specific cpu.

Yeah, well we need to be more flexible and allow for finegrained sets of CPUs,
I quoted some reasons in one of our previous discussions:
https://lkml.org/lkml/2012/3/29/559
