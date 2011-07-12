Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab1GLJ1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:27:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab1GLJ1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:27:37 -0400
Message-ID: <4E1C1373.5080500@redhat.com>
Date: Tue, 12 Jul 2011 12:27:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Will Deacon <will.deacon@arm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
References: <1309362157-6596-1-git-send-email-avi@redhat.com>	 <1309362157-6596-2-git-send-email-avi@redhat.com>	 <20110629160841.GA2032@somewhere>	 <20110629162725.GH15521@e102144-lin.cambridge.arm.com>	 <20110704135820.GD5551@somewhere> <4E11C9CC.2070909@redhat.com>	 <20110704143655.GE5551@somewhere>	 <20110711210753.GA3582@e102144-lin.cambridge.arm.com>	 <4E1BF5A1.5070301@redhat.com> <1310459898.18678.108.camel@twins>	 <4E1C0F02.9040906@redhat.com> <1310462046.14978.11.camel@twins>	 <4E1C10F8.6010300@redhat.com> <1310462335.14978.12.camel@twins>
In-Reply-To: <1310462335.14978.12.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 12:18 PM, Peter Zijlstra wrote:
> >
> >  The guarantee is that the task was sleeping just before the function is
> >  called.  Of course it's woken up to run the function.
> >
> >  The idea is that you run the function in a known safe point to avoid
> >  extra synchronization.
> >
>
> I'd much rather we didn't wake the task and let it sleep, that's usually
> a very safe place for tasks to be. All you'd need is a guarantee it
> won't be woken up while you're doing your thing.

But it means that 'current' is not set to the right value.  If the 
function depends on it, then it will misbehave.  And in fact 
preempt_notifier_register(), which is the function we want to call here, 
does depend on current.

Of course we need to find more users for this, but I have a feeling this 
will be generally useful.  The alternative is to keep adding bits to 
thread_info::flags.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

