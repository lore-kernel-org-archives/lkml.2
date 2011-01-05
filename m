Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab1AETdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 14:33:32 -0500
Received: from canuck.infradead.org ([134.117.69.58]:37983 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1AETdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 14:33:32 -0500
Subject: Re: [RFC][PATCH 11/18] sched: Add p->pi_lock to task_rq_lock()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110105184644.GA28306@redhat.com>
References: <20110104145929.772813816@chello.nl>
	 <20110104150102.862431889@chello.nl>  <20110105184644.GA28306@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 20:33:34 +0100
Message-ID: <1294256014.2016.284.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 19:46 +0100, Oleg Nesterov wrote:

> One purely cosmetic nit,

Fixed those, thanks!

> Hmm, and normalize_rt_tasks(), it could just do task_rq_lock/task_rq_unlock.
> And why it does read_lock_irqsave(tasklist), btw? _irqsave looks unneeded. 

I'm not quite sure, I think we can make that an RCU iteration of the
taskset as well, no need to even hold the task-lock, it would render the
sysrq button useless in the face of a RT fork bomb, but I'm not sure we
really care about that at all.

Ingo, Thomas?
