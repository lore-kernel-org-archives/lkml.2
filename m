Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0KKJ6C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:58:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60847 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab0KKJ6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:58:00 -0500
Date: Thu, 11 Nov 2010 10:57:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dongdong Deng <dongdong.deng@windriver.com>, dzickus@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace() at
 the same time on SMP
Message-ID: <20101111095750.GA24558@elte.hu>
References: <1289442042-2515-1-git-send-email-dongdong.deng@windriver.com>
 <20101111092301.GD18789@elte.hu>
 <1289469104.17691.1025.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1289469104.17691.1025.camel@edumazet-laptop>
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


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le jeudi 11 novembre 2010 à 10:23 +0100, Ingo Molnar a écrit :
> 
> > Also, variables that cmpxchg or test_and_set operates on need to be long, not int.
> 
> Hmm, ok for test_and_set(), it operates on a long.
> 
> cmpxchg() is ok on an int AFAIK. If not we have to make some changes :(
> 
> btrfs_orphan_cleanup() for example does this :
> 
> 	if (cmpxchg(&root->orphan_cleanup_state, 0, ORPHAN_CLEANUP_STARTED))
> 		...
> 
> 
> Same in build_ehash_secret() (net/ipv4/af_inet.c)
> 
> 	cmpxchg(&inet_ehash_secret, 0, rnd);

You are right - cmpxchg() auto-detects the word size and thus should work on int 
too.

Thanks,

	Ingo
