Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab0FUVUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:20:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:43438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758630Ab0FUVUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:20:31 -0400
Message-ID: <4C1FD78C.5030600@kernel.org>
Date: Mon, 21 Jun 2010 23:20:12 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATED] sched: adjust when cpu_active and cpuset 	configurations
 are updated during cpu on/offlining
References: <4C08FF36.80806@kernel.org>	<4C0E9E03.1010508@kernel.org>	<AANLkTimL2dEhIaxztoiDRBY3CsalcVNU54Mko6yg8ZqG@mail.gmail.com>	<4C1FD1D0.4060803@kernel.org> <AANLkTil7QBQOsWIWQOGOaAz76eDqx9clZ1CfL2MR5484@mail.gmail.com>
In-Reply-To: <AANLkTil7QBQOsWIWQOGOaAz76eDqx9clZ1CfL2MR5484@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 21 Jun 2010 21:20:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/21/2010 11:15 PM, Tony Luck wrote:
> The history is that __exit functions are those that are called on module
> unload.  When a driver is built-in to the kernel, it can obviously never
> be unloaded. Therefore the __exit code must just be bloat for the built-in
> case.

I see.

> A system built with CONFIG_HOTPLUG_CPU=n meets the requirement
> that cpus will not be removed after system boot. So why do I need to
> include the __cpuexit code that should only be used to remove cpus?

I'm primarily curious why different archs are doing things
differently, which causes confusion and reduces test coverage.  Also,
if you just think about the end result, what x86 is doing makes more
sense.  Although it may end up with larger kernel image, it actually
allows more to be dropped once init is complete.  Anyways, will send a
patch to change those __cpuexit's to __cpuinit's.

Thanks.

-- 
tejun
