Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1DMCmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 22:42:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:60545 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab1DMCmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 22:42:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,201,1301900400"; 
   d="scan'208";a="732581932"
Subject: Re: [PATCH 3/4]percpu_counter: fix code for 32bit systems
From: Shaohua Li <shaohua.li@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "tj@kernel.org" <tj@kernel.org>
In-Reply-To: <1302661927.2811.18.camel@edumazet-laptop>
References: <1302595444.3981.129.camel@sli10-conroe>
	 <1302599035.3233.27.camel@edumazet-laptop>
	 <1302656465.3981.133.camel@sli10-conroe>
	 <1302661927.2811.18.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 10:41:57 +0800
Message-ID: <1302662517.3981.161.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 10:32 +0800, Eric Dumazet wrote:
> Le mercredi 13 avril 2011 à 09:01 +0800, Shaohua Li a écrit :
> > On Tue, 2011-04-12 at 17:03 +0800, Eric Dumazet wrote:
> > > 
> > > Hmm... did you test this with LOCKDEP on ?
> > > 
> > > You add a possible deadlock here.
> > > 
> > > Hint : Some percpu_counter are used from irq context.
> > there are some places we didn't disable interrupt, for example
> > percpu_counter_add. So the API isn't irq safe to me.
> > 
> 
> So what ? Callers must disable IRQ before calling percpu_counter_add(),
> and they actually do in network stack. Please check again,
> tcp_sockets_allocated for example.
Did you check other code? for example, __vm_enough_memory() doesn't
disable IRQ before calling percpu_counter_add().

> > > This interface assumes caller take the appropriate locking.
> > no comments say this, and some places we don't hold locking.
> > for example, meminfo_proc_show.
> > 
> 
> This doesnt answer my question about LOCKDEP ;)
> 
> Just fix the few callers that might need a fix, since this is the only
> way to deal with potential problems without adding performance penalty
> (for stable trees)
I mean the interface doesn't assume caller should take locking. Since
there isn't locking taking, we should make the interface itself correct,
instead of fixing caller.

