Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab2IXPgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:36:41 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33069 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab2IXPgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:36:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120924221752.6537996620e5e8ef5a4965a7@canb.auug.org.au>
References: <20120924214116.211935861448f95b82f7f722@canb.auug.org.au> <20120924221752.6537996620e5e8ef5a4965a7@canb.auug.org.au>
From: Peter Moody <pmoody@google.com>
Date: Mon, 24 Sep 2012 08:36:08 -0700
Message-ID: <CALnj_=7AJCsuabWAz9s4OtM=dbqKyrJXFWUYOjR5Pdwh16CkPA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the userns tree with the security tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Eric (Paris),

this is the second time I've been notified of a merge issue with this
audit patch; Is there something I need to do (or should have done
earlier) to keep this from continuing to be an issue?

Cheers,
peter

On Mon, Sep 24, 2012 at 5:17 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi,
>
> On Mon, 24 Sep 2012 21:41:16 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> diff --cc kernel/auditsc.c
>> index 37f52f2,ff4798f..0000000
>> --- a/kernel/auditsc.c
>> +++ b/kernel/auditsc.c
>> @@@ -1160,32 -1151,8 +1152,38 @@@ void audit_log_task_info(struct audit_b
>>       char name[sizeof(tsk->comm)];
>>       struct mm_struct *mm = tsk->mm;
>>       struct vm_area_struct *vma;
>>  +    char *tty;
>>  +
>>  +    if (!ab)
>>  +            return;
>>
>>       /* tsk == current */
>>  +    cred = current_cred();
>>  +
>>  +    spin_lock_irq(&tsk->sighand->siglock);
>>  +    if (tsk->signal && tsk->signal->tty && tsk->signal->tty->name)
>>  +            tty = tsk->signal->tty->name;
>>  +    else
>>  +            tty = "(none)";
>>  +    spin_unlock_irq(&tsk->sighand->siglock);
>>  +
>>  +
>>  +    audit_log_format(ab,
>>  +                     " ppid=%ld pid=%d auid=%u uid=%u gid=%u"
>>  +                     " euid=%u suid=%u fsuid=%u"
>>  +                     " egid=%u sgid=%u fsgid=%u ses=%u tty=%s",
>>  +                     sys_getppid(),
>>  +                     tsk->pid,
>> -                      tsk->loginuid, cred->uid, cred->gid,
>> -                      cred->euid, cred->suid, cred->fsuid,
>> -                      cred->egid, cred->sgid, cred->fsgid,
>> ++                     from_kuid(&init_user_ns, tsk->loginuid),
>> ++                     from_kuid(&init_user_ns, context->uid),
>> ++                     from_kgid(&init_user_ns, context->gid),
>> ++                     from_kuid(&init_user_ns, context->euid),
>> ++                     from_kuid(&init_user_ns, context->suid),
>> ++                     from_kuid(&init_user_ns, context->fsuid),
>> ++                     from_kgid(&init_user_ns, context->egid),
>> ++                     from_kgid(&init_user_ns, context->sgid),
>> ++                     from_kgid(&init_user_ns, context->fsgid),
>
> These should all be "cred" not "context", of course.  I fixed this in my
> tree.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 
Peter Moody      Google    1.650.253.7306
Security Engineer  pgp:0xC3410038
