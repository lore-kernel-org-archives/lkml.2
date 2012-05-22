Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2EVVu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:50:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4908 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab2EVVuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:50:55 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=xF3DEj1R0Q8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=nNH1UW0TvuUlUF5Xe2IA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337723451.13348.121.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 00/32] Nohz cpusets v2 (adaptive tickless kernel)
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Zen Lin <zen@openhuawei.org>
Date: Tue, 22 May 2012 17:50:51 -0400
In-Reply-To: <alpine.LFD.2.02.1205222327080.3231@ionos>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	  <CAOtvUMf0Zp9C-jT=ymEo6oyxnsgkvSiGDUs5V_56v4Ai2QyBJQ@mail.gmail.com>
	 <1332861025.16159.236.camel@twins>
	 <alpine.LFD.2.02.1205222327080.3231@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 23:31 +0200, Thomas Gleixner wrote:

> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 590900c..dc8ecc3 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -109,6 +109,10 @@ static int __init tsc_setup(char *str)
>  {
>  	if (!strcmp(str, "reliable"))
>  		tsc_clocksource_reliable = 1;
> +	if (!strcmp(str, "perfect")) {
> +		tsc_clocksource_reliable = 1;
> +		sched_clock_stable = 1;
> +	}

	else if(!strcmp(str, "pony")) {
		tsc_clocksource_reliable = 1;
		sched_clock_stable = 1;
		tsc_perfect_smp_synchronization = 1;
	}

-- Steve

>  	if (!strncmp(str, "noirqtime", 9))
>  		no_sched_irq_time = 1;
>  	return 1;
>  


