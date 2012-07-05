Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2GESUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:20:00 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57256 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834Ab2GEST6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:19:58 -0400
X-Sasl-enc: QXoYuphoxsE7kwq/hmwO0Uz8P9689veKxW+SUpIDgKpU 1341512397
Date: Thu, 5 Jul 2012 11:19:56 -0700
From: Greg KH <greg@kroah.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
        zakir@umich.edu, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net
Subject: Re: [PATCH 02/10] random: use lockless techniques when mixing
 entropy pools
Message-ID: <20120705181956.GA16846@kroah.com>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <1341511933-11169-3-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341511933-11169-3-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 02:12:05PM -0400, Theodore Ts'o wrote:
> The real-time Linux folks didn't like add_interrupt_randomness()
> taking a spinlock since it is called in the low-level interrupt
> routine.  Using atomic_t's and cmpxchg is also too expensive on some
> of the older architectures.  So we'll bite the bullet and use
> ACCESS_ONCE() and smp_rmb()/smp_wmb() to minimize the race windows
> when mixing in the entropy pool.
> 
> Also, we will use a trylock when trying to increase then entropy
> accounting during the interrupt path to avoid taking a spinlock there;
> if there is contention, we will simply not credit the entropy count,
> thus failing safe.  Thanks to Dan Carpenter for suggesting this
> approach.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---

Any reason you don't want this backported to the -stable series?

