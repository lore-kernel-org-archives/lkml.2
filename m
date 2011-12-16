Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110Ab1LPQBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:01:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44769 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759429Ab1LPQB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:01:29 -0500
Message-ID: <1324051285.25554.37.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] module: struct module_ref should contains long fields
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Robin Holt <holt@sgi.com>
Date: Fri, 16 Dec 2011 17:01:25 +0100
In-Reply-To: <20111216155408.GA31770@google.com>
References: <1324012057.2562.23.camel@edumazet-laptop>
	 <20111216155408.GA31770@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 16 décembre 2011 à 07:54 -0800, Tejun Heo a écrit :
> Hello, Eric.
> 
> On Fri, Dec 16, 2011 at 06:07:37AM +0100, Eric Dumazet wrote:
> > +struct module_ref {
> > +	unsigned long incs;
> > +	unsigned long decs;
> > +} __attribute((aligned(2 * sizeof(unsigned long))));
> 
> Why not ____cacheline_aligned?  Another thing is that for percpu
> memory, packing could be better or at least shouldn't be worse.
> Percpu area usages are likely to be local so one major benefit of
> cacheline alignment - avoiding cacheline pingpong - goes away.  The
> constant is called SMP_CACHE_BYTES after all.

Its percpu data, there is no need to waste a full cache line per cpu for
this.

This is only a hint to make sure one single cache line is touched if a
thread increments/decrements a module refcount, with no memory extra
cost : We play with the alignement of this 8 or 16 bytes block.



