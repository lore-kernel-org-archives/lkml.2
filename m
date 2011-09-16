Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1IPIJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:09:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57363 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab1IPIJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:09:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:message-id:date:from:user-agent:
	mime-version:newsgroups:to:cc:subject:references:in-reply-to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=G+d5itFrNrw2cOBm5A60Vk3HtdwY9PHfPe76Tl4imQj2EZa0ql1R0teKG7rR5D20w
	qaNuAA0LuvQjbIsdMJGnA==
Message-ID: <4E730430.7090608@google.com>
Date: Fri, 16 Sep 2011 01:09:20 -0700
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Peter Zijlstra <peterz@infradead.org>
CC: "Luck, Tony" <tony.luck@intel.com>, Ken Chen <kenchen@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>
Subject: Re: [ia64] Question on __ARCH_WANT_UNLOCKED_CTXSW
References: <1314188833.6925.3.camel@twins>  <987664A83D2D224EAE907B061CE93D5301EA611910@orsmsx505.amr.corp.intel.com> <1315940361.4226.17.camel@twins>
In-Reply-To: <1315940361.4226.17.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/11 11:59, Peter Zijlstra wrote:
> On Wed, 2011-08-24 at 13:46 -0700, Luck, Tony wrote:
>>> happen to remember what the perceived benefit of using
>>> __ARCH_WANT_UNLOCKED_CTXSW was about?
>>
>> No - digging around the code hasn't rung any bells for me either.
>>
>> Perhaps just general goodness for not holding a lock for
>> longer than we need to?  But that would imply some case where
>> someone else could do something useful by being able to grab
>> the lock when we drop it. About the only thing I can think
>> of is that it would allow tasks to be re-balanced just a
>> teeny bit earlier --- but re-balancing ought to be somewhat
>> rare, yes?
>
> Mostly yes, except remote wakeups, however that got a complete overhaul
> in 3.0. Instead of taking the remote rq->lock we now enqueue the task on
> a list and IPI the thing, then let the IPI do the remote enqueue and
> trigger the reschedule.
>
> So it might make sense to re-evaluate this on ia64 like Ken suggested..
> then again, who has a large ia64 box and is still willing to put time
> in?

Hum -- perhaps they'll come out of the woodwork if we just rip it out 
(if they exist)

- Paul
