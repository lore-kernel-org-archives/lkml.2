Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1LLV1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:27:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37806 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1LLV1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:27:30 -0500
Message-ID: <1323725243.2583.27.camel@edumazet-laptop>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Andy Lutomirski <luto@MIT.EDU>
Date: Mon, 12 Dec 2011 22:27:23 +0100
In-Reply-To: <4EE66FE9.1050202@fb.com>
References: <1323718578-1157-1-git-send-email-asharma@fb.com>
	  <1323718578-1157-3-git-send-email-asharma@fb.com>
	 <1323720791.2583.23.camel@edumazet-laptop> <4EE66FE9.1050202@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 décembre 2011 à 13:19 -0800, Arun Sharma a écrit :
> On 12/12/11 12:13 PM, Eric Dumazet wrote:
> 
> >> +
> >> +struct vcpu_data {
> >> +	struct vpercpu_data vpercpu[NR_CPUS];
> >> +	unsigned int tsc_khz;
> >> +	unsigned int tsc_unstable;
> >> +};
> >
> > Thats a showstopper.
> >
> > Try to compile the thing with NR_CPUS=4096 ?
> >
> 
> I get a link time error:
> 
> ld: section .data..percpu [0000000001ac2000 -> 0000000001ad48ff] 
> overlaps section .vvar [0000000001ac0000 -> 0000000001b0083f]
> 
> which I consider better than runtime memory corruption :)
> 
> I could add a BUILD_BUG_ON() that tries to catch this earlier in the 
> compile process.
> 
> Re: Fixing the build for NR_CPUS > 64
> 
> How about something along the lines of the following:
> 
> From: Arun Sharma <asharma@fb.com>
> Date: Mon, 12 Dec 2011 13:13:43 -0800
> Subject: [PATCH] Handle NR_CPUS > 64
> 
> ---

This only works if CONFIG_X86_L1_CACHE_SHIFT=6

Some configurations have 128 bytes cache lines

But really most modern distros have NR_CPUS > 64



