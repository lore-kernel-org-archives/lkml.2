Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2DTFdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 01:33:21 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65009 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2DTFdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 01:33:20 -0400
Date: Fri, 20 Apr 2012 13:26:33 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        netdev@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 1/2] workqueue: Catch more locking problems with
 flush_work()
Message-ID: <20120420052633.GA16219@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1334805958-29119-1-git-send-email-sboyd@codeaurora.org>
 <20120419081002.GB3963@zhy>
 <4F905B30.4080501@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F905B30.4080501@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 11:36:32AM -0700, Stephen Boyd wrote:
> Does looking at the second patch help? Basically schedule_work() can run
> the callback right between the time the mutex is acquired and
> flush_work() is called:
> 
> CPU0                        CPU1
> 
> <irq>
>   schedule_work()           mutex_lock(&mutex)
> <irq return>
>     my_work()               flush_work() 
>       mutex_lock(&mutex)    
>       <deadlock>

Get you point. It is a problem. But your patch could introduece false
positive since when flush_work() is called that very work may finish
running already.

So I think we need the lock_map_acquire()/lock_map_release() only when
the work is under processing, no?

Thanks,
Yong
