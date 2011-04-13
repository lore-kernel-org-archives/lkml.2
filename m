Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab1DMTLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:11:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42745 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab1DMTLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:11:40 -0400
Subject: Re: [PATCH 04/21] sched: Change the ttwu success details
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110413183955.GA3403@mtj.dyndns.org>
References: <20110405152338.692966333@chello.nl>
	 <20110405152728.866866929@chello.nl> <1302686630.2388.125.camel@twins>
	 <1302691703.2035.10.camel@laptop> <1302692799.2035.17.camel@laptop>
	 <20110413183955.GA3403@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Apr 2011 21:11:09 +0200
Message-ID: <1302721869.2388.127.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 03:39 +0900, Tejun Heo wrote:
> One way to deal with it would be adding an extra worker flag to track
> sleep state from workqueue side so that it can filter out spurious
> wakeups; however, I think it would be far better to resolve this from
> scheduler side.  If the callback name is misleading, rename it to
> wq_worker_sched_activated() or something and call it only when the
> task gets activated. 

Right, what I did is move the thing near activate_task() instead of
relying on any passing on of that information.
