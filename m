Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab2LHPC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 10:02:58 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37976 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab2LHPC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 10:02:57 -0500
Date: Sat, 8 Dec 2012 16:02:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anish Kumar <anish198519851985@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL v2] printk: Make it usable on nohz cpus
Message-ID: <20121208150252.GI12011@gmail.com>
References: <1353200692-6039-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353200692-6039-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the printk support in dynticks mode patches that can
> be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git tags/printk-dynticks-for-mingo-v2
> 
> for you to fetch changes up to 74876a98a87a115254b3a66a14b27320b7f0acaa:
> 
>   printk: Wake up klogd using irq_work (2012-11-18 01:01:49 +0100)
> 
> It is based on v3.7-rc4.
> 
> Changes since previous pull request include support for irq 
> work flush on CPU offlining and acks from Steve. The rest 
> hasn't changed except some comment fix.

Since this changes kernel/printk.c it needs Linus's ack.

I looked through the older submissions but found no good summary 
of these changes: it would be nice if you could write up a good 
high level description of these changes - why has printk based 
kernel message logging become problematic on nohz, what are the 
symptoms to users, and what are the solution alternatives you 
found and please justify the irq_work extension variant you 
picked.

I more or less accept the fact that fixes are needed here, but 
the linecount appears a bit high. It's possibly unavoidable, but 
would be nice to have a discussion of it, as printk is something 
we really, really want to keep as simple as possible.

Thanks,

	Ingo
