Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1I0VEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:04:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:35408 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab1I0VEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:04:07 -0400
Subject: Re: [RFD 1/9] Change cpustat fields to an array.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com
Date: Tue, 27 Sep 2011 23:03:29 +0200
In-Reply-To: <1316816432-9237-2-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
	 <1316816432-9237-2-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317157409.21836.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
> @@ -623,6 +624,9 @@ static inline struct task_group *task_group(struct
> task_struct *p)
>         struct task_group *tg;
>         struct cgroup_subsys_state *css;
>  
> +       if (!p->mm)
> +               return &root_task_group;
> +
>         css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
>                         lockdep_is_held(&p->pi_lock) ||
>                         lockdep_is_held(&task_rq(p)->lock)); 

Hmm, why is that? Aren't kthreads part of the cgroup muck just as much
as normal tasks are?
