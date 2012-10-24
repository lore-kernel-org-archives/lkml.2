Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444Ab2JXMgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:36:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55680 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522Ab2JXMgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <20121024123124.GU2095@tassilo.jf.intel.com>
References: <1351058350-9159-1-git-send-email-zheng.z.yan@intel.com>
	<1351058350-9159-7-git-send-email-zheng.z.yan@intel.com>
	<CABPqkBRzwsmzaGFKK9+zOed8HK=Q9T9++hMHW+tSKh4EF0cKjg@mail.gmail.com>
	<5087CF96.7010406@intel.com>
	<CABPqkBRPf-xTozCP75SOLFSLc9OcAvMhKqwfqj_BhLcK-DZK_w@mail.gmail.com>
	<5087D678.1080905@intel.com>
	<CABPqkBS+td3UGSqiSW0+p_B+8SnWhZa38k-bojxHu9k1SGzBLg@mail.gmail.com>
	<CABPqkBQ+YMRvR6mv7NrW4-MZOgW6ztntJV5RMehr+SB9ymkYLw@mail.gmail.com>
	<20121024123124.GU2095@tassilo.jf.intel.com>
Date: Wed, 24 Oct 2012 14:36:19 +0200
Message-ID: <CABPqkBQ7dOFpGOLu_Dbyr=HPeBj6mC8Roov7ZpD6v6qUO2JsFA@mail.gmail.com>
Subject: Re: [PATCH V2 6/7] perf, x86: Use LBR call stack to get user callchain
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 2:31 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On Wed, Oct 24, 2012 at 02:21:43PM +0200, Stephane Eranian wrote:
>> But still, if I do:
>> $  perf record -g -e cpu/cycles/k ........
>>
>> Looks like your code will activate LBR cstack for user stack even
>> though I don't use it.
>> I know it won't generate any user samples (theoretically) but you are
>> still commandeering
>> the LBR resource which other events may want to use.
>
> You can disable it in sysfs. LBR is a power user feature and they will
> know how to do this.
>
But isn't the whole point of the patch to hide LBR cstack from users so they
won't know they're using it for user cstack?

To disable it in sysfs, I need to know it's being used in the first place.
You're saying, I need to know it is used only for user cstack and if I don't
need it then I need to disable it explicitly. I also suspect using it
for nothing
may have some performance implication because you are saving/restoring
on ctxsw, for instance.

I think in x86_pmu_hw_config(), you could simply check the priv level
restrictions on the event. If exclude_user is set, then don't active LBR cstack
and that's it. That's what I was trying to get to...


> See it as a "prefer the needs of the 95+% over the needs of the few" default
>
> -Andi
