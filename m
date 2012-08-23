Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833Ab2HWKqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:46:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:53703 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2HWKqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:46:43 -0400
Date: Thu, 23 Aug 2012 12:46:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sedat Dilek <sedat.dilek@gmail.com>
cc: Paul McKenney <paul.mckenney@linaro.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [next-20120823] NOHZ: local_softirq_pending 200 on s/r
In-Reply-To: <CA+icZUW2aUP=vjBeoksFU=NAVFMJEiBQy6sNKZczzRPEP9kOfw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1208231245510.2856@ionos>
References: <CA+icZUW2aUP=vjBeoksFU=NAVFMJEiBQy6sNKZczzRPEP9kOfw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2012, Sedat Dilek wrote:

> Hi,
> 
> this week I was seeing the below NOHZ messages in my logs especially
> when suspending and resuming.
> 
> Currently, I am using linux-next (next-20120823) on Ubuntu/precise
> AMD64 with a Intel S(a)N(dy)B(ridge)-CPU.
> 
> $ dmesg | grep -A1 -B1 -i nohz
> [  720.331819] Disabling non-boot CPUs ...
> [  720.332035] NOHZ: local_softirq_pending 200
> [  720.434312] smpboot: CPU 1 is now offline
> [  720.434825] NOHZ: local_softirq_pending 200
> [  720.538237] smpboot: CPU 2 is now offline
> [  720.538676] NOHZ: local_softirq_pending 200
> [  720.642162] smpboot: CPU 3 is now offline
> 
> If I manually disable the cpuX... First I did not see NOHZ messages
> but then there were some lines seen especially when cpuX went offline
> (here: cpu1)
> 
> # echo 0 >/sys/devices/system/cpu/cpu1/online
> 
> [ dmeg ]
> [ 2605.515771] smpboot: CPU 1 is now offline
> 
> The same with cpu2 and cpu3.
> 
> Jack Winter confirmed to see similiar NOHZ messages also on
> v3.4.9-rt17 kernel (CPU: Core2Duo when no suspend performed):
> 
> [15223.171585] NOHZ: local_softirq_pending 08

That's a different issue. That's a pending networking softirq when we
go idle. Unrelated to the RCU / hotplug issue you are observing.

> So, the issue is seen on linux-next and -rt kernels.
> 
> According to Thomas "softirq 0x200 is the RCU one" and he requested me
> to address the issue to Paul on #linux-rt.
> 
> Regards,
> - Sedat -
> 
