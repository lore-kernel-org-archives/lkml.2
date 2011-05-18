Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1ERG0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 02:26:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41914 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab1ERG0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 02:26:22 -0400
Date: Wed, 18 May 2011 08:25:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/4] v6 Improve task->comm locking situation
Message-ID: <20110518062554.GB2945@elte.hu>
References: <1305682865-27111-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305682865-27111-1-git-send-email-john.stultz@linaro.org>
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


* John Stultz <john.stultz@linaro.org> wrote:

> v6 tries to address the latest round of issues. Again, hopefully this is 
> getting close to something that can be queued for 2.6.40.

We are far away from thinking about upstreaming any of this ...

> Since my commit 4614a696bd1c3a9af3a08f0e5874830a85b889d4, the current->comm 
> value could be changed by other threads.
> 
> This changed the comm locking rules, which previously allowed for unlocked 
> current->comm access, since only the thread itself could change its comm.
> 
> While this was brought up at the time, it was not considered problematic, as 
> the comm writing was done in such a way that only null or incomplete comms 
> could be read. However, recently folks have made it clear they want to see 
> this issue resolved.

The commit is from 2.5 years ago:

        4614a696bd1c3a9af3a08f0e5874830a85b889d4
        Author: john stultz <johnstul@us.ibm.com>
        Date:   Mon Dec 14 18:00:05 2009 -0800

            procfs: allow threads to rename siblings via /proc/pid/tasks/tid/comm

So we are *way* beyond the time frame where this could be declared urgent.

So is there any actual motivation beyond:

  " Hey, this looks a bit racy and 'top' very rarely, on rare workloads that 
    play with ->comm[], might display a weird reading task name for a second, 
    amongst the many other temporarily nonsensical statistical things it 
    already prints every now and then. "

?

> So fair enough, as I opened this can of worms, I should work
> to resolve it and this patchset is my initial attempt.

This patch set does not address the many places that deal with ->comm so it 
does not even approximate the true scope of the change!

I.e. you are doing *another* change without fully seeing/showing the 
consequences ...

Thanks,

	Ingo
