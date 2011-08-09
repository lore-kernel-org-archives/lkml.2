Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab1HIRba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:31:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61608 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1HIRb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:31:29 -0400
Date: Tue, 9 Aug 2011 19:31:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 1/8] cgroups: Add res_counter_write_u64() API
Message-ID: <20110809173117.GB31645@somewhere.redhat.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <1311956010-32076-2-git-send-email-fweisbec@gmail.com>
 <20110809151739.GB15311@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809151739.GB15311@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 05:17:39PM +0200, Oleg Nesterov wrote:
> On 07/29, Frederic Weisbecker wrote:
> >
> > +void res_counter_write_u64(struct res_counter *counter, int member, u64 val)
> > +{
> > +	unsigned long long *target;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&counter->lock, flags);
> > +	target = res_counter_member(counter, member);
> > +	*target = val;
> > +	spin_unlock_irqrestore(&counter->lock, flags);
> > +}
> 
> Hmm. Why do we need counter->lock?
> 
> OK, probably it is for BITS_PER_LONG < 64. May be it makes sense
> to ifdef, just to make the code more understandable.

Ok, will add that.
