Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031651Ab2COQS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:18:56 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47586 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031251Ab2COQSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:18:52 -0400
Subject: Re: [PATCH 5/7] module: take rcu_read_lock_sched() for /proc read
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dennis1.Chen@amd.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alexander Viro <viro@zeniv.linux.org.uk>, NeilBrown <neilb@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <1331822941-19938-5-git-send-email-xiyou.wangcong@gmail.com>
References: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
	 <1331822941-19938-5-git-send-email-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 09:18:49 -0700
Message-ID: <1331828329.4874.7.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 22:48 +0800, Cong Wang wrote:
> In the seq file operations, it still hold module_mutex for just reading
> the module list, switch to rcu_read_lock_sched() too.
> 

Why is it needed ?

1) insmod/rmmod/lsmod is hardly in fast path.

2) after a mutex_lock(), a task is still preemptible
   after rcu_read_lock_sched(), preemption is disabled

   with NR_CPUS=4096, getting module refcounts is _very_ slow

RCU doesnt fit every workload.



