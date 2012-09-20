Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab2ITJHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:07:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55987 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2ITJHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:07:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120920000313.GH2455@linux.vnet.ibm.com>
References: <CACRpkdYgxsF1G7Dc_xCcQcFV9G+foz1czOCmROcMQ5NfR-ziCA@mail.gmail.com>
	<50520E8A.9030408@linaro.org>
	<20120913165844.GW4257@linux.vnet.ibm.com>
	<CACRpkdatjfk_eUof5G4fwa-Qf8SoF_NvSUJQAZ7U8yjcSYFuTA@mail.gmail.com>
	<20120914175322.GI4257@linux.vnet.ibm.com>
	<CACRpkdbw+VgaV26U6uZeKr9g28ax2shrieQSxFuj-Pi9RXPtLQ@mail.gmail.com>
	<20120920000313.GH2455@linux.vnet.ibm.com>
Date: Thu, 20 Sep 2012 11:07:37 +0200
Message-ID: <CACRpkdaufGjsEtkjQFY9oDvmtM7xnEiFweLfOGuX+WRf0Vbb5A@mail.gmail.com>
Subject: Re: RCU lockup in the SMP idle thread, help...
From: Linus Walleij <linus.walleij@linaro.org>
To: paulmck@linux.vnet.ibm.com
Cc: John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 2:03 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:

> In the meantime, a crude fallback is for the CPU that detected the stall
> to trace the stack of the task running on the other CPU.  See below for
> a crude (and untested) patch.

OK now I get this:

 INFO: rcu_preempt detected stalls on CPUs/tasks: { 0} (detected by 1,
t=29508 jiffies)
Task dump for CPU 0:
swapper/0       R running      0     0      0 0x00000000
[<c02da614>] (__schedule+0x238/0x52c) from [<c000f238>] (default_idle+0x28/0x30)
[<c000f238>] (default_idle+0x28/0x30) from [<ffffffff>] (0xffffffff)
INFO: rcu_preempt detected stalls on CPUs/tasks: { 0} (detected by 1,
t=29851 jiffies)
Task dump for CPU 0:
swapper/0       R running      0     0      0 0x00000000
[<c02da614>] (__schedule+0x238/0x52c) from [<c000f238>] (default_idle+0x28/0x30)
[<c000f238>] (default_idle+0x28/0x30) from [<ffffffff>] (0xffffffff)

So the swapper thread is the culprit?
Hm, I'm not very smart with this no...

Yours,
Linus Walleij
