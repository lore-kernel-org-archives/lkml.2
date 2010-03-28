Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab0C1S3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 14:29:14 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60596 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754841Ab0C1S3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 14:29:13 -0400
Date: Sun, 28 Mar 2010 14:29:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Imre Deak <imre.deak@nokia.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Alexander Shishkin <virtuoso@slind.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] create generic alignment api (v2)
Message-ID: <20100328182910.GA13135@Krystal>
References: <20100328012247.GA17763@Krystal> <20100328154029.GA21061@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100328154029.GA21061@localhost>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:28:08 up 64 days, 21:05,  4 users,  load average: 0.13, 0.08,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Imre Deak (imre.deak@nokia.com) wrote:
> On Sun, Mar 28, 2010 at 03:22:47AM +0200, ext Mathieu Desnoyers wrote:
> >  [...]
> > +/**
> > + * offset_align - Calculate the offset needed to align an object on its natural
> > + *                alignment towards higher addresses.
> > + * @align_drift:  object offset from an "alignment"-aligned address.
> > + * @alignment:    natural object alignment. Must be non-zero, power of 2.
> > + *
> > + * Returns the offset that must be added to align towards higher
> > + * addresses.
> > + */
> > +static inline size_t offset_align(size_t align_drift, size_t alignment)
> > +{
> > +	return (alignment - align_drift) & (alignment - 1);
> > +}
> > +
> > +/**
> > + * offset_align_floor - Calculate the offset needed to align an object
> > + *                      on its natural alignment towards lower addresses.
> > + * @align_drift:  object offset from an "alignment"-aligned address.
> > + * @alignment:    natural object alignment. Must be non-zero, power of 2.
> > + *
> > + * Returns the offset that must be substracted to align towards lower addresses.
> > + */
> > +static inline size_t offset_align_floor(size_t align_drift, size_t alignment)
> > +{
> > +	return (align_drift - alignment) & (alignment - 1);
> > +}
> > +
> > +#define object_align(object)						       \
> > +	((typeof(object))((size_t) object + offset_align((size_t) object,      \
> > +			  sizeof(object))))
> > +
> > +#define object_align_floor(object)					       \
> > +	((typeof(object))((size_t) object - offset_align_floor((size_t) object,\
> > +			  sizeof(object))))
> > +
> 
> Here object must be a pointer, but then sizeof(object) will result in
> aligning to the arch word size not the object's natural alignment. Is
> this what you intended?

Nope, should be sizeof(*object). Good catch. I did the object_align*() macros
specifically as "helper" functions for your needs.

I'll repost a v3.

Thanks,

Mathieu

> 
> --Imre
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
