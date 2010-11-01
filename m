Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab0KASgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:36:32 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:62571 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092Ab0KASgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:36:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAK+hzkxGGOIS/2dsb2JhbAChXnK/NIVFBI9d
Date: Mon, 1 Nov 2010 14:26:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Jens Axboe <axboe@kernel.dk>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
        Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Optimize relay_alloc_page_array() slightly by using
	vzalloc rather than vmalloc and memset
Message-ID: <20101101182625.GA20005@Krystal>
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net> <20101030214704.GA20005@Krystal> <4CCEB723.2010005@kernel.dk> <20101101130842.GA24605@Krystal> <AANLkTinZaSchq6UKUkiaFTrmdHMpY7x4uN886r7iXeYU@mail.gmail.com> <4CCEC3B9.1060703@kernel.dk> <20101101160030.GA7638@Krystal> <alpine.LNX.2.00.1011011900500.9616@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011011900500.9616@swampdragon.chaosbits.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:25:11 up 208 days,  4:15,  3 users,  load average: 0.13, 0.07,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesper Juhl (jj@chaosbits.net) wrote:
> On Mon, 1 Nov 2010, Mathieu Desnoyers wrote:
> 
> > * Jens Axboe (axboe@kernel.dk) wrote:
> > > On 2010-11-01 09:41, Pekka Enberg wrote:
> > > > * Jens Axboe (axboe@kernel.dk) wrote:
> > > >>> On 2010-10-30 17:47, Mathieu Desnoyers wrote:
> > > >>>> BLK_DEV_IO_TRACE seems to still select RELAY. Has it completed its
> > > >>>> transition to either Ftrace or Perf ? Depending on Jens, moving blktrace
> > > >>>> relay dependency to the Generic Ring Buffer Library might be a good
> > > >>>> option to consider.
> > > >>>
> > > >>> The blktrace user bits is still (by far) the most wide spread way that
> > > >>> blktrace is used in the field, and those still rely on relayfs. So no,
> > > >>> we can't kill it now.
> > > > 
> > > > On Mon, Nov 1, 2010 at 3:08 PM, Mathieu Desnoyers
> > > > <mathieu.desnoyers@polymtl.ca> wrote:
> > > >> What I am proposing is that the Generic Ring Buffer Library could
> > > >> replace relayfs without changing any of the interfaces blktrace exposes
> > > >> to user-space. Indeed, I would not remove relayfs unless there was a
> > > >> replacement.
> > > > 
> > > > We don't in general NAK cleanups because of future features or
> > > > removals that may or may not happen.
> > > 
> > > Agree, this is parallel to whether or not we can transition blktrace to
> > > using the generic ring buffer library or not. If the current patch
> > > proposed makes sense, then it should go in regardless of
> > > potential/future plans.
> > 
> > Agreed. Thanks,
> > 
> 
> As I read the discussion over the last day or so, since I last checked my 
> mail, there are no longer any objections to the patch. Correct?

Yes,

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> If that's the case, who will merge it? and should I resend it with various 
> peoples Acked-by: lines? or?

Yep, this might make the maintainer's work easier, I think. As for who
will merge it, good question. Andrew ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
