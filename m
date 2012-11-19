Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab2KSEF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 23:05:26 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39370 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2KSEFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 23:05:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKSD8nRMJ11DpKRe8M79W9MZ2eowAafXOQ9_WCj4dZXug@mail.gmail.com>
References: <507F7313.8010707@oracle.com> <CAGXu5jKSD8nRMJ11DpKRe8M79W9MZ2eowAafXOQ9_WCj4dZXug@mail.gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sun, 18 Nov 2012 23:05:04 -0500
Message-ID: <CA+1xoqdJ=mF6MUPRYm7CmE_fa8GshtjxUpwwYPCKY4ob+gDAeQ@mail.gmail.com>
Subject: Re: yama: lockdep warning on yama_ptracer_del
To: Kees Cook <keescook@chromium.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, james.l.morris@oracle.com,
        John Johansen <john.johansen@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-security-module@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On Thu, Oct 18, 2012 at 6:39 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Oct 17, 2012 at 8:10 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> Hi all,
>>
>> I was fuzzing with trinity within a KVM tools guest (lkvm) on a linux-next kernel, and got the
>> following dump which I believe to be noise due to how the timers work - but I'm not 100% sure.
>> ...
>> [  954.674123]  Possible interrupt unsafe locking scenario:
>> [  954.674123]
>> [  954.674123]        CPU0                    CPU1
>> [  954.674123]        ----                    ----
>> [  954.674123]   lock(ptracer_relations_lock);
>> [  954.674123]                                local_irq_disable();
>> [  954.674123]                                lock(&(&new_timer->it_lock)->rlock);
>> [  954.674123]                                lock(ptracer_relations_lock);
>> [  954.674123]   <Interrupt>
>> [  954.674123]     lock(&(&new_timer->it_lock)->rlock);
>> [  954.674123]
>> [  954.674123]  *** DEADLOCK ***
>
> I've been wanting to get rid of the Yama ptracer_relations_lock
> anyway, so maybe I should do that now just to avoid this case at all?

I still see this one in -rc6, is there anything to get rid of it
before the release?


Thanks,
Sasha
