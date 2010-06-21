Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab0FUWC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:02:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:41840 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908Ab0FUWCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:02:54 -0400
Message-ID: <4C1FE184.8050802@kernel.org>
Date: Tue, 22 Jun 2010 00:02:44 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATED] sched: adjust when cpu_active and cpuset 	configurations
 are updated during cpu on/offlining
References: <4C08FF36.80806@kernel.org>	<4C0E9E03.1010508@kernel.org>	<AANLkTimL2dEhIaxztoiDRBY3CsalcVNU54Mko6yg8ZqG@mail.gmail.com>	<4C1FD1D0.4060803@kernel.org>	<AANLkTil7QBQOsWIWQOGOaAz76eDqx9clZ1CfL2MR5484@mail.gmail.com>	<4C1FD78C.5030600@kernel.org> <AANLkTimw9yHxKuclHtZ4UzGtwzc2723IDLwmNguRhnZz@mail.gmail.com>
In-Reply-To: <AANLkTimw9yHxKuclHtZ4UzGtwzc2723IDLwmNguRhnZz@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 21 Jun 2010 22:02:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/21/2010 11:46 PM, Tony Luck wrote:
> On Mon, Jun 21, 2010 at 2:20 PM, Tejun Heo <tj@kernel.org> wrote:
>> I'm primarily curious why different archs are doing things
>> differently, which causes confusion and reduces test coverage.  Also,
>> if you just think about the end result, what x86 is doing makes more
>> sense.  Although it may end up with larger kernel image, it actually
>> allows more to be dropped once init is complete.
> 
> It allows x86 to drop some code that it never needed in the first place.
> 
> i don't think that is better :-)
> 
> Maybe someone from x86-land can explain why they *keep* __exit
> code as they are the ones doing it wrong (/me ducks, runs and hides)

Oh, it can actually drop more.  Please consider the following classes.

1. Stuff which are used during system init.
2. Stuff which are used during system init or hotplug.
3. Stuff which are used during hotplug.

ia64 way can express #1 and #3, x86 #1 and #2.  #2 is superset of #3.
So, once init is complete, x86 way can drop larger set.  What matters
is the memory consumption once init is complete, not the image size.
Anyways, in the end, the difference isn't really meaningful but I do
think that it would be far better to have unified behavior across
different architectures, one way or the other.

Thanks.

-- 
tejun
