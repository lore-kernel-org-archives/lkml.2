Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0FFIRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 04:17:39 -0400
Received: from mail.lang.hm ([64.81.33.126]:54005 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab0FFIRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 04:17:35 -0400
Date: Sun, 6 Jun 2010 01:16:34 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, tytso@mit.edu,
       Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
       Arve Hj?nnev?g <arve@android.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
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
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: suspend blockers & Android integration
In-Reply-To: <20100603204521.09808a7f@infradead.org>
Message-ID: <alpine.DEB.2.01.1006060114240.17462@asgard.lang.hm>
References: <20100603193045.GA7188@elte.hu> <20100603231153.GA11302@elte.hu> <20100603232302.GA16184@elte.hu> <alpine.LFD.2.00.1006031630300.8175@i5.linux-foundation.org> <20100603234634.GA21831@elte.hu> <alpine.LFD.2.00.1006031856420.8175@i5.linux-foundation.org>
 <alpine.LFD.2.00.1006031917500.8175@i5.linux-foundation.org> <20100603204521.09808a7f@infradead.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010, Arjan van de Ven wrote:

> On Thu, 3 Jun 2010 19:26:50 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>>
>> If the system is idle (or almost idle) for long times, I would
>> heartily recommend actively shutting down unused cores. Some CPU's
>> are hopefully smart enough to not even need that kind of software
>> management, but I suspect even the really smart ones might be able to
>> take advantage of the kernel saying: "I'm shutting you down, you
>> don't have to worry about latency AT ALL, because I'm keeping another
>> CPU active to do any real work".
>
> sadly the reality is that "offline" is actually the same as "deepest C
> state". At best.
>
> As far as I can see, this is at least true for all Intel and AMD cpus.
>
> And because there's then no power saving (but a performance cost), it's
> actually a negative for battery life/total energy.

I believe that this assumes you are in the 'race to idle' situation where 
when you finish your work you can shutdown. If the work is ongoing you may 
never shutdown.

Also, what about the new CPUs where you can ramp up the clockspeed on some 
cores if you hsut down other cores? that couls also benifit individual 
threads.

David Lang
