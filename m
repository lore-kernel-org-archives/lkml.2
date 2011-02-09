Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1BIOxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:53:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35991 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677Ab1BIOxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:53:20 -0500
Date: Wed, 9 Feb 2011 15:53:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Witten <mfwitten@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        roland@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: Bash not reacting to Ctrl-C
Message-ID: <20110209145304.GB16737@elte.hu>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <20110128165455.GA18194@elte.hu>
 <20110128175532.GA26727@redhat.com>
 <20110128182947.GB20056@elte.hu>
 <20110205203422.GA12443@redhat.com>
 <20110207130841.GA16054@redhat.com>
 <AANLkTimS7vi_BLV_KUw_AKm4DzhV=43Bm3y_epm0rzj9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimS7vi_BLV_KUw_AKm4DzhV=43Bm3y_epm0rzj9@mail.gmail.com>
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


* Michael Witten <mfwitten@gmail.com> wrote:

> On Mon, Feb 7, 2011 at 07:08, Oleg Nesterov <oleg@redhat.com> wrote:
> > Now that it is clear what happens, the test-case becomes even more
> > trivial:
> >
> >        bash-4.1$ ./bash -c 'while true; do /bin/true; done'
> >        ^C^C
> >
> > needs 4-5 attempts on my machine.
> 
> I feel like the odd penguin out.
> 
> I can't reproduce the behavior in question when using that example (I
> haven't tried the other).
> 
> I'm running:
> 
>     * bash version 4.1.9(2)-release (i686-pc-linux-gnu)
> 
>     * linux 2.6.38-rc4 (100b33c8bd8a3235fd0b7948338d6cbb3db3c63d)

Oleg provided another testcase, can you reproduce the Ctrl-C problem with this 
it?

#!/bin/bash

perl -we '$SIG{INT} = sub {exit}; sleep'

echo "Hehe, I am going to sleep after ^C"
sleep 100


Thanks,

	Ingo
