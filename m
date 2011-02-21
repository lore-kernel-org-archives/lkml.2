Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab1BUNu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 08:50:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab1BUNu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 08:50:56 -0500
Date: Mon, 21 Feb 2011 14:41:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@osdl.org>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 1/4] userns: let clone_uts_ns() handle setting
	uts->user_ns
Message-ID: <20110221134129.GA15563@redhat.com>
References: <20110221040156.GA12580@mail.hallyn.com> <4D623886.3010505@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D623886.3010505@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21, Daniel Lezcano wrote:
>
> On 02/21/2011 05:01 AM, Serge E. Hallyn wrote:
>> To do so we need to pass in the task_struct who'll get the utsname,
>> so we can get its user_ns.
>>
>> -extern struct uts_namespace *copy_utsname(unsigned long flags,
>> -					struct uts_namespace *ns);
>> +extern struct uts_namespace *copy_utsname(struct task_struct *tsk,
>> +					  unsigned long flags,
>> +					  struct uts_namespace *ns);
>
> Why don't we pass 'user_ns' instead of 'tsk' ? that will look
> semantically clearer for the caller no ?
> (example below).
> ...
>
> new_nsp->uts_ns = copy_utsname(flags, tsk->nsproxy->uts_ns, task_cred_xxx(tsk, user)->user_ns);

To me tsk looks more readable, I mean

	new_nsp->uts_ns = copy_utsname(flags, tsk);

copy_utsname() can find both uts_ns and user_ns looking at task_strcut.

But this is cosmetic and up to you and Serge.


But. I think it makes sense to pass "tsk" argument to copy_pid_ns() as well.
This way we can remove some CLONE_PIDNS code in copy_process(), and this
looks like a nice cleanaup (even if minor) to me.

Oleg.

