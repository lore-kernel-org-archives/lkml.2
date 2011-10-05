Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134Ab1JEJKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:10:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36089 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903Ab1JEJKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:10:37 -0400
Subject: Re: [PATCH 08/10] provide a version of cpuacct statistics inside
 cpu cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com,
        Balbir Singh <bsingharora@gmail.com>
Date: Wed, 05 Oct 2011 11:10:25 +0200
In-Reply-To: <1317583287-18300-9-git-send-email-glommer@parallels.com>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
	 <1317583287-18300-9-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317805825.6766.7.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-02 at 23:21 +0400, Glauber Costa wrote:
> +       for_each_online_cpu(cpu) {
> +               struct kernel_stat *kstat = per_cpu_ptr(tg->cpustat, cpu);
> +               val += kstat->cpustat[USER];
> +               val += kstat->cpustat[NICE];
> +       } 

by using online_cpu, you fail to sum whatever data was accrued on
unplugged cpus, is that a problem?


