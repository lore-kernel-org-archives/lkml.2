Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab0GBPMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 11:12:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53809 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab0GBPL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 11:11:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C2E0147.1090702@s5r6.in-berlin.de>
Date: Fri, 02 Jul 2010 17:09:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: David Howells <dhowells@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
       dwalker@codeaurora.org, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/4] async: use workqueue for worker pool
References: <4C2A2688.1020206@kernel.org> <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <25085.1277847455@redhat.com> <4C2DAEBB.7090607@kernel.org> <4C2DB084.5040205@gmail.com>
In-Reply-To: <4C2DB084.5040205@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Replace private worker pool with system_long_wq.

system_unbound_wq actually.

> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -49,40 +49,32 @@ asynchronous and synchronous parts of the kernel.
>  */
> 
>  #include <linux/async.h>
> -#include <linux/bug.h>
>  #include <linux/module.h>
>  #include <linux/wait.h>
>  #include <linux/sched.h>
> -#include <linux/init.h>
> -#include <linux/kthread.h>
> -#include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <asm/atomic.h>
> 

Shouldn't it include linux/workqueue.h now?
-- 
Stefan Richter
-=====-==-=- -=== ---=-
http://arcgraph.de/sr/
