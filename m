Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab0DRUXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 16:23:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752266Ab0DRUXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 16:23:48 -0400
Date: Sun, 18 Apr 2010 13:21:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jarkko Nikula <jhnikula@gmail.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC patch] CFS fix place entity spread issue (v2)
In-Reply-To: <20100418131302.GA3614@Krystal>
Message-ID: <alpine.LFD.2.00.1004181317100.14500@i5.linux-foundation.org>
References: <20100418131302.GA3614@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 18 Apr 2010, Mathieu Desnoyers wrote:
>
> CFS fix place entity spread issue (v2)
> 
> Huge CFS vruntime spread (18 minutes) has been observed with LTTng while simply
> running Xorg on a uniprocessor machine. Detailed explanation in my ELC2010
> presentation at:

Hmm. I tested this patch with my favourite non-scientific desktop load 
test: do web browsing while doing a kernel compile with "make -j16" (after 
doing a "git clean -dqfx" and "ccache -C" to get rid of old object files 
and ccache).

This is on a dual-core (with SMT, so 4 threads) Core i5, so "make -j16" 
overcommits the CPU's quite a bit.

And quite frankly, I think your patch makes things much worse. I don't 
have numbers, but it felt much choppier and slower to do scrolling in 
firefox o moving windows around while the load average is 20+.

My testload is in no way objective, nor necessarily any good, but it's the 
one I happen to use, and while it's subjective, I think the difference was 
pretty clear and not good.

			Linus
