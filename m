Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1I0Vw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:52:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:36051 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1I0Vw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:52:57 -0400
Subject: Re: [RFD 3/9] Display /proc/stat information per cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com
Date: Tue, 27 Sep 2011 23:52:24 +0200
In-Reply-To: <1316816432-9237-4-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
	 <1316816432-9237-4-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317160344.21836.16.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
> +       root_task_group.cpustat = alloc_percpu(struct kernel_stat);
> +       /* Failing that early an allocation means we're screwed anyway */
> +       BUG_ON(!root_task_group.cpustat);
> +       for_each_possible_cpu(i) {
> +               kstat = per_cpu_ptr(root_task_group.cpustat, i);
> +               kstat->cpustat[IDLE] = 0;
> +               kstat->cpustat[IDLE_BASE] = 0;
> +               kstat->cpustat[IOWAIT_BASE] = 0;
> +               kstat->cpustat[IOWAIT] = 0;

so alloc_percpu() will actually zero your memory for you, which you rely
on for all other fields as well, so why reset these ones?

> +       }


