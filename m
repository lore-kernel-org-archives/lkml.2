Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab2C1GrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:47:17 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42656 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2C1GrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:47:16 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <alpine.DEB.2.00.1203271116370.1170@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	<CAOtvUMf0Zp9C-jT=ymEo6oyxnsgkvSiGDUs5V_56v4Ai2QyBJQ@mail.gmail.com>
	<CAOtvUMeTHbW3qJRVndhZ4mZ57xG=XGtef_OinZ=wca2n14OTbw@mail.gmail.com>
	<CAOtvUMc5Cx8yv6=CcQ6iJzWC0yhPzp+OsH3aU1VFzWOuaKfcww@mail.gmail.com>
	<alpine.DEB.2.00.1203271116370.1170@router.home>
Date: Wed, 28 Mar 2012 08:47:15 +0200
Message-ID: <CAOtvUMcH3AKRK9w832yFGY+JiebXb6P6jKM_H1Zcfjdp8+o32Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 00/32] Nohz cpusets v2 (adaptive tickless kernel)
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 6:22 PM, Christoph Lameter <cl@linux.com> wrote:
> On Tue, 27 Mar 2012, Gilad Ben-Yossef wrote:
>
>> +static void vmstat_update(struct work_struct *w)
>> +{
>> +     int cpu, this_cpu = smp_processor_id();
>> +     int sleepy_cpu_counter = 0;
>> +     static spinlock_t lock;
>> +
>> +     if(spin_trylock(&lock)) {
>
> Trylock would cause cache bouncing between vmstat runs on various
> processors. The reason that vmstat_update exists is to avoid these cache
> bounces. Please no exclusive cacheline acquisiton by all cpus by default.
>

Right, I didn't think of that.

> The best method would be to assign a sacrifical lamb cpu and check if we
> are running on that cpu. That way taking a lock can be avoided.

Cool, I'll do it.

Thanks

Gilad


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
