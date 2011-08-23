Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1HWTNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:13:08 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:45432 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755304Ab1HWTNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:13:00 -0400
Subject: Re: [PATCH] nohz: remove "Switched to NOHz mode" debugging messages
From: Joe Perches <joe@perches.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>
In-Reply-To: <20110823112046.GB2540@osiris.boeblingen.de.ibm.com>
References: <20110823112046.GB2540@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 12:12:57 -0700
Message-ID: <1314126777.1659.2.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 13:20 +0200, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> When performing cpu hotplug tests the kernel printk log buffer gets flooded
> with pointless "Switched to NOHz mode..." messages. Especially when afterwards
> analyzing a dump this might have removed more interesting stuff out of the
> buffer.
> Assuming that switching to NOHz mode simply works just remove the printk.

> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
[]
> -
> -	printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());

Though I don't know if these are actually particularly
useful messages, perhaps pr_info_ratelimited() might
be appropriate instead.

> @@ -793,10 +791,8 @@ void tick_setup_sched_timer(void)
> -		printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());

and here.


