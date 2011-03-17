Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1CQV6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:58:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755643Ab1CQV6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:58:15 -0400
Date: Thu, 17 Mar 2011 14:57:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: make checkpatch warn about memset with swapped arguments.
Message-Id: <20110317145730.8e650401.akpm@linux-foundation.org>
In-Reply-To: <20110317213252.GB4084@redhat.com>
References: <20110317045209.GA18656@redhat.com>
	<20110317193645.GD14675@home.goodmis.org>
	<20110317200215.GA4084@redhat.com>
	<1300394224.16880.518.camel@gandalf.stny.rr.com>
	<20110317141108.52697d81.akpm@linux-foundation.org>
	<20110317213252.GB4084@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011 17:32:52 -0400
Dave Jones <davej@redhat.com> wrote:

> On Thu, Mar 17, 2011 at 02:11:08PM -0700, Andrew Morton wrote:
>  
>  > Dave's patch is tested (I assume), so it wins ;)
> 
> indeed, it's the one I've been using for.. ages.
> 
>  > Maybe it's just me, but I think it would be better to use bzero() for
>  > this operation - it's more readable and it can't be screwed up.  Then
>  > checkpatch checks for memset(xxx, 0, xxx) and for memset(xxx, xxx, 0)
>  > and says "hey, use bzero".  
> 
> god yes.  I don't know why it fell out of favor in userspace[*], but we
> don't have to follow suit in the kernel.  I thought we actually had
> a generic bzero, but it seems not from a quick grep.  I'll hack something up.
> 
> it only needs to be a #define bzero(x,y)	memset (x, 0, y);
> 
> where should it live, linux/kernel.h ?

Thou shalt not implement in CPP that which can be implemented in C.

and..

Thou shalt not implement in C that which is already a gcc builtin :)

I'm OK with switching from memset to bzero as the preferred way of
clearing memory (shorter, clearer, not susceptible to the arg reversal
bug).  Is Linus?

