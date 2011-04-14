Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417Ab1DNTsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:48:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38029 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758846Ab1DNTsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:48:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mTTyzIbMIpc/q0BFkgkw0cp9nmdxh9DuNncI1m2omiWMkhdXEgHu+XFlyK4H6L+rIb
         7xtFRd35YvHzT/vQBwQALJszPwx1CfpiPCRKWmgKj7z4pbZuDlliDSK/JuT/4GQxpY1/
         TVVDyFf1Kt29b3qajXuflivqxYxup3/j8XuFU=
Subject: Re: [PATCH V2] futex: set FLAGS_HAS_TIMEOUT during demux for
 FUTEX_WAIT
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>
In-Reply-To: <4DA746C5.1080804@linux.intel.com>
References: <1302800949.3248.42.camel@edumazet-laptop>
	 <6aed1a53d080a90672bd44b773079dd81ac90b50.1302806742.git.dvhart@linux.intel.com>
	 <1302807391.2744.6.camel@edumazet-laptop>
	 <4DA746C5.1080804@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 21:48:34 +0200
Message-ID: <1302810514.2744.39.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 14 avril 2011 à 12:11 -0700, Darren Hart a écrit :

> I would say anything calling SYS_FUTEX is the futex slow path. The fast
> path is cmpxchg in user space.
> 

Thats not a good reason to make it slower than necessary...

> It was. My thinking was that it was inconsistent to have the
> FLAGS_HAS_TIMEOUT only available if a signal was received and a restart
> was required. This is the only place it is currently needed, but the
> inconsistency concerns me.
> 

I dont call this inconsistency, but right place for the code.

> How about the following, it reuses an existing if block and ensure the
> FLAGS_HAS_TIMEOUT is always set if a timeout is used. It means the
> FLAG_HAS_TIMEOUT is not available in the other futex_* routines with
> timeouts (futex_lock_pi and futex_wait_requeue_pi), but they use absolute
> timeouts and don't need it for restart - I can agree to that, although
> I'm not keen on FLAG_HAS_TIMEOUT not being set whenever timeout is. That
> could be added in the same way to the other functions if needed in the
> future.

I dont understand why you insist setting in fast path a flag that is
useless, unless we hit restart logic [ What I call the slow path in
futex syscall ]

It seems more natural and efficient to me to go back to previous code.

Maybe rename FLAG_HAS_TIMEOUT to FLAG_HAS_TIMEOUT_ON_RESTART if you
want, to make clear what is the meaning of this flag.

Now if you have plans to use this flag in futex code, outside of restart
logic, please share them with us :)



