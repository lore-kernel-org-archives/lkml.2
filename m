Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1KUXvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:51:54 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47900 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab1KUXvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:51:52 -0500
MIME-Version: 1.0
In-Reply-To: <1321919169.20742.30.camel@frodo>
References: <1321707028-12487-1-git-send-email-jkacur@redhat.com>
	<1321707028-12487-4-git-send-email-jkacur@redhat.com>
	<1321891800.20742.11.camel@frodo>
	<CAONaPpGz3NoKs9TfDHgNR5YcnfX-j0AT_bVttxPYXLRq5Y=SSg@mail.gmail.com>
	<1321919169.20742.30.camel@frodo>
Date: Tue, 22 Nov 2011 00:51:51 +0100
X-Google-Sender-Auth: 23kOZZvZ2Zf872krCrFv1LVPsHQ
Message-ID: <CAONaPpGf0Xw80mStLtx4pMfvOxKoBH0MNyrHwUyp9d4=EdAFPw@mail.gmail.com>
Subject: Re: [PATCH 3/3] rcu: Drive configuration directly from SMP and PREEMPT
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 12:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-11-22 at 00:18 +0100, John Kacur wrote:
>
>> Imagine you have a uni-processor system and want to do real-time.
>> According to the descriptions in init/Kconfig, you would want to
>> select TINY_PREEMPT_RCU. The description is
>>
>>         This option selects the RCU implementation that is designed
>>         for real-time UP systems.  This option greatly reduces the
>>         memory footprint of RCU.
>>
>> Without this patch, you cannot choose this option because of the &&
>> !PREEMPT_RT_FULL
>> So, that is a bug, and makes this patch appropriate for stable.
>
>
> 3.0-rt never supported rcutiny, which means adding it now is not a bug
> fix but a new feature. Sure, it may have been a mistake that Thomas kept
> rcutiny out for 3.0-rt, but because 3.0-rt never supported it, and
> 3.0-rt can fully support rcutree with !SMP, there is no bug to be fixed
> here. You're adding a new feature to stable, not fixing someones
> problem.
>
>>
>> I suppose if you want to be really conservative, you can say we only
>> need that third hunk.
>> However, this upstream patch, makes these options in v3.0-rt match the
>> options in v3.2-rc2-rt3.
>>
>> Furthermore, it doesn't seem like a good idea to me to support
>> configurations in a stable branch that are not supported upstream.
>
> No, upstream changed the game, in which the configuration can't be
> supported. But the stable release can fully support this configuration.
> there's no reason to this change just because the latest tree can't
> support it. It's like we have to deprecate everything in stable that has
> been deprecated in upstream.
>
> Stable is not a mirror of upstream, it's a snapshot in time. Only if we
> discover something that crashes, or causes huge latencies do we want to
> update stable. Not when we realized that a feature wasn't supported by
> -rt.
>

Okay, I get that and I agree with you - will try to be more careful
about that in the future. However, in this particular case, I don't
think there is a viable rcu choice for UP real-time. Perhaps we can
revisit this again in the future if anyone cares about it.

Thanks
