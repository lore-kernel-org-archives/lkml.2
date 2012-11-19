Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab2KSTA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 14:00:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41923 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab2KSTA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 14:00:27 -0500
Message-ID: <50AA818F.4020900@oracle.com>
Date: Mon, 19 Nov 2012 13:59:27 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121112 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Sasha Levin <levinsasha928@gmail.com>, james.l.morris@oracle.com,
        John Johansen <john.johansen@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-security-module@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: yama: lockdep warning on yama_ptracer_del
References: <507F7313.8010707@oracle.com> <CAGXu5jKSD8nRMJ11DpKRe8M79W9MZ2eowAafXOQ9_WCj4dZXug@mail.gmail.com> <CA+1xoqdJ=mF6MUPRYm7CmE_fa8GshtjxUpwwYPCKY4ob+gDAeQ@mail.gmail.com> <CAGXu5j+XuQxJcUWSNaziMivNjKsB9S9cFMKDbigCBN16NGBRgw@mail.gmail.com>
In-Reply-To: <CAGXu5j+XuQxJcUWSNaziMivNjKsB9S9cFMKDbigCBN16NGBRgw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 11:23 AM, Kees Cook wrote:
> On Sun, Nov 18, 2012 at 8:05 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>> Hi Kees,
>>
>> On Thu, Oct 18, 2012 at 6:39 PM, Kees Cook <keescook@chromium.org> wrote:
>>> On Wed, Oct 17, 2012 at 8:10 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>>> Hi all,
>>>>
>>>> I was fuzzing with trinity within a KVM tools guest (lkvm) on a linux-next kernel, and got the
>>>> following dump which I believe to be noise due to how the timers work - but I'm not 100% sure.
>>>> ...
>>>> [  954.674123]  Possible interrupt unsafe locking scenario:
>>>> [  954.674123]
>>>> [  954.674123]        CPU0                    CPU1
>>>> [  954.674123]        ----                    ----
>>>> [  954.674123]   lock(ptracer_relations_lock);
>>>> [  954.674123]                                local_irq_disable();
>>>> [  954.674123]                                lock(&(&new_timer->it_lock)->rlock);
>>>> [  954.674123]                                lock(ptracer_relations_lock);
>>>> [  954.674123]   <Interrupt>
>>>> [  954.674123]     lock(&(&new_timer->it_lock)->rlock);
>>>> [  954.674123]
>>>> [  954.674123]  *** DEADLOCK ***
>>>
>>> I've been wanting to get rid of the Yama ptracer_relations_lock
>>> anyway, so maybe I should do that now just to avoid this case at all?
>>
>> I still see this one in -rc6, is there anything to get rid of it
>> before the release?
> 
> I'm not sure about changes to the timer locks, but I haven't been able
> to get rid of the locking on Yama's task_free path. I did send a patch
> to get rid of locking during a read, though:
> 
> https://lkml.org/lkml/2012/11/13/808

Aw, alrighty. It didn't make it to -next yet though.

I'll add the patch to my tree and test with it.


Thanks,
Sasha

