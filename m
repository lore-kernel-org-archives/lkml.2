Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab2IZOAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:00:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14392 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab2IZN77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:59:59 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=LrhBLfKaQO8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=SlKO6I3lSDoA:10 a=vGTJrHkHN-MZZtNr4fIA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348667992.22822.50.camel@gandalf.local.home>
Subject: Re: [PATCH v6] hashtable: introduce a small and naive hashtable
From: Steven Rostedt <rostedt@goodmis.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Sasha Levin <levinsasha928@gmail.com>, torvalds@linux-foundation.org,
        tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, mathieu.desnoyers@efficios.com, neilb@suse.de,
        bfields@fieldses.org, ejt@redhat.com, snitzer@redhat.com,
        edumazet@google.com, josh@joshtriplett.org, rmallon@gmail.com,
        palves@redhat.com
Date: Wed, 26 Sep 2012 09:59:52 -0400
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com>
References: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 14:45 +0100, David Laight wrote:
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

Probably would be cleaner to do so.


> Also, should the loop have a 'break' in it?

Yeah it should, and could do:

	for (i = 0; i < HASH_SIZE(hashtable); i++)
		if (!hlist_empty(&hashtable[i]))
			break;

	return i < HASH_SIZE(hashtable);

-- Steve


