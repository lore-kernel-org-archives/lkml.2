Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1KPSkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:40:25 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39206 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1KPSkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:40:24 -0500
Message-ID: <4EC40391.7080508@google.com>
Date: Wed, 16 Nov 2011 10:40:17 -0800
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Peter Zijlstra <peterz@infradead.org>
CC: Il Han <corone.il.han@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: add the inline keyword to the prototype.
References: <1321380994-5768-1-git-send-email-corone.il.han@gmail.com>  <4EC36631.8030805@google.com> <1321434038.1421.73.camel@twins>
In-Reply-To: <1321434038.1421.73.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 01:00 AM, Peter Zijlstra wrote:
> On Tue, 2011-11-15 at 23:28 -0800, Paul Turner wrote:
>> On 11/15/2011 10:16 AM, Il Han wrote:
>>> The prototype has to agree with the definition.
>>> Add the inline keyword to the prototype also
>>>
>>
>> Hmm... this would then cause the prototypes to disagree in the
>> !CONFIG_CFS_BANDWIDTH case.
>
> I'm very sure I've compiled a lot of kernels yesterday with various
> permutations including FAIR_GROUP&&  !CFS_BANDWIDTH and I'm also very
> sure I haven't actually seen any complaints like this.
>
> It this some new fangled GCC 'feature'? I'm currently still on 4.5 which
> admittedly is somewhat stale.

gcc (even 4.6) won't give warnings either way about the inline attribute on a 
forward declaration not matching in either direction.  I would imagine this was 
found by code-inspection.

I was only pointing out with this we have:

#if CONFIG_CFS_BANDWIDTH
static __always_inline xxx() { stuff; } [1]
#else
static xxx() {} [2]
#endif

And that by only changing the pre-declaration to match [1] it now similarly 
(silently) would not match [2] in the !CONFIG case.

- Paul
