Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab1GLJgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:36:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab1GLJgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:36:23 -0400
Message-ID: <4E1C1585.4000207@redhat.com>
Date: Tue, 12 Jul 2011 12:36:05 +0300
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
References: <1309362157-6596-1-git-send-email-avi@redhat.com>	 <1309362157-6596-2-git-send-email-avi@redhat.com>	 <20110629160841.GA2032@somewhere>	 <20110629162725.GH15521@e102144-lin.cambridge.arm.com>	 <20110704135820.GD5551@somewhere> <4E11C9CC.2070909@redhat.com>	 <20110704143655.GE5551@somewhere>	 <20110711210753.GA3582@e102144-lin.cambridge.arm.com>	 <4E1BF5A1.5070301@redhat.com> <1310459898.18678.108.camel@twins>	 <4E1C0F02.9040906@redhat.com> <1310462046.14978.11.camel@twins>	 <4E1C10F8.6010300@redhat.com> <1310462335.14978.12.camel@twins>	 <4E1C1373.5080500@redhat.com> <1310463060.14978.17.camel@twins>
In-Reply-To: <1310463060.14978.17.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 12:31 PM, Peter Zijlstra wrote:
> >
> >  But it means that 'current' is not set to the right value.  If the
> >  function depends on it, then it will misbehave.  And in fact
> >  preempt_notifier_register(), which is the function we want to call here,
> >  does depend on current.
> >
> >  Of course we need to find more users for this, but I have a feeling this
> >  will be generally useful.  The alternative is to keep adding bits to
> >  thread_info::flags.
>
> Using TIF_bits sounds like a much better solution for this, wakeups are
> really rather expensive and its best to avoid extra if at all possible.
>

We do need a way to make the task look at them.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

