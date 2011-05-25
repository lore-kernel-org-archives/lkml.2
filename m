Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1EYHSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:18:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34330 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727Ab1EYHSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:18:31 -0400
Date: Wed, 25 May 2011 09:18:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, tglx@linutronix.de
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage based
 on semi-formal proof"
Message-ID: <20110525071816.GG429@elte.hu>
References: <20110523212530.GF7428@linux.vnet.ibm.com>
 <4DDAD934.9010603@kernel.org>
 <4DDAE5FA.2030303@kernel.org>
 <4DDAE6A5.6060701@kernel.org>
 <20110524011824.GL7428@linux.vnet.ibm.com>
 <4DDB093F.2060601@kernel.org>
 <20110524013523.GO7428@linux.vnet.ibm.com>
 <4DDC21E1.1070502@kernel.org>
 <20110525000530.GK2266@linux.vnet.ibm.com>
 <4DDC4992.2020505@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDC4992.2020505@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> >> got:
> >>
> >> [   32.803704] cpu_dev_init done
> >> [   99.171292] memory_dev_init done
> > 
> > So the difference between these two is noise, I hope.  Adding a static
> > inline function that is not used should not have an effect on performance.
> > Still, the difference between 6 seconds and 60 seconds rises far above
> > this noise level, so the big differences are likely quite real.
> 
> could be softirq to kthread change...

Softirq processing can be pretty nondeterministic (for example there's no 
guarantee that we process all softirqs) - but kthreads ought to be pretty 
deterministic. Weird.

Thanks,

	Ingo
