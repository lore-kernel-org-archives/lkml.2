Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112Ab1JEI4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:56:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60803 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab1JEI4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:56:16 -0400
Subject: Re: [PATCH 04/10] Display /proc/stat information per cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com
Date: Wed, 05 Oct 2011 10:56:05 +0200
In-Reply-To: <1317583287-18300-5-git-send-email-glommer@parallels.com>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
	 <1317583287-18300-5-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317804965.6766.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-02 at 23:21 +0400, Glauber Costa wrote:
> +struct kernel_stat *task_group_kstat(struct task_struct *p)
> +{
> +       struct task_group *tg;
> +       struct kernel_stat *kstat;
> +
> +       rcu_read_lock();
> +       tg = task_group(p);
> +       kstat = tg->cpustat;
> +       rcu_read_unlock();
> +       return kstat;
> +} 

Who keeps tg alive and kicking while you poke at its (cpustat) member?
