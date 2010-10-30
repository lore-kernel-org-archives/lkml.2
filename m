Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab0J3WA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 18:00:26 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12154 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0J3WAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:00:23 -0400
Date: Sat, 30 Oct 2010 23:50:04 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
        Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Optimize relay_alloc_page_array() slightly by using
 vzalloc rather than vmalloc and memset
In-Reply-To: <20101030214704.GA20005@Krystal>
Message-ID: <alpine.LNX.2.00.1010302343590.1572@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net> <20101030214704.GA20005@Krystal>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Oct 2010, Mathieu Desnoyers wrote:

> * Jesper Juhl (jj@chaosbits.net) wrote:
> > Hi,
> > 
> > We can optimize kernel/relay.c::relay_alloc_page_array() slightly by using 
> > vzalloc. The patch makes these changes:
> > 
> >  - use vzalloc instead of vmalloc+memset.
> >  - remove redundant local variable 'array'.
> >  - declare local 'pa_size' as const.
> 
> Hrm ? How does declaring a local variable as const helps the compiler in
> any way ?
> 

Hmm, probably not very much in this case (but it doesn't hurt either ;) - 
actually, removing the const yielded the exact same result, so it's 
"not at all" in this case). 
That bit came from my "build-in" tendency to declare stuff const when it 
obviously doesn't change/nor should. It's a habbit..


> Moreover, is there anyone still using this code ? LTTng uses the Generic
> Ring Buffer library which completely deprecates relay.c. Perf and Ftrace
> each have their own ring buffers, without dependency on relay.c.
> 
> BLK_DEV_IO_TRACE seems to still select RELAY. Has it completed its
> transition to either Ftrace or Perf ? Depending on Jens, moving blktrace
> relay dependency to the Generic Ring Buffer Library might be a good
> option to consider.
> 

I admit I have no idea if this code is actually still used, but as long as 
it's in the kernel I think we should strive to make it as good as possible 
- no? If there are still users this is an improvement, if there are no 
users (who knows if there are out-of-tree ones?) then it should probably 
just go away (but even then this patch does no harm - except for a bit of 
churn).


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

