Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2AXKYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 05:24:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:40821 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab2AXKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 05:23:59 -0500
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
 condition
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Yasunori Goto <y-goto@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <4EFB8523.6080708@gmail.com>
References: <1324633794.24803.48.camel@twins>
	 <20111223154137.GA27901@redhat.com>
	 <20111226172357.CE4D.E1E9C6FF@jp.fujitsu.com>
	 <20111226171151.GA4472@redhat.com>  <4EFB8523.6080708@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Jan 2012 11:23:38 +0100
Message-ID: <1327400618.2614.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-28 at 16:07 -0500, KOSAKI Motohiro wrote:
> I looked at scheduler code today briefly. now I'm afraid following code 
> have similar race.
> 
> 
>          if (task_contributes_to_load(p))
>                  rq->nr_uninterruptible--;
> 
> 
> 
> Can't following schenario be happen?
> 
> 
> CPU0                    CPU1
> --------------------------------------------------------
> deactivate_task()
>                         task->state = TASK_UNINTERRUPTIBLE;
> activate_task()
>    rq->nr_uninterruptible--;
> 
>                         schedule()
>                           deactivate_task()
>                             rq->nr_uninterruptible++;
> 
> Totally, nr_uninterruptible wasn't incremented.
> 
> 
> I'm still not sure. I need to read more sched code. 

You shouldn't ever set another tasks ->state. 

