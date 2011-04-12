Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab1DLVO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:14:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35423 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab1DLVO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:14:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vs3TZRDjh5Umy+O39HnPClCLc4lq+2nkmRtnmD05wNQN+v1e+mZahmktaUkdt//KZQ
         3sEhePdSwWlJqZPCl51YVNCL3SHSFikSWIoSYnU8rOMN+k0V//lCMyCiRFcua/v1XIli
         z/3gVNefOMnykCqb1x3mvfhApmrzbu+9Eo4Lw=
Date: Wed, 13 Apr 2011 00:14:53 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        behlendorf1@llnl.gov, oleg@redhat.com
Subject: Re: [PATCH] remove abs64()
Message-ID: <20110412211452.GA20135@p183>
References: <20110412210045.GA19901@p183>
 <20110412140726.3f4f2a7b.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412140726.3f4f2a7b.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 02:07:26PM -0700, Randy Dunlap wrote:
> On Wed, 13 Apr 2011 00:00:45 +0300 Alexey Dobriyan wrote:
> 
> > We don't need no stinking abs64() given some GCC extensions
> > (especially __builtin_choose_expr()).
> > 
> > One abs() implementation is better than two abs() implementations.
> 
> questionable.

Come on, what's so special in 64-bit types?

> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h

> > -#define abs64(x) ({				\
> > -		s64 __x = (x);			\
> > -		(__x < 0) ? -__x : __x;		\
> > -	})
> > +#define abs(x)								\
> > +({									\
> > +	typeof(x) _x = (x);						\
> > +									\
> > +	__builtin_choose_expr(						\
> > +		__builtin_types_compatible_p(typeof(_x), signed char),	\
> > +		(unsigned char)({ _x < 0 ? -_x : _x; }),		\

> that is better?

Infinitely better.
sizeof(abs(x)) == sizeof(x) for one thing.

Implementation is ugly, but, hey, one can't do better in C.

