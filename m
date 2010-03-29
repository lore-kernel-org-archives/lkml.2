Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0C2VnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:43:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34917 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0C2VnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:43:04 -0400
Subject: Re: [PATCH tip/core/urgent] rcu: protect fork-time cgroup access
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       abogani@texware.it
In-Reply-To: <20100329213405.GA18143@linux.vnet.ibm.com>
References: <20100329211525.GA17703@linux.vnet.ibm.com>
	 <1269897564.12097.372.camel@laptop>
	 <20100329212932.GO2569@linux.vnet.ibm.com>
	 <20100329213405.GA18143@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 23:42:55 +0200
Message-ID: <1269898975.12097.380.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 14:34 -0700, Paul E. McKenney wrote:

> And it appears that my patch is at best insufficient:
> http://paste.ubuntu.com/406189/
> 
> Left to myself, I would wrap copy_process() with rcu_read_lock(),
> but I would rather hear your thoughts before doing too much more
> semi-random hacking.  ;-)

Well, I don't think you can get away with that, copy_process() wants to
sleep on quite a few places ;-) Also, locks should be taken at the
smallest possible scope, unless we want to go back to BKL style
locking :-)

As to that freezer splat, you'd have to chase down the cgroup folks, I'm
fully ignorant on that.

For the set_task_rq() one, I'm afraid someone (which again I'm afraid
will be me) will have to look into how the task_group muck ties into the
cgroup muck as I think the original authors of that ran off :/



