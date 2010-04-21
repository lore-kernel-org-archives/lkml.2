Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab0DUM4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 08:56:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab0DUM4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:56:43 -0400
Subject: Re: Considerations on sched APIs under RT patch
From: Peter Zijlstra <peterz@infradead.org>
To: Primiano Tucci <p.tucci@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx <tglx@linutronix.de>,
       rostedt <rostedt@goodmis.org>
In-Reply-To: <k2nc5b2c05b1004201456j846b15a0oaa261d16740b5e33@mail.gmail.com>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
	 <1271755208.1676.422.camel@laptop>
	 <k2nc5b2c05b1004201456j846b15a0oaa261d16740b5e33@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 14:56:41 +0200
Message-ID: <1271854601.1776.102.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 23:56 +0200, Primiano Tucci wrote:
> 
> long sched_setaffinity(pid_t pid, const struct cpumask *in_mask) {
>         cpumask_var_t cpus_allowed, new_mask;
>         struct task_struct *p;
>         int retval;
> 
>         get_online_cpus();
> -->     read_lock(&tasklist_lock);

FWIW recent kernels don't use tasklist_lock there anymore.

