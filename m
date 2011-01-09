Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab1AIIds (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 03:33:48 -0500
Received: from freeflow.nu ([178.79.134.28]:57882 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab1AIIdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 03:33:47 -0500
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
From: Pekka Enberg <penberg@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20110108172453.GF13269@mtj.dyndns.org>
References: <20110106204513.669098445@linux.com>
	 <20110106204525.222395863@linux.com> <4D263C91.30709@zytor.com>
	 <alpine.DEB.2.00.1101070907060.3014@router.home>
	 <20110107180419.GB23082@Krystal>
	 <alpine.DEB.2.00.1101071227450.3014@router.home>
	 <20110108172453.GF13269@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sun, 09 Jan 2011 10:33:43 +0200
Message-ID: <1294562023.5248.120.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-08 at 12:24 -0500, Tejun Heo wrote:
> Hello,
> 
> On Fri, Jan 07, 2011 at 12:41:58PM -0600, Christoph Lameter wrote:
> > On Fri, 7 Jan 2011, Mathieu Desnoyers wrote:
> > 
> > > I have to admit that I also hate the current interface for two reasons:
> 
> Call me weird but I like this one than others.  It sure is ugly but
> the operation itself isn't a particularly pretty so it kinda matches.
> Also, this one is the least error prone and more consistent with other
> cpu ops.
> 
> > > b) the loss of the value read (the fact that the only current user of this API
> > >    does not need the value returned seems like a very weak argument to define an
> > >    API).
> > 
> > The other user of cmpxchg_double that I have in my tree also does not have
> > the need. Repeatability is not as simple to implement as with a single
> > word cmpxchg.
> 
> Yeah, even in regular cmpxchg, the read value on failure isn't of very
> high value.  The cpu usually has to go retry anyway && likely to have
> the cacheline already, so it's not gonna cost much.
> 
> So, yeah, of the proposed ones, this is my favorite.  Peter and
> Mathieu don't like it.  What do others think?  Pekka, Eric, Andrew,
> what do you guys think?

I'm not a huge fan of the API either but like you, I like it best from
the proposed ones.

			Pekka

