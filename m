Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab1HYNYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:24:11 -0400
Received: from orca.ele.uri.edu ([131.128.51.63]:33402 "EHLO orca.ele.uri.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1HYNYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:24:07 -0400
From: "Will Simoneau" <simoneau@ele.uri.edu>
Date: Thu, 25 Aug 2011 09:20:51 -0400
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, dipankar@in.ibm.com
Subject: Re: 2.6.39.4: Oops in rcu_read_unlock_special()/_raw_spin_lock()
Message-ID: <20110825132051.GA9580@ele.uri.edu>
References: <20110824211907.GA4225@ele.uri.edu>
 <20110824212744.GV2417@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824212744.GV2417@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 [Linux 2.6.38.4 x86_64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:27 Wed 24 Aug     , Paul E. McKenney wrote:
> On Wed, Aug 24, 2011 at 05:19:07PM -0400, Will Simoneau wrote:
> > The below Oops/BUGs were captured on a serial console during a large
> > rsync job. I do not know of a way to reproduce the Oops, I've only seen
> > it once. Some recent changes have been made suspiciously close to the
> > exploding code, which makes me think that maybe 2.6.39-stable is lacking
> > some fixes? The following commits from Linus' git seem vaguely related,
> > although I have no idea how relevant they are to 2.6.39.4:
> > 
> >    ec433f0c (softirq,rcu: Inform RCU of irq_exit() activity)
> >    10f39bb1 (rcu: protect __rcu_read_unlock() against scheduler-using
> >              irq handlers)
> 
> If this failure mechanism really is the culprit, you should be able
> to make failure happen much more frequently by inserting a delay in
> __rcu_read_unlock() just prior to the call to rcu_read_unlock_special().
> I would suggest starting with a few tens to hundreds of microseconds
> worth of delay.
> 
> If this does make the failure reproducible, then it would make sense
> to try applying the two patches you identified.

Hmm. I tried adding progressively larger delays in the spot you
indicated. I went from 100uS to an entire 1S (!) and got no crash or
deadlock. The target runs at 40MHz so the delays do need to be
relatively long compared to modern machines.

My hardware breakpoint as well as printk tests confirm that
rcu_read_unlock_special() really does get called multiple times per
second, and the 1S delay makes it painfully obvious as well. But, no
dice.
