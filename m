Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab0EYOWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 10:22:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:33504 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab0EYOWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 10:22:48 -0400
Subject: Re: [PATCH v3] Make sure timers have migrated before killing
 migration_thread
From: Peter Zijlstra <peterz@infradead.org>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, tj@kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100525132346.GA14986@amitarora.in.ibm.com>
References: <20100519090557.GA15237@amitarora.in.ibm.com>
	 <1274261515.5605.10423.camel@twins>
	 <20100524095951.GA17680@amitarora.in.ibm.com>
	 <1274787095.5882.949.camel@twins>
	 <20100525132346.GA14986@amitarora.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 16:22:22 +0200
Message-ID: <1274797342.5882.1444.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 18:53 +0530, Amit K. Arora wrote:

nice :-)

Thanks!

> Signed-off-by: Amit Arora <aarora@in.ibm.com>
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Tejun Heo <tj@kernel.org>
> ---
> diff -Nuarp linux-2.6-next-20100525.org/kernel/stop_machine.c linux-2.6-next-20100525/kernel/stop_machine.c
> --- linux-2.6-next-20100525.org/kernel/stop_machine.c   2010-05-25 14:27:51.000000000 -0400
> +++ linux-2.6-next-20100525/kernel/stop_machine.c       2010-05-25 14:30:09.000000000 -0400
> @@ -321,7 +321,7 @@ static int __cpuinit cpu_stop_cpu_callba
>  
>  #ifdef CONFIG_HOTPLUG_CPU
>         case CPU_UP_CANCELED:
> -       case CPU_DEAD:
> +       case CPU_POST_DEAD:
>         {
>                 struct cpu_stop_work *work; 
