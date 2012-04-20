Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2DTUHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:07:20 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:56396 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab2DTUHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:07:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120420124557.035417523@linutronix.de>
References: <20120420122120.097464672@linutronix.de>
	<20120420124557.035417523@linutronix.de>
Date: Fri, 20 Apr 2012 13:07:16 -0700
X-Google-Sender-Auth: JuJohKRaBvEZs8fnaTpkbPpKl20
Message-ID: <CAE9FiQWpcD_GAtmnowTpAEW+6hRqxjokHKf4Nb2K92sm=SUGNQ@mail.gmail.com>
Subject: Re: [patch 03/18] smp: Add generic smpboot facility
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Howells <dhowells@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 6:05 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Start a new file, which will hold SMP and CPU hotplug related generic
> infrastructure.
>
===================================================================
> --- linux-2.6.orig/kernel/cpu.c
> +++ linux-2.6/kernel/cpu.c
> @@ -17,6 +17,8 @@
>  #include <linux/gfp.h>
>  #include <linux/suspend.h>
>
> +#include "smpboot.h"
> +
>  #ifdef CONFIG_SMP
>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
>  static DEFINE_MUTEX(cpu_add_remove_lock);
> @@ -300,6 +302,11 @@ static int __cpuinit _cpu_up(unsigned in
>                return -EINVAL;
>
>        cpu_hotplug_begin();
> +
> +       ret = smpboot_prepare(cpu);
> +       if (ret)
> +               goto out;
> +
>        ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
>        if (ret) {
>                nr_calls--;
> @@ -320,6 +327,7 @@ static int __cpuinit _cpu_up(unsigned in
>  out_notify:
>        if (ret != 0)
>                __cpu_notify(CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
> +out:
>        cpu_hotplug_done();
>
>        return ret;
> Index: linux-2.6/kernel/smpboot.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/kernel/smpboot.c
> @@ -0,0 +1,12 @@
> +/*
> + * Common SMP CPU bringup/teardown functions
> + */
> +
> +#include "smpboot.h"
> +
> +/**
> + * smpboot_prepare - generic smpboot preparation
> + */
> +int __cpuinit smpboot_prepare(unsigned int cpu)
> +{
         return 0;
> +}
