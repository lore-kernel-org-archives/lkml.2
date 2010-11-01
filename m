Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab0KASN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:13:27 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19576 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab0KASNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:13:25 -0400
Date: Mon, 1 Nov 2010 19:02:53 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Jens Axboe <axboe@kernel.dk>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
        Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Optimize relay_alloc_page_array() slightly by using
 vzalloc rather than vmalloc and memset
In-Reply-To: <20101101160030.GA7638@Krystal>
Message-ID: <alpine.LNX.2.00.1011011900500.9616@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net> <20101030214704.GA20005@Krystal> <4CCEB723.2010005@kernel.dk> <20101101130842.GA24605@Krystal> <AANLkTinZaSchq6UKUkiaFTrmdHMpY7x4uN886r7iXeYU@mail.gmail.com> <4CCEC3B9.1060703@kernel.dk>
 <20101101160030.GA7638@Krystal>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Mathieu Desnoyers wrote:

> * Jens Axboe (axboe@kernel.dk) wrote:
> > On 2010-11-01 09:41, Pekka Enberg wrote:
> > > * Jens Axboe (axboe@kernel.dk) wrote:
> > >>> On 2010-10-30 17:47, Mathieu Desnoyers wrote:
> > >>>> BLK_DEV_IO_TRACE seems to still select RELAY. Has it completed its
> > >>>> transition to either Ftrace or Perf ? Depending on Jens, moving blktrace
> > >>>> relay dependency to the Generic Ring Buffer Library might be a good
> > >>>> option to consider.
> > >>>
> > >>> The blktrace user bits is still (by far) the most wide spread way that
> > >>> blktrace is used in the field, and those still rely on relayfs. So no,
> > >>> we can't kill it now.
> > > 
> > > On Mon, Nov 1, 2010 at 3:08 PM, Mathieu Desnoyers
> > > <mathieu.desnoyers@polymtl.ca> wrote:
> > >> What I am proposing is that the Generic Ring Buffer Library could
> > >> replace relayfs without changing any of the interfaces blktrace exposes
> > >> to user-space. Indeed, I would not remove relayfs unless there was a
> > >> replacement.
> > > 
> > > We don't in general NAK cleanups because of future features or
> > > removals that may or may not happen.
> > 
> > Agree, this is parallel to whether or not we can transition blktrace to
> > using the generic ring buffer library or not. If the current patch
> > proposed makes sense, then it should go in regardless of
> > potential/future plans.
> 
> Agreed. Thanks,
> 

As I read the discussion over the last day or so, since I last checked my 
mail, there are no longer any objections to the patch. Correct?
If that's the case, who will merge it? and should I resend it with various 
peoples Acked-by: lines? or?


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

