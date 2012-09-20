Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab2ITOLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:11:24 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59329 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab2ITOLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:11:23 -0400
Date: Thu, 20 Sep 2012 07:10:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: RCU lockup in the SMP idle thread, help...
Message-ID: <20120920141052.GA2449@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CACRpkdYgxsF1G7Dc_xCcQcFV9G+foz1czOCmROcMQ5NfR-ziCA@mail.gmail.com>
 <50520E8A.9030408@linaro.org>
 <20120913165844.GW4257@linux.vnet.ibm.com>
 <CACRpkdatjfk_eUof5G4fwa-Qf8SoF_NvSUJQAZ7U8yjcSYFuTA@mail.gmail.com>
 <20120914175322.GI4257@linux.vnet.ibm.com>
 <CACRpkdbw+VgaV26U6uZeKr9g28ax2shrieQSxFuj-Pi9RXPtLQ@mail.gmail.com>
 <20120920000313.GH2455@linux.vnet.ibm.com>
 <CACRpkdaufGjsEtkjQFY9oDvmtM7xnEiFweLfOGuX+WRf0Vbb5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaufGjsEtkjQFY9oDvmtM7xnEiFweLfOGuX+WRf0Vbb5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092014-7408-0000-0000-000008A8FD85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 11:07:37AM +0200, Linus Walleij wrote:
> On Thu, Sep 20, 2012 at 2:03 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> 
> > In the meantime, a crude fallback is for the CPU that detected the stall
> > to trace the stack of the task running on the other CPU.  See below for
> > a crude (and untested) patch.
> 
> OK now I get this:
> 
>  INFO: rcu_preempt detected stalls on CPUs/tasks: { 0} (detected by 1,
> t=29508 jiffies)
> Task dump for CPU 0:
> swapper/0       R running      0     0      0 0x00000000
> [<c02da614>] (__schedule+0x238/0x52c) from [<c000f238>] (default_idle+0x28/0x30)
> [<c000f238>] (default_idle+0x28/0x30) from [<ffffffff>] (0xffffffff)
> INFO: rcu_preempt detected stalls on CPUs/tasks: { 0} (detected by 1,
> t=29851 jiffies)
> Task dump for CPU 0:
> swapper/0       R running      0     0      0 0x00000000
> [<c02da614>] (__schedule+0x238/0x52c) from [<c000f238>] (default_idle+0x28/0x30)
> [<c000f238>] (default_idle+0x28/0x30) from [<ffffffff>] (0xffffffff)
> 
> So the swapper thread is the culprit?
> Hm, I'm not very smart with this no...

Can we convince ARM to dump the stack of the swapper thread in this case?
That would get us valuable information.

							Thanx, Paul

