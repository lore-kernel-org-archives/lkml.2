Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab1EPLHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:07:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54982 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869Ab1EPLHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:07:23 -0400
Date: Mon, 16 May 2011 13:06:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Glauber Costa <glommer@redhat.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris McDermott <lcm@us.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: manual merge of the tip tree with the arm tree
Message-ID: <20110516110652.GC19837@elte.hu>
References: <20110513080634.GA13647@elte.hu>
 <20110513083738.GA19733@n2100.arm.linux.org.uk>
 <20110513092646.GK13647@elte.hu>
 <20110513213640.GB30539@n2100.arm.linux.org.uk>
 <20110516073144.GF24836@elte.hu>
 <20110516074230.GI30539@n2100.arm.linux.org.uk>
 <20110516091744.GB12325@elte.hu>
 <20110516091927.GK30539@n2100.arm.linux.org.uk>
 <20110516094056.GA25039@elte.hu>
 <20110516100750.GN30539@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110516100750.GN30539@n2100.arm.linux.org.uk>
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


* Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Mon, May 16, 2011 at 11:40:56AM +0200, Ingo Molnar wrote:
> >    maintainers (and not assume lack of ack after 24 hours means acceptance), or 
> 
> Wrong, 72 to 96 hours.  Sunday to Wednesday/Thursday.

Not that this is really material (the argument is pretty much the same even had 
you waited 3 days), but you are already wrong about the 'Sunday' part, because 
you posted it to lkml on *Monday* 13:27 GMT:

        Message-ID: <20110509132738.GB16919@n2100.arm.linux.org.uk>
        Mon, 9 May 2011 09:27:52 -0400

How hard can it be for you to look up the dates of the events before you accuse 
others of not listening?

Then you committed/amdended it on Tuesday 7:20 GMT:

 commit 3490f584b9ba5a0b6f63832fbc9c5ec72506697b
 Author:     Russell King <rmk+kernel@arm.linux.org.uk>
 AuthorDate: Sun May 8 18:55:19 2011 +0100
 Commit:     Russell King <rmk+kernel@arm.linux.org.uk>
 CommitDate: Tue May 10 08:20:54 2011 +0100

which is a mere 18 hours after it was mailed to lkml - and then you pushed it 
out to linux-next some time after that, probably on the next day, Wednesday, 
right?

It does not matter one little bit that you'd have been 'ready to rebase' once 
more had some objection come in that short 2 days time window from Monday to 
Wednesday, or any of the dates after that.

What i'm saying for the fourth time is that what you did here is not a proper 
Git workflow: we only push bits out into permanent branches (and expose them to 
conflicts, etc.) once they are final, and we only do that after making sure 
that maintainers who maintain the trees of the affected files are fine with it 
and make sure that there are no conflicts.

Or, failing all that, if you are such a superhero kernel hacker who never makes 
any mistakes and never apologizes and can freely ignore well-established Git 
workflow best practices you should *at least* make sure you do not mess up and 
make sure the file you modify still builds on the architecture you are 
modifying:

  $ git checkout 3490f584b9ba # clocksource: convert x86 to generic i8253 clocksource
  $ make defconfig
  $ make -j2 bzImage

  arch/x86/kernel/i8253.c: In function ‘init_pit_clocksource’:
  arch/x86/kernel/i8253.c:133: error: implicit declaration of function ‘clocksource_pit_init’
  make[2]: *** [arch/x86/kernel/i8253.o] Error 1
  make[1]: *** [arch/x86/kernel] Error 2
  make: *** [arch/x86] Error 2
  make: *** Waiting for unfinished jobs....

Or is that too much to ask for?

Thanks,

	Ingo
