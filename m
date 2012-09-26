Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab2IZOba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:31:30 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58059 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751457Ab2IZOb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:31:29 -0400
Date: Wed, 26 Sep 2012 10:31:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Sasha Levin <levinsasha928@gmail.com>, torvalds@linux-foundation.org,
        tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, ebiederm@xmission.com, neilb@suse.de,
        bfields@fieldses.org, ejt@redhat.com, snitzer@redhat.com,
        edumazet@google.com, josh@joshtriplett.org, rmallon@gmail.com,
        palves@redhat.com
Subject: Re: [PATCH v6] hashtable: introduce a small and naive hashtable
Message-ID: <20120926143126.GA22699@Krystal>
References: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Laight (David.Laight@ACULAB.COM) wrote:
> Amazing how something simple gets lots of comments and versions :-)
> 
> > ...
> > + * This has to be a macro since HASH_BITS() will not work on pointers since
> > + * it calculates the size during preprocessing.
> > + */
> > +#define hash_empty(hashtable)							\
> > +({										\
> > +	int __i;								\
> > +	bool __ret = true;							\
> > +										\
> > +	for (__i = 0; __i < HASH_SIZE(hashtable); __i++)			\
> > +		if (!hlist_empty(&hashtable[__i]))				\
> > +			__ret = false;						\
> > +										\
> > +	__ret;									\
> > +})
> 
> Actually you could have a #define that calls a function
> passing in the address and size.
> Also, should the loop have a 'break' in it?

+1   Removing unnecessary variables defined within a
statement-expression is indeed something we want, and your suggestion of
a macro calling a static inline is, IMHO, spot-on.

The same should be done for hash_init().

And yes, a break would be welcome in that loop: no need to continue if
we encounter a non-empty hlist.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
