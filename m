Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1ARSgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 13:36:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:38521 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1ARSgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 13:36:06 -0500
Subject: Re: [BUG] perf_event: inst_retired:any_p:c=16:i=1 is not
 equivalent to cpu_clk_unhalted:thread_p
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        Lin Ming <ming.m.lin@intel.com>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <AANLkTinVc=VRo+2=M3x5HEoF__SOJn7kBk7Ek0R94TG9@mail.gmail.com>
References: <AANLkTinVc=VRo+2=M3x5HEoF__SOJn7kBk7Ek0R94TG9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 18 Jan 2011 19:36:33 +0100
Message-ID: <1295375793.30950.1056.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 19:05 +0100, Stephane Eranian wrote:
> Peter,
> 
> commit 7639dae0ca11038286bbbcda05f2bef601c1eb8d
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Tue Dec 14 21:26:40 2010 +0100
> 
>     perf, x86: Provide a PEBS capable cycle event
> 
> 
> 
> Even with the transformation cmask=16:invert=1, you are not quite
> counting the same thing.
> 
> inst_retired:any_p:c=16:i=1  is different from cpu_clk_unhalted:thread_p
> 
> Simply because, I think, this form of inst_retired counts in HALTED state.

Drad it does indeed:

# perf stat -a -e cycles:p -e cycles sleep 1

 Performance counter stats for 'sleep 1':

        61,634,870 cycles                  
        26,703,249 cycles                  

        1.000860820  seconds time elapsed


> This automatic transformation would be "okay" in per-thread mode, but
> not in system-wide mode. It should not be done under the cover. I would
> rather have this option at the user level.

Agreed, since its not identical it had best be done in userspace, too
bad :/ I'll revert this patch.
