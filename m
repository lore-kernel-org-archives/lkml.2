Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab2GUJbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 05:31:13 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:32931 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2GUJbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 05:31:11 -0400
Message-ID: <500A75D7.3070706@linux.vnet.ibm.com>
Date: Sat, 21 Jul 2012 14:56:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [Patch 3/7] smpboot: Provide infrastructure for percpu hotplug
 threads
References: <20120716103749.122800930@linutronix.de> <20120716103948.352501068@linutronix.de>
In-Reply-To: <20120716103948.352501068@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12072109-5140-0000-0000-000001C82977
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 04:12 PM, Thomas Gleixner wrote:
> Provide a generic interface for setting up and tearing down percpu
> threads.
> 
> On registration the threads for already online cpus are created and
> started. On deregistration (modules) the threads are stoppped.
> 
> During hotplug operations the threads are created, started, parked and
> unparked. The datastructure for registration provides a pointer to
> percpu storage space and optional setup, cleanup, park, unpark
> functions. These functions are called when the thread state changes.
> 
> Each implementation has to provide a function which is queried and
> returns whether the thread should run and the thread function itself.
> 
> The core code handles all state transitions and avoids duplicated code
> in the call sites.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Elegant design and very beautiful code!
It was such a pleasure to read and review it :-)

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

[ A minor nit below ]

> ---
>  include/linux/smpboot.h |   43 +++++++++
>  kernel/cpu.c            |   10 +-
>  kernel/smpboot.c        |  229 ++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/smpboot.h        |    4 
>  4 files changed, 285 insertions(+), 1 deletion(-)
> 
> +
> +/**
> + * smpboot_thread_fn - percpu hotplug thread loop function
> + * @void:	thread data pointer

s/void/data

> + *
> + * Checks for thread stop and park conditions. Calls the necessary
> + * setup, cleanup, park and unpark functions for the registered
> + * thread.
> + *
> + * Returns 1 when the thread should exit, 0 otherwise.
> + */
> +static int smpboot_thread_fn(void *data)
> +{
> +	struct smpboot_thread_data *td = data;
> +	struct smp_hotplug_thread *ht = td->ht;
> +

Regards,
Srivatsa S. Bhat

