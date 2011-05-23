Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab1EWPgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:36:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab1EWPgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:36:07 -0400
Date: Mon, 23 May 2011 11:36:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Paul Bolle <pebolle@tiscali.nl>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
Message-ID: <20110523153602.GC4019@redhat.com>
References: <20110519222404.GG12600@redhat.com>
 <20110521210013.GJ2271@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110521210013.GJ2271@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 02:00:13PM -0700, Paul E. McKenney wrote:

[..]
> > Is there any known issue or is there any quick tip on how can I 
> > go about debugging it further from rcu point of view.
> 
> First for uses of RCU:
> 
> o	One thing to try would be CONFIG_PROVE_RCU, which could help
> 	find missing rcu_read_lock()s and similar.  Some years back, it
> 	used to be the case that spin_lock() implied rcu_read_lock(),
> 	but it no longer does.	There might still be some cases where
> 	spin_lock() needs to have an rcu_read_lock() added.

In this case we take explicit rcu_read_lock() in call_for_each_cic()
and do not rely on that spin_lock() also means rcu_read_lock().

call_for_each_cic() {
	rcu_read_lock();
	 hlist_for_each_entry_rcu(cic, n, &ioc->cic_list, cic_list)
                func(ioc, cic);
        rcu_read_unlock();
}

> 
> o	There are a few entries in the bugzilla mentioning that elements
> 	are being removed more often than expected.

Are you referring to my comments about additional messages of cgroup
changed. If yes, that issue has now been identified and I have posted
a fix to get rid of thos unnecessary calls.

https://lkml.org/lkml/2011/5/23/201

Is still there a need to enable CONFIG_DEBUG_OBJECTS_RCU_HEAD as the
kernel in question is non-preemptible one.

Thanks
Vivek
