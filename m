Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab1ACLVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:21:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:60655 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab1ACLVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:21:44 -0500
Subject: Re: [RFC][PATCH 17/17] sched: Sort hotplug vs ttwu queueing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
In-Reply-To: <20101229145153.GE2728@zhy>
References: <20101224122338.172750730@chello.nl>
	 <20101224123743.353816314@chello.nl>  <20101229145153.GE2728@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Jan 2011 12:21:36 +0100
Message-ID: <1294053696.2016.64.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-29 at 22:51 +0800, Yong Zhang wrote:
> > +     rq = this_rq(); /* always enqueue locally */
> 
> But it's possible that p is not allowed to run on this cpu,
> right?
> 
> 
Very good point, yes I totally forgot about that.. stupid
->cpus_allowed.

OK, I guess we need a new select_task_rq() call in the offline case..
