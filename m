Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab0IHMez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 08:34:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56597 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0IHMew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 08:34:52 -0400
From: fabio de francesco <fabio@metanix.org>
Organization: metanix.org
To: LKML <linux-kernel@vger.kernel.org>
Subject: linux/kernel/sched.c: context_switch().
Date: Wed, 8 Sep 2010 14:33:34 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-tuxonice-r1-100826; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009081433.35019.fabio@metanix.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There must be something I am missing in sched.c at context_switch() function 
definition. 

There I can read the following code:

static inline void
context_switch(struct rq *rq, struct task_struct *prev,
               struct task_struct *next)
{
	...
	struct mm_struct *mm;
	mm = next->mm;
	if (likely(!mm)) {
                next->active_mm = oldmm;
                atomic_inc(&oldmm->mm_count);
                enter_lazy_tlb(oldmm, next);
        } else
                switch_mm(oldmm, mm, next);
	...
}

May someone please explain why the mm pointer is likely supposed to be NULL?

Thanks in advance.

fabio
