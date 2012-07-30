Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab2G3XEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 19:04:20 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41306 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab2G3XER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 19:04:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120730225037.4c8dd450@ultron>
References: <20120730165848.GA28288@www.outflux.net>
	<5016FADD.1030503@canonical.com>
	<20120730225037.4c8dd450@ultron>
Date: Mon, 30 Jul 2012 16:04:16 -0700
X-Google-Sender-Auth: spmz_EScDjTh0rnvnrOzHmmtY1g
Message-ID: <CAGXu5jJ3QMk-N2xmTntQnAOXbTAW6EbbYDjQcEWRda+FfvGMOw@mail.gmail.com>
Subject: Re: [PATCH] Yama: access current->comm directly
From: Kees Cook <keescook@chromium.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 30, 2012 at 2:50 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mon, 30 Jul 2012 14:21:33 -0700
> John Johansen <john.johansen@canonical.com> wrote:
>
>> On 07/30/2012 09:58 AM, Kees Cook wrote:
>> > The core ptrace access checking routine already holds the task lock,
>> > so there is no need to use get_task_comm() which just tries to take the
>> > lock again. Drop its use and access current->comm directly.
>> >
>> > Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>> > Suggested-by: Oleg Nesterov <oleg@redhat.com>
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>> yep, looks good
>>
>> Acked-by: John Johansen <john.johansen@canonical.com>
>
>
> Code looks correct but having a weird cornercase direct reference is
> asking for an accident later. For maintainability I'd rather see that as
> __get_task_comm() or get_task_commu_unlocked() which does the job, deals
> with all the edge cases and contains a WARN_ON check on the lock.

I'd be happy to refactor this area, sure. What's the best way to check
for this lock. I see in staging:

#define ASSERT_SPINLOCK(_l)     WARN_ON(!spin_is_locked(_l))

but in other areas, I see things using the raw_ prefix:

                WARN_ON(raw_spin_is_locked(&kvm_lock));

Which is preferred for task_lock?

-Kees

-- 
Kees Cook
Chrome OS Security
