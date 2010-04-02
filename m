Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab0DBFqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 01:46:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:38206 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab0DBFqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 01:46:12 -0400
Message-ID: <4BB58479.9080308@kernel.org>
Date: Fri, 02 Apr 2010 14:45:29 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       dipankar@in.ibm.com, josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       oleg@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCHSET] cpuhog: implement and use cpuhog
References: <1268063603-7425-1-git-send-email-tj@kernel.org>	 <1268249155.5279.128.camel@twins>  <4B99B15B.8060002@kernel.org> <1269853888.12097.191.camel@laptop>
In-Reply-To: <1269853888.12097.191.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 05:45:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On 03/29/2010 06:11 PM, Peter Zijlstra wrote:
> Its a pretty minor difference, shouldn't we simply audit all existing
> kstopmachine users and fix that up, having two similar but not quite
> identical interfaces in the kernel sounds like trouble.

Yeap, sure.  I don't think naming one way or the other is a problem
logistics-wise.  These aren't very widely used APIs anyway.  I've been
thinking quite a while about it and visible interface like the
following would probably fit your suggestion.

* stop_cpu()		- identical to hog_cpu()
* stop_cpus()		- identical to hog_cpus()
* stop_machine()

It's just that stop_cpu[s]() don't look like good names because they
don't really stop cpus.  This distinction is visible in
implementation.  stop_machine()'s per-cpu callback is currently named
stop_cpu() and it adds quite a bit more restrictions on top of just
hogging the cpu.  To me, the following visible API seems better.

* hog_cpu()
* hog_cpus()
* stop_machine()	- uses stop_cpu() internally for implementation

Oh well, I guess it's a matter of taste.  Given that other people
don't dislike the current naming too much, I'll try to push it forward
to Ingo w/ your objection to naming noted.

Thank you for reviewing.

-- 
tejun
