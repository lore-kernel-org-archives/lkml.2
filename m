Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2HPBOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:14:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974Ab2HPBOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:14:50 -0400
Message-ID: <502C4973.6050901@redhat.com>
Date: Wed, 15 Aug 2012 21:14:27 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>  <502BA7DC.7060907@linux.intel.com> <1345041548.31459.90.camel@twins> <502BB5A3.5000403@linux.intel.com>
In-Reply-To: <502BB5A3.5000403@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 10:43 AM, Arjan van de Ven wrote:

> The easy cop-out is provide the sysadmin a slider.
> The slightly less easy one is to (and we're taking this approach
> in the new P state code we're working on) say "in the default
> setting, we're going to sacrifice up to 5% performance from peak
> to give you the best power savings within that performance loss budget"
> (with a slider that can give you 0%, 2 1/2%  5% and 10%)

On a related note, I am looking at the c-state menu governor.

We seem to have issues there, with Linux often going into a much
deeper C state than warranted, which can lead to a fairly steep
performance penalty for some workloads.

One of the issues we identified is that detect_repeating_patterns
would deal quite poorly with patterns that have a short pause,
followed by a long pause, followed by another short pause. For
example, pinging a virtual machine :)

The idea Matthew and I have is simply planning for a shorter
sleep period (discarding the outliers to the high end in the
function once known as detect_repeating_patterns), and going
to a deeper C state if we have significantly overslept.

The new estimation code is easy, but for the past days I have
been looking through the timer code to figure out how such a
timer could fire, and how we could recognize it without it
looking like a normal wakeup, if we do not end up accidentally
waking up another CPU, etc...

I guess I should probably post what I have and kick off a
debate between people who know that code much better than I do :)

-- 
All rights reversed
