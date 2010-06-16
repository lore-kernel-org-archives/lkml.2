Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab0FPGDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 02:03:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:58502 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab0FPGDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 02:03:12 -0400
Date: Tue, 15 Jun 2010 23:05:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avoid using smp_processor_id() in preemptible code
 (nr_iowait_cpu)
Message-ID: <20100615230541.5db5078e@infradead.org>
In-Reply-To: <20100615161303.GA4102@swordfish.minsk.epam.com>
References: <20100614140941.GA3581@swordfish.minsk.epam.com>
	<20100614073853.6fa2f91f@infradead.org>
	<20100614145439.GA3448@swordfish.minsk.epam.com>
	<20100614080154.7d6a71fc@infradead.org>
	<20100614151735.GB3448@swordfish.minsk.epam.com>
	<20100614204021.52c50cdc@infradead.org>
	<20100615061927.GA3312@swordfish>
	<20100615072435.5a47d850@infradead.org>
	<20100615145029.GB3967@swordfish.minsk.epam.com>
	<20100615080808.6286448b@infradead.org>
	<20100615161303.GA4102@swordfish.minsk.epam.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 19:13:03 +0300
Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> 
> I've changed struct tick_sched to match passed *ts and cpu. Also
> changed "&per_cpu(tick_cpu_sched, cpu)" call to "struct tick_sched
> *tick_get_tick_sched(int cpu)" which we already have.
> 
> But I don't really like this part:
> struct tick_sched *tick_get_tick_sched(int cpu)
> {
> 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> 	ts->cpu = cpu;
> 	^^^^^^^^^^^^^
> 	return ts;
> }
> 
> Please kindly review.


can we do this bit once, when the ts structure gets initialized?
it's not like the cpu value will ever change...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
