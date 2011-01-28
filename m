Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab1A1QzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 11:55:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47161 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267Ab1A1QzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 11:55:16 -0500
Date: Fri, 28 Jan 2011 17:54:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET] ptrace,signal: group stop / ptrace updates
Message-ID: <20110128165455.GA18194@elte.hu>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296227324-25295-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I'm hijacking this thread, to report a signal handling bug that Linux and Bash has, 
and which has been there at least for 10 years since i started using SMP Linux 
systems ...

It's not easy to reproduce but today i found a reproducer - maybe you guys have an 
idea what's going on.

There's two very simple scripts, one calls the other in an infinite loop:

 $ cat test-signal
 #!/bin/bash

 while true; do ./test-signal2; done

 $ cat test-signal2
 #!/bin/bash

 true

The bug is that occasionally Ctrl-C does not get processed, and that the Ctrl-C is 
'lost'. It can be reproduced here by running ./test-signal several times, and 
Ctrl-C-ing it:

 $ ./test-signal
 ^C
 $ ./test-signal
 ^C^C
 $ ./test-signal
 ^C

See that '^C^C' line? That is where i had to do Ctrl-C twice.

It only fails here about once every 10 times, so it's very rare. I have a stock F14 
system running on that box, with the very latest .38 based kernel.

Any ideas what's going on?

Thanks,

	Ingo
