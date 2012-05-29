Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab2E2GxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:53:05 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51678 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2E2GxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:53:03 -0400
Date: Tue, 29 May 2012 14:52:48 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, axboe@kernel.dk,
        jeremy.fitzhardinge@citrix.com, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/8] MIPS: call set_cpu_online() on the uping cpu with
 irq disabled
Message-ID: <20120529065248.GA2597@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
 <1337580008-7280-7-git-send-email-yong.zhang0@gmail.com>
 <4FBA1B54.3@linux.vnet.ibm.com>
 <20120522062126.GB12098@zhy>
 <4FC369E3.1030901@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FC369E3.1030901@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 05:34:51PM +0530, Srivatsa S. Bhat wrote:
> No, I think you are right. Sorry for the delay in replying.
> It indeed looks like we need not use ipi_call_lock/unlock() in CPU bringup
> code..
> 
> However, it does make me wonder about this:
> commit 3d4422332 introduced the generic ipi helpers, and reduced the scope
> of call_function.lock and also added the check in
> generic_smp_call_function_interrupt() to proceed only if the cpu is present
> in data->cpumask.
> 
> Then, commit 3b16cf8748 converted x86 to the generic ipi helpers, but while
> doing that, it explicitly retained ipi_call_lock/unlock(), which is kind of
> surprising.. I guess it was a mistake rather than intentional.

Agree. I think it's a mistake(or leftover) too :)

Anyway, let me cook a patch to throw a stone to clear the road.

Thanks,
Yong
