Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0LMG0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:26:14 -0500
Received: from tomasu.net ([64.85.170.234]:34360 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab0LMG0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:26:11 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/4] kthread: NUMA aware kthread_create_on_cpu()
Date: Sun, 12 Dec 2010 23:26:05 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36.1+; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
References: <1290972833.29196.90.camel@edumazet-laptop> <1291964561.2803.25.camel@edumazet-laptop> <20101209230937.073fab54.akpm@linux-foundation.org>
In-Reply-To: <20101209230937.073fab54.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012122326.05966.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On December 10, 2010, Andrew Morton wrote:
> On Fri, 10 Dec 2010 08:02:41 +0100 Eric Dumazet <eric.dumazet@gmail.com> 
wrote:
> > Le jeudi 09 d__cembre 2010 __ 22:32 -0800, Andrew Morton a __crit :
> > > but but but.  The name "kthread_create_on_cpu" sucks.  It's plain
> > > wrong.
> > 
> > Okay you are right Andrew ;) I dont have better idea for the moment.
> 
> Dunno.  kthread_create_with_memory_on_node() :)
> 
> How's about kthread_create_for_node()?  That's sufficiently vague to
> not mislead readers into thinking that it schedules the thread on that
> CPU and leaves room in the namespace for a real kthread_create_on_cpu()
> (which we could well end up creating).
> 
> kthread_create_node_mem()?

Just a kernel newb here, how about kthread_create_from_cpu ? unless that has 
some connotations I'm not aware of.

> > Note that all callers I converted really create one kthread per cpu, not
> > per node. They didnt care of node affinity, only me :)
> > 
> > kthread_create_on_node() seems misleading to me (some cpus run on
> > memoryless nodes)
> 
> True, but what we're doing here is specifying on which node the
> kthread's memory resources should reside - we need to do that even for
> CPUs which live on memoryless nodes.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
