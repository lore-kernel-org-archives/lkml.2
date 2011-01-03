Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1ACLMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:12:09 -0500
Received: from canuck.infradead.org ([134.117.69.58]:39183 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab1ACLMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:12:07 -0500
Subject: Re: [RFC][PATCH 07/17] sched: Serialize p->cpus_allowed and ttwu()
 using p->pi_lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
In-Reply-To: <20101229142019.GB2728@zhy>
References: <20101224122338.172750730@chello.nl>
	 <20101224123742.833040935@chello.nl>  <20101229142019.GB2728@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Jan 2011 12:12:14 +0100
Message-ID: <1294053134.2016.54.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-29 at 22:20 +0800, Yong Zhang wrote:
> > - * The caller (fork, wakeup) owns TASK_WAKING, ->cpus_allowed is stable.
> > + * The caller (fork, wakeup) owns p->pi_lock, ->cpus_allowed is stable.
> 
> Yes for wakeup, but not true for fork.
> I don't see protection in wake_up_new_task().
> Or am I missing something? 

Ah, true, wake_up_new_task() holds task_rq_lock() which is sufficient,
but yes, we could also make that pi_lock.


