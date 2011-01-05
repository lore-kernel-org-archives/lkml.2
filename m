Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab1AENVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 08:21:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45721 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab1AENVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 08:21:23 -0500
Date: Wed, 5 Jan 2011 14:21:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: akpm@linux-foundation.org, fweisbec@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] panic:  ratelimit panic messages
Message-ID: <20110105132108.GE10129@elte.hu>
References: <1294198711-15492-1-git-send-email-dzickus@redhat.com>
 <1294198711-15492-2-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294198711-15492-2-git-send-email-dzickus@redhat.com>
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


* Don Zickus <dzickus@redhat.com> wrote:

> Sometimes when things go bad, so much spew is coming on the console it is hard
> to figure out what happened.  This patch allows you to ratelimit the panic
> messages with the intent that the first panic message will provide the info
> we need to figure out what happened.
> 
> Adds new kernel param 'panic_ratelimit=on/<integer in seconds>'
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  Documentation/kernel-parameters.txt |    6 ++++++
>  kernel/panic.c                      |   30 ++++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+), 0 deletions(-)

Well, but it's not just panics that can occur repeatedly (in fact panics tend to 
trigger once), but recursive/repeated oopses.

So if we try to do some sort of 'show first crash, rate-limit afterwards' thing (i'm 
still not 100% sure about the wiseness of it) then we should cover all common 
occurances of system panics/crashes.

btw., while printk-delay exists and can serve a similar purpose, it's pretty 
cumbersome for panic ratelimit: it slows down bootups extremely, and it also slows 
down regular, harmless printks.

So having some sort of rate-limit for emitting crash screens may make sense, while 
also preserving the oops counter or at least some other notification that we 'lost' 
messages.

	Ingo
