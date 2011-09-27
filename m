Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab1I0WBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 18:01:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:36152 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab1I0WBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 18:01:14 -0400
Subject: Re: [RFD 4/9] Make total_forks per-cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed, 28 Sep 2011 00:00:37 +0200
In-Reply-To: <1316816432-9237-5-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
	 <1316816432-9237-5-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317160837.21836.21.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
> @@ -1039,6 +1035,8 @@ static void posix_cpu_timers_init(struct task_struct *tsk)
>         INIT_LIST_HEAD(&tsk->cpu_timers[2]);
>  }
>  
> +struct task_group *task_group(struct task_struct *p);

That doesn't appear to be actually used in this file..

Also, since there's already a for_each_possible_cpu() loop in that
proc/stat function, would it yield some code improvement to make
total_forks a cpu_usage_stat?

I guess the whole cputime64_t crap gets in the way of that being
natural... 

We could of course kill off the cputime64_t thing, its pretty pointless
and its a u64 all over the board. I think Martin or Heiko created this
stuff (although I might be wrong, my git tree doesn't go back that far).


