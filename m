Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab2E2IjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 04:39:00 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54704 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2E2Ii5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 04:38:57 -0400
Date: Tue, 29 May 2012 04:36:30 -0400 (EDT)
Message-Id: <20120529.043630.590431449662750806.davem@davemloft.net>
To: yong.zhang0@gmail.com
Cc: srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com,
        nikunj@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, axboe@kernel.dk,
        mingo@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        akpm@linux-foundation.org, sparclinux@vger.kernel.org
Subject: Re: [UPDATED] [RFC PATCH 08/10] SPARC: smp: remove call to
 ipi_call_lock_irq()/ipi_call_unlock_irq()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120529082732.GA4250@zhy>
References: <1338275765-3217-9-git-send-email-yong.zhang0@gmail.com>
	<4FC48272.9040904@linux.vnet.ibm.com>
	<20120529082732.GA4250@zhy>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 29 May 2012 01:36:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang0@gmail.com>
Date: Tue, 29 May 2012 16:27:33 +0800

> From: Yong Zhang <yong.zhang@windriver.com>
> Date: Tue, 29 May 2012 12:56:08 +0800
> Subject: [UPDATED] [RFC PATCH 8/10] SPARC: smp: remove call to
>  ipi_call_lock_irq()/ipi_call_unlock_irq()
> 
> 1) call_function.lock used in smp_call_function_many() is just to protect
>    call_function.queue and &data->refs, cpu_online_mask is outside of the
>    lock. And it's not necessary to protect cpu_online_mask,
>    because data->cpumask is pre-calculate and even if a cpu is brougt up
>    when calling arch_send_call_function_ipi_mask(), it's harmless because
>    validation test in generic_smp_call_function_interrupt() will take care
>    of it.
> 
> 2) For cpu down issue, stop_machine() will guarantee that no concurrent
>    smp_call_fuction() is processing.
> 
> And also delay irq enable to after set_cpu_online().
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
