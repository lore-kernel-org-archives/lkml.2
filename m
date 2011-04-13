Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab1DMSsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:48:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757037Ab1DMSsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:48:18 -0400
Date: Wed, 13 Apr 2011 11:48:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        behlendorf1@llnl.gov
Subject: Re: [PATCH] remove abs64()
Message-Id: <20110413114808.12783565.akpm@linux-foundation.org>
In-Reply-To: <20110413142703.GA1511@redhat.com>
References: <20110412210045.GA19901@p183>
	<20110413142703.GA1511@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 16:27:03 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/13, Alexey Dobriyan wrote:
> >
> > +#define abs(x)								\
> > +({									\
> > +	typeof(x) _x = (x);						\
> > +									\
> > +	__builtin_choose_expr(						\
> > +		__builtin_types_compatible_p(typeof(_x), signed char),	\
> > +		(unsigned char)({ _x < 0 ? -_x : _x; }),		\
> > +	__builtin_choose_expr(						\
> > +		__builtin_types_compatible_p(typeof(_x), short),	\
> > +		(unsigned short)({ _x < 0 ? -_x : _x; }),		\
> > +	__builtin_choose_expr(						\
> > +		__builtin_types_compatible_p(typeof(_x), int),		\
> > +		(unsigned int)({ _x < 0 ? -_x : _x; }),			\
> > +	__builtin_choose_expr(						\
> > +		__builtin_types_compatible_p(typeof(_x), long),		\
> > +		(unsigned long)({ _x < 0 ? -_x : _x; }),		\
> > +	__builtin_choose_expr(						\
> > +		__builtin_types_compatible_p(typeof(_x), long long),	\
> > +		(unsigned long long)({ _x < 0 ? -_x : _x; }),		\
> > +	_x)))));							\
> > +})
> 
> Personally I agree.
> 
> But, we have some stupid users which do something like abs(u32_value)
> and expecting that abs() should treat this value as "signed".
> 

um, yes, I'd forgotten that one.  That's a show-stopper.
