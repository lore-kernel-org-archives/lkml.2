Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1AHRY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 12:24:58 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61178 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1AHRY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 12:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MCwW7WOgXZ/tJ4Sc2xK/Lt2o51EDaBne11bez5hOHbJXCqk9W/Vbaktj0QyhdIai3B
         UuKYfYjpzjI4JjRjF0CFGKK0sNRIFVCPedarkoUAcGa0APwPNwqmK7IHVL7bj5ijFIka
         TVVlroUEpg0yBopeC7FyEaK+N2w05tJE4B+nc=
Date: Sat, 8 Jan 2011 12:24:53 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
Message-ID: <20110108172453.GF13269@mtj.dyndns.org>
References: <20110106204513.669098445@linux.com>
 <20110106204525.222395863@linux.com>
 <4D263C91.30709@zytor.com>
 <alpine.DEB.2.00.1101070907060.3014@router.home>
 <20110107180419.GB23082@Krystal>
 <alpine.DEB.2.00.1101071227450.3014@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101071227450.3014@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 07, 2011 at 12:41:58PM -0600, Christoph Lameter wrote:
> On Fri, 7 Jan 2011, Mathieu Desnoyers wrote:
> 
> > I have to admit that I also hate the current interface for two reasons:

Call me weird but I like this one than others.  It sure is ugly but
the operation itself isn't a particularly pretty so it kinda matches.
Also, this one is the least error prone and more consistent with other
cpu ops.

> > b) the loss of the value read (the fact that the only current user of this API
> >    does not need the value returned seems like a very weak argument to define an
> >    API).
> 
> The other user of cmpxchg_double that I have in my tree also does not have
> the need. Repeatability is not as simple to implement as with a single
> word cmpxchg.

Yeah, even in regular cmpxchg, the read value on failure isn't of very
high value.  The cpu usually has to go retry anyway && likely to have
the cacheline already, so it's not gonna cost much.

So, yeah, of the proposed ones, this is my favorite.  Peter and
Mathieu don't like it.  What do others think?  Pekka, Eric, Andrew,
what do you guys think?

Thanks.

-- 
tejun
