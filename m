Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0KGJIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 04:08:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57316 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab0KGJIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 04:08:23 -0500
Date: Sun, 7 Nov 2010 10:08:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to
 reduce ease of attacking
Message-ID: <20101107090805.GA27983@elte.hu>
References: <20101104114648.GA23381@elte.hu>
 <20101104122906.GH25118@suse.de>
 <20101104135802.GA31416@elte.hu>
 <20101104141104.GA31753@elte.hu>
 <20101104143322.GL25118@suse.de>
 <20101104190804.GA16099@elte.hu>
 <20101104212920.GA31256@1wt.eu>
 <20101104215157.GA25128@elte.hu>
 <20101104223526.GC31236@1wt.eu>
 <20101107085016.GA23843@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107085016.GA23843@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> If your claim that 'kernel version is needed at many places' is true then why am i 
> seeing this on a pretty general distro box bootup:
> 
>  [root@aldebaran ~]# uname -a
>  Linux aldebaran 2.6.99-tip-01574-g6ba54c9-dirty #1 SMP Sun Nov 7 10:24:38 CET 2010 x86_64 x86_64 x86_64 GNU/Linux
> 
> ?
> 
> Yes, some user-space might be unhappy if we set the version _back_ to say 2.4.0, 
> but we could (as the patch below) fuzz up the version information from 
> unprivileged attackers easily.

Btw., with an 'exploit honeypot' and 'version fuzzing' the uname output would look 
like this to an unprivileged user:

  $ uname -a
  Linux aldebaran 2.6.99 x86_64 x86_64 x86_64 GNU/Linux

[ we wouldnt want to include the date or the SHA1 of the kernel, obviously. ]

And it would look like this to root:

  # uname -a
  Linux aldebaran 2.6.37-tip-01574-g6ba54c9-dirty #1 SMP Sun Nov 7 10:24:38 CET 2010 x86_64 x86_64 x86_64 GNU/Linux

	Ingo
