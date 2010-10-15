Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab0JOO2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:28:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:45232 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab0JOO2j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:28:39 -0400
Subject: Re: [PATCH 4/8] Add IRQ_TIME_ACCOUNTING, finer accounting of irq
 time -v4
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1286237003-12406-5-git-send-email-venki@google.com>
References: <1286237003-12406-1-git-send-email-venki@google.com>
	 <1286237003-12406-5-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 16:28:15 +0200
Message-ID: <1287152895.29097.1520.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-04 at 17:03 -0700, Venkatesh Pallipadi wrote:
> +       if (hardirq_count())

	if (in_irq())

to match the (mangled) in_serving_softirq() ?

> +               per_cpu(cpu_hardirq_time, cpu) += delta;
> +       else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
> +               per_cpu(cpu_softirq_time, cpu) += delta; 
