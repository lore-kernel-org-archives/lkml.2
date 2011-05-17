Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab1EQT1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 15:27:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43311 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab1EQT1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 15:27:18 -0400
Date: Tue, 17 May 2011 21:27:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
Message-ID: <20110517192701.GE29574@elte.hu>
References: <20110516164939.GD25898@one.firstfloor.org>
 <BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com>
 <m2fwoeo0pf.fsf@firstfloor.org>
 <alpine.LFD.2.02.1105162345110.3078@ionos>
 <BANLkTinVnr1ZM2wOxuH-rHZGh+_SBWT-+g@mail.gmail.com>
 <alpine.LFD.2.02.1105170022430.3078@ionos>
 <20110517080029.GB22093@elte.hu>
 <BANLkTimpEfb3P9FWgrCDwSSVr6RA8nXb5w@mail.gmail.com>
 <20110517113634.GC13475@elte.hu>
 <4DD2BEFB.6070609@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD2BEFB.6070609@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@MIT.EDU> wrote:

> It's even easier than that: there are no syscall numbers involved.  There are 
> four separate entry points, one for each vsyscall.
> 
> (It turns out that one of them has been broken and just segfaults since 2008 
> (a4928cff), so we only have to emulate three of them.)
> 
> On KVM on Sandy Bridge, I can emulate a vsyscall that does nothing in 400ns 
> or so.  I'll try to make this code emulate real vsyscalls over the weekend.  

Very nice!

> This was much easier than I expected.

Hey, looking back at a working patch always makes it seem easy ;-)

Thanks,

	Ingo
