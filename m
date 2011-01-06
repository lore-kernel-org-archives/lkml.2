Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1AFOXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 09:23:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:57880 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1AFOXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 09:23:39 -0500
Subject: Re: [RFC][PATCH 07/18] sched: Drop the rq argument to
 sched_class::select_task_rq()
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1294322260.2016.332.camel@laptop>
References: <20110104145929.772813816@chello.nl>
	 <20110104150102.661650041@chello.nl>  <1294322260.2016.332.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 06 Jan 2011 15:23:51 +0100
Message-ID: <1294323831.2016.334.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 14:57 +0100, Peter Zijlstra wrote:
> +       curr = rcu_dereference(rq->curr); /* unlocked access */

Hrm, I got my barriers wrong again, I think we can go with ACCESS_ONCE()
here.
