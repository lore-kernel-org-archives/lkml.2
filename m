Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab0FDCc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:32:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168Ab0FDCc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:32:28 -0400
Date: Thu, 3 Jun 2010 19:26:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Arve Hj?nnev?g <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend blockers & Android integration
In-Reply-To: <alpine.LFD.2.00.1006031856420.8175@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1006031917500.8175@i5.linux-foundation.org>
References: <20100603193045.GA7188@elte.hu> <20100603231153.GA11302@elte.hu> <20100603232302.GA16184@elte.hu> <alpine.LFD.2.00.1006031630300.8175@i5.linux-foundation.org> <20100603234634.GA21831@elte.hu>
 <alpine.LFD.2.00.1006031856420.8175@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Linus Torvalds wrote:
> 
> so I'd like to see the opportunistc suspend thing think about CPU 
> offlining

Side note: one reason for me being somewhat interested in the CPU 
offlining is that I think the Android kind of opportunistic suspend is 
_not_ likely something I'd like to see on a desktop. But an the 
"opportunistic CPU offliner"? That might _well_ be useful even outside of 
any other suspend activity.

If the system is idle (or almost idle) for long times, I would heartily 
recommend actively shutting down unused cores. Some CPU's are hopefully 
smart enough to not even need that kind of software management, but I 
suspect even the really smart ones might be able to take advantage of the 
kernel saying: "I'm shutting you down, you don't have to worry about 
latency AT ALL, because I'm keeping another CPU active to do any real 
work".

I'd also be interested to see if it could even improve single-thread 
performance if we end up doing the whole SMP->UP "lock" prefix rewriting 
when the system is idle enough that we'd be better off running just a 
single core. I dunno - just throwing that out there.

Anyway, the only reason I think this is related is literally because I 
think that if we know there is only a single CPU active, I think the 
actual "real" opportunistic suspend is easier. Suddenly you don't have to 
worry about what happens on other run-queues etc, and whether another CPU 
is just about to create a suspend block etc.

So I think they tie together, although it's mostly tangential. And as 
mentioned, I think a opportunistic CPU suspend part is more relevant 
outside of Android, and thus perhaps more widely interesting.

			Linus
