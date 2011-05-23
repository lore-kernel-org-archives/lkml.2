Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030977Ab1EWWUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:20:51 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:50794 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab1EWWUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:20:50 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Tue, 24 May 2011 00:20:40 +0200
In-Reply-To: <20110523153848.GC2310@linux.vnet.ibm.com>
References: <20110519222404.GG12600@redhat.com>
	 <20110521210013.GJ2271@linux.vnet.ibm.com>
	 <20110523152141.GB4019@redhat.com>
	 <20110523153848.GC2310@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306189249.15900.10.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 08:38 -0700, Paul E. McKenney wrote:
> Running under CONFIG_PREEMPT=y (along with CONFIG_TREE_PREEMPT_RCU=y)
> could be very helpful in and of itself.  CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> can also be helpful.  In post-2.6.39 mainline, it should be possible
> to set CONFIG_DEBUG_OBJECTS_RCU_HEAD=y without CONFIG_PREEMPT=y, but
> again, CONFIG_PREEMPT=y can help find problems.

0) The first thing I tried (from your suggestions) was
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y. Given its dependencies (and, well, the
build system I used) I ended up with:

    $ grep -e PREEMPT -e RCU /boot/config-2.6.39-0.local3.fc16.i686 |
    grep -v "^#"
    CONFIG_TREE_PREEMPT_RCU=y
    CONFIG_PREEMPT_RCU=y
    CONFIG_RCU_FANOUT=32
    CONFIG_PREEMPT_NOTIFIERS=y
    CONFIG_PREEMPT=y
    CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
    CONFIG_DEBUG_PREEMPT=y
    CONFIG_PROVE_RCU=y
    CONFIG_SPARSE_RCU_POINTER=y

It looks like I am unable to trigger the issue we're talking about here
when using that config.

1) For reference, the config of a kernel that does trigger it had:

    $ grep -e PREEMPT -e RCU /boot/config-2.6.39-0.local2.fc16.i686 |
    grep -v "^#"
    CONFIG_TREE_RCU=y
    CONFIG_RCU_FANOUT=32
    CONFIG_RCU_FAST_NO_HZ=y
    CONFIG_PREEMPT_NOTIFIERS=y
    CONFIG_PREEMPT_VOLUNTARY=y
    CONFIG_PROVE_RCU=y
    CONFIG_SPARSE_RCU_POINTER=y

> > Again CONFIG_TREE_PREEMPT_RCU is available only if PREEMPT=y. So should
> > we enable preemtion and CONFIG_TREE_PREEMPT_RCU=y and try to reproduce
> > the issue?
> 
> Please!

2) It appears I can't reproduce with those options enabled (see above).

> Polling is fine.  Please see attached for a script to poll at 15-second
> intervals.  Please also feel free to adjust, just tell me what you
> adjusted.

And should I now try to run that script on a config that triggers this
issue (such as the config under 1) above)?


Paul Bolle

