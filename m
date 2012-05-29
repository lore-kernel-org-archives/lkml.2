Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2E2ILd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 04:11:33 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:52849 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2E2ILb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 04:11:31 -0400
Message-ID: <4FC48281.4030502@linux.vnet.ibm.com>
Date: Tue, 29 May 2012 13:32:09 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, ralf@linux-mips.org, sshtylyov@mvista.com,
        david.daney@cavium.com, nikunj@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, axboe@kernel.dk, mingo@kernel.org,
        tglx@linutronix.de, peterz@infradead.org, akpm@linux-foundation.org
Subject: Re: [RFC PATCH 00/10] Cleanup ipi_call_lock[_irq]()/ipi_call_unlock[_irq]()
References: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12052908-8878-0000-0000-000002B39A3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 12:45 PM, Yong Zhang wrote:

> As discussed with Srivatsa [1], it seems there is no need to keep
> ipi_call_[un]lock_irq() when cpu bring-up/down. Because:
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
> In short it's more likely that keeping ipi_call_[un]lock() is leftover
> before we introduce generic smp helper. This patchset is just to clean
> things up.
> 
> [1] http://marc.info/?l=linux-kernel&m=133766786814484&w=2
> 
> Yong Zhang (10):
>   hexagon: smp: remove call to ipi_call_lock()/ipi_call_unlock()
>   mn10300: smp: remove call to ipi_call_lock()/ipi_call_unlock()
>   parisc: smp: remove call to ipi_call_lock()/ipi_call_unlock()
>   S390: smp: remove call to ipi_call_lock()/ipi_call_unlock()
>   tile: smp: remove call to ipi_call_lock()/ipi_call_unlock()
>   x86: smp: remove call to ipi_call_lock()/ipi_call_unlock()
>   ia64: smp: remove call to ipi_call_lock_irq()/ipi_call_unlock_irq()
>   SPARC: smp: remove call to ipi_call_lock_irq()/ipi_call_unlock_irq()
>   POWERPC: smp: remove call to ipi_call_lock()/ipi_call_unlock()
>   smp: remove ipi_call_lock[_irq]()/ipi_call_unlock[_irq]()
>


All patches except the sparc one look good.
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

