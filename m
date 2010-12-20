Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab0LTPxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:53:32 -0500
Received: from canuck.infradead.org ([134.117.69.58]:57228 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab0LTPxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:53:31 -0500
Subject: Re: [RFC PATCH 05/15] nohz_task: Restart the tick when another
 task compete on the cpu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <1292858662-5650-6-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-6-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Dec 2010 16:53:21 +0100
Message-ID: <1292860401.5021.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> +#ifdef CONFIG_NO_HZ_TASK
> +       /*
> +        * CHECKME:
> +        * Ideally, we need to check if the target has a nohz task
> +        * and only send the IPI if so. But there is nothing but
> +        * a racy way to do that. Or can we assume at that point
> +        * of the wake up that if cpu_has_nohz_task(cpu) is 0, then
> +        * it's ok, even if it has a task about to switch to nohz
> +        * task mode?
> +        */
> +       if (rq->nr_running == 2)
> +               smp_send_update_nohz_task_cpu(cpu);
> +#endif 

This is the wrong place, use ttwu_activate(), since activate_task() is
the thing that pokes at nr_running.
