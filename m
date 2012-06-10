Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab2FJKpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 06:45:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63168 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2FJKpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 06:45:53 -0400
MIME-Version: 1.0
Date: Sun, 10 Jun 2012 18:45:52 +0800
Message-ID: <CAFNq8R5D2Y8pxk=fajdAWv1v5L_r8kY7HfVh2gOLaNHq4SAOmA@mail.gmail.com>
Subject: When switch_mm with thread migration, Why flush instruction cache on
 ARM platform?
From: Li Haifeng <omycle@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can someone tell me why flush instruction cache @118 Line below, when
switch_mm with thread migration from other ARM core.

107 static inline void
108 switch_mm(struct mm_struct *prev, struct mm_struct *next,
109           struct task_struct *tsk)
110 {
111 #ifdef CONFIG_MMU
112         unsigned int cpu = smp_processor_id();
113
114 #ifdef CONFIG_SMP
115         /* check for possible thread migration */
116         if (!cpumask_empty(mm_cpumask(next)) &&
117             !cpumask_test_cpu(cpu, mm_cpumask(next)))
118                 __flush_icache_all();
119 #endif
...
130 #endif
131 }

Thanks.
