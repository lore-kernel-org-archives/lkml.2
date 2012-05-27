Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2E0OL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 10:11:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:40316 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab2E0OL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 10:11:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="148960700"
Message-ID: <4FC2362A.8080503@linux.intel.com>
Date: Sun, 27 May 2012 07:11:54 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
References: <1337857490.7300.19.camel@marge.simpson.net>  <1337865431.9783.148.camel@laptop> <1337865641.9783.149.camel@laptop>  <1337926468.5415.48.camel@marge.simpson.net>  <1338014259.7302.26.camel@marge.simpson.net>  <1338017364.14636.9.camel@twins>  <1338020834.7747.8.camel@marge.simpson.net> <1338110259.7678.77.camel@marge.simpson.net>
In-Reply-To: <1338110259.7678.77.camel@marge.simpson.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/27/2012 2:17 AM, Mike Galbraith wrote:
> On Sat, 2012-05-26 at 10:27 +0200, Mike Galbraith wrote: 
>> Hohum, back to finding out what happened to cpufreq.
> 
> Answer: nothing.. in mainline.
> 
> I test performance habitually, so just never noticed how bad ondemand
> sucks.  In enterprise, I found the below, explaining why cores crank up
> fine there, but not in mainline.  Somebody thumped ondemand properly on
> it's pointy head.
> 
> But, check out the numbers below this, and you can see just how horrible
> bouncing is when you add governor latency _on top_ of it. 

part of it is not ondemand, but cpufreq.
cpufreq forces you to schedule a kernel thread to change cpu
frequency... on the cpu that's already busy.
God knows what the scehduler then does in terms of load balancing.

(yes this is one of the things that will be fixed in the code that we
now have working internally, and we're now making sure does not regress)

btw, on modern Intel CPUs, where in Idle, you have a frequency of Zero,
regardless of what you ask for when you're running, and where an idle
cpu is clock gated.... the performance governor behaves almost the same
as ondemand in terms of power (due to the suckitude of ondemand)... but
much better performance.


