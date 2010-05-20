Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0ETHE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:04:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62166 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab0ETHE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:04:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oCS1S3JKT/sbv8mFi8FvOBeRPn3iAqnczYjhv7cA2Z5NB0MY7hZ/UGhuMB+klnpv8r
         BccJuWI9GkeU5mY7YCWFbrLsvj+hfxXYag9DMYfpQdpvTi1ib9rqZF9YuIVKKe/X7LQJ
         Hgeip6B+OqIct6MQGJbhWMQRupzmkRpKIE9IY=
Date: Thu, 20 May 2010 09:04:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       acme@redhat.com
Subject: Re: [PATCH RFC] perf: fix find_swevent_head() RCU lockdep splat
Message-ID: <20100520070433.GC5309@nowhere>
References: <20100513182556.GA14326@linux.vnet.ibm.com> <20100513190325.GB5377@nowhere> <1273823064.5605.3599.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273823064.5605.3599.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 09:44:24AM +0200, Peter Zijlstra wrote:
> On Thu, 2010-05-13 at 21:03 +0200, Frederic Weisbecker wrote:
> > hlist = rcu_dereference_check(ctx->swevent_hlist,
> >                               rcu_read_lock_held() ||
> >                               raw_spin_lock_is_held(&ctx->lock)); 
> 
> raw_spin_lock_is_held() is wrong, that should read:
> lockdep_is_held(&ctx->lock).
> 
> raw_spin_lock_is_held() only checks if the lock is locked,
> lockdep_is_held() ensures we are the one holding it.


Right!

Thanks.

