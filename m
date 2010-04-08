Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab0DHPrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 11:47:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757214Ab0DHPrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 11:47:06 -0400
Date: Thu, 8 Apr 2010 08:42:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] scheduler fix
In-Reply-To: <20100408153854.GA5055@elte.hu>
Message-ID: <alpine.LFD.2.00.1004080839350.3544@i5.linux-foundation.org>
References: <20100408153854.GA5055@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Apr 2010, Ingo Molnar wrote:
>  
> -	if (len < nr_cpu_ids)
> +	if ((len * BITS_PER_BYTE) < nr_cpu_ids)
>  		return -EINVAL;

Not that it really matters, but this will now fail for no good reason if 
you pass it a half-gigabyte area due to overflow.

Of course, if you pass it a half gig memory array, you're a f*cking moron 
to begin with, so I don't think anybody really _cares_. But in general, 
when checking system call arguments, I'd like people to think about 
overflow issues more.

In this case it doesn't matter, and overflow just makes the test more 
conservative than they need to be, but when it _does_ matter it often ends 
up being a security issue.

		Linus
