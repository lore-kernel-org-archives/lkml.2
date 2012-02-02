Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab2BBN4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:56:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40518 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab2BBN4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:56:18 -0500
Date: Thu, 2 Feb 2012 14:56:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Tim Hockin <thockin@hockin.org>, Tejun Heo <htejun@gmail.com>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Max Kellermann <mk@cm4all.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 01/10] cgroups: add res_counter_write_u64() API
Message-ID: <20120202135609.GB9071@somewhere.redhat.com>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
 <1328067470-5980-2-git-send-email-fweisbec@gmail.com>
 <20120202123322.GA12748@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202123322.GA12748@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 02:33:22PM +0200, Kirill A. Shutemov wrote:
> On Wed, Feb 01, 2012 at 04:37:41AM +0100, Frederic Weisbecker wrote:
> > +#if BITS_PER_LONG == 32
> > +void res_counter_write_u64(struct res_counter *counter, int member, u64 val)
> > +{
> > +	unsigned long long *target;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&counter->lock, flags);
> > +	target = res_counter_member(counter, member);
> > +	*target = val;
> 
> Nitpick: What's the point to have temporary variable here?

Dunno, just a matter of habit, I use to avoid expressions
like *func(foo) = bar. It looks less readable to me but
perhaps it's because I'm not used to it.

> 
> > +	spin_unlock_irqrestore(&counter->lock, flags);
> > +}
> > +#else
> > +void res_counter_write_u64(struct res_counter *counter, int member, u64 val)
> > +{
> > +	unsigned long long *target;
> > +
> > +	target = res_counter_member(counter, member);
> > +	*target = val;
> 
> Ditto.
> 
> > +}
> > +#endif
> 
> -- 
>  Kirill A. Shutemov
