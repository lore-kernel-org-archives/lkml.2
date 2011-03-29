Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab1C2G1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:27:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49513 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab1C2G1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:27:13 -0400
Date: Tue, 29 Mar 2011 08:27:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/6] x86-64: Micro-optimize vclock_gettime
Message-ID: <20110329062706.GE27398@elte.hu>
References: <cover.1301324270.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1301324270.git.luto@mit.edu>
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


* Andy Lutomirski <luto@mit.edu> wrote:

> This series speeds up vclock_gettime(CLOCK_MONOTONIC) on by almost 30%
> (tested on Sandy Bridge).  They're ordered in roughly decreasing order
> of improvement.
> 
> These are meant for 2.6.40, but if anyone wants to take some of them
> for 2.6.39 I won't object.
> 
> The changes and timings (fastest of 20 trials of 100M iters on Sandy
> Bridge) are:
> 
> Unpatched:
> 
> CLOCK_MONOTONIC: 22.09ns
> CLOCK_REALTIME_COARSE: 4.23ns
> CLOCK_MONOTONIC_COARSE: 5.65ns

  [ Patched: ]

> CLOCK_MONOTONIC: 15.66ns
> CLOCK_REALTIME_COARSE: 3.44ns
> CLOCK_MONOTONIC_COARSE: 4.23ns

That looks like a nice speedup, and speedups are definitely welcome. Many of 
your speedup patches were framed in an unclean or hard to maintain fashion 
though - so those have to be improved for this series to become palatable.

Thanks,

	Ingo
