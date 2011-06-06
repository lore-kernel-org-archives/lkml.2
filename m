Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1FFRHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:07:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33112 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab1FFRHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:07:40 -0400
Date: Mon, 6 Jun 2011 19:07:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110606170725.GD2391@elte.hu>
References: <20110606145827.GD30348@elte.hu>
 <1307372989.2322.136.camel@twins>
 <1307375227.2322.161.camel@twins>
 <20110606155236.GA7374@elte.hu>
 <1307376039.2322.164.camel@twins>
 <20110606160810.GA16636@elte.hu>
 <1307376771.2322.168.camel@twins>
 <20110606161749.GA22157@elte.hu>
 <4DED0292.1040605@die-jansens.de>
 <4DED0423.4050904@die-jansens.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DED0423.4050904@die-jansens.de>
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


* Arne Jansen <lists@die-jansens.de> wrote:

> > As long as it doesn't scramble the order of the messages, the 
> > delay imho doesn't matter even in very printk-heavy debugging 
> > sessions.
> 
> And, as important, doesn't reduce the throughput of printk. Having 
> only 100 wakeups/s sounds like the throughput is limited to 
> 100xsizeof(ring buffer).

Nah.

I for example *always* kill klogd during such printk based debugging 
sessions, because it's *already* very easy to overflow its buffering 
abilities. Also, klogd often interferes with debugging.

So i make the log buffer big enough to contain enough debugging info.

So it's a non-issue IMHO. Linus, what do you think?

Thanks,

	Ingo
