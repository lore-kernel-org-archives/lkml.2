Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab1FFRNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:13:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58581 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab1FFRNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:13:35 -0400
Date: Mon, 6 Jun 2011 19:13:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110606171310.GF2391@elte.hu>
References: <20110606145827.GD30348@elte.hu>
 <1307372989.2322.136.camel@twins>
 <1307375227.2322.161.camel@twins>
 <20110606155236.GA7374@elte.hu>
 <1307376039.2322.164.camel@twins>
 <20110606160810.GA16636@elte.hu>
 <1307376771.2322.168.camel@twins>
 <20110606161749.GA22157@elte.hu>
 <1307378649.2322.198.camel@twins>
 <1307379048.2322.199.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307379048.2322.199.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Aside from not compiling (someone stuck a ref to wake_up_klogd 
> somewhere in lib/) this does delay the whole of printk() output by 
> up to a jiffy, if the machine dies funny you could be missing large 
> parts of the output :/

oh, that's bad and i missed that aspect.

We want the console *output* immediately. That's non-negotiable!

What we want to delay are the various wakeups of secondary recipients 
of printks ...

Thanks,

	Ingo
