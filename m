Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab0KGLwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 06:52:06 -0500
Received: from 1wt.eu ([62.212.114.60]:47123 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab0KGLwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 06:52:05 -0500
Date: Sun, 7 Nov 2010 12:51:45 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Message-ID: <20101107115145.GW4627@1wt.eu>
References: <20101104135802.GA31416@elte.hu> <20101104141104.GA31753@elte.hu> <20101104143322.GL25118@suse.de> <20101104190804.GA16099@elte.hu> <20101104212920.GA31256@1wt.eu> <20101104215157.GA25128@elte.hu> <20101104223526.GC31236@1wt.eu> <20101107085016.GA23843@elte.hu> <20101107094932.GT4627@1wt.eu> <20101107114237.GA3759@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107114237.GA3759@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 12:42:37PM +0100, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > [...] I was explaining that doing this will not prevent them from guessing the 
> > precise kernel version, [...]
> 
> Well, which is exactly what i have said to Marcus early on in this discussion:
> 
>  |
>  | What i suggested in later parts of my mail might provide more security: to sandbox 
>  | kernel version information from unprivileged user-space - if we decide that we 
>  | want to sandbox kernel version information ...
>  |
>  | That is a big if, because it takes a considerable amount of work. Would be worth 
>  | trying it - but feel-good non-solutions that do not bring much improvement to the 
>  | majority of users IMHO hinder such efforts.
>  |
> 
> The 'considerable amount of work' refers not to the utsname version fuzzing patch 
> (it's a 10-liner patch, literally), but to controlling the channels of version 
> information you mentioned (uptime, the /boot timestamp), and some other channels you 
> did not mention: dmesg, various /sys and /proc entries that leak version 
> information, etc.

I did not mention dmesg because it's already sometimes hidden from users (eg,
when iptables logs there).

> All must be closed down for unprivileged user-space, for this to be effective, 
> obviously.

This would only be effective against finding a precise version. There's
no need for that, what you want is to hide kernel pointers, and your issue
is that in distro kernels, same kernels have the same pointers. It would be
much more efficient to work on a method to randomize all pointers than to
try to hide a kernel version hoping a user is not able to guess what it is.
Even if you'd hide the uptime, there are many ways to find it. In my opinion,
it's a race in the wrong direction, and which has several negative side
effects on the normal user.

Better attack the problem than its symptoms.

Willy

