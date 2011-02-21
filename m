Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1BUOXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:23:48 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:39287 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab1BUOXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:23:46 -0500
Message-ID: <4D627562.7050002@free.fr>
Date: Mon, 21 Feb 2011 15:23:30 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@osdl.org>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 1/4] userns: let clone_uts_ns() handle setting uts->user_ns
References: <20110221040156.GA12580@mail.hallyn.com> <4D623886.3010505@free.fr> <20110221134129.GA15563@redhat.com> <20110221135803.GA15871@mail.hallyn.com>
In-Reply-To: <20110221135803.GA15871@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 02:58 PM, Serge E. Hallyn wrote:
> Quoting Oleg Nesterov (oleg@redhat.com):
>> On 02/21, Daniel Lezcano wrote:
>>> On 02/21/2011 05:01 AM, Serge E. Hallyn wrote:
>>>> To do so we need to pass in the task_struct who'll get the utsname,
>>>> so we can get its user_ns.
>>>>
>>>> -extern struct uts_namespace *copy_utsname(unsigned long flags,
>>>> -					struct uts_namespace *ns);
>>>> +extern struct uts_namespace *copy_utsname(struct task_struct *tsk,
>>>> +					  unsigned long flags,
>>>> +					  struct uts_namespace *ns);
>>> Why don't we pass 'user_ns' instead of 'tsk' ? that will look
>>> semantically clearer for the caller no ?
>>> (example below).
>>> ...
>>>
>>> new_nsp->uts_ns = copy_utsname(flags, tsk->nsproxy->uts_ns, task_cred_xxx(tsk, user)->user_ns);
>> To me tsk looks more readable, I mean
>>
>> 	new_nsp->uts_ns = copy_utsname(flags, tsk);
>>
>> copy_utsname() can find both uts_ns and user_ns looking at task_strcut.
> Uh, yeah.  I should remove the 'ns' argument there shouldn't I.
>
> Daniel, does that sway your opinion then?

Well, I prefer to pass the needed parameters to a function. AFAICS, 
'tsk' is not really needed but 'user_ns'.
But it is a detail, so if passing the tsk parameter in the other copy_* 
functions helps to cleanup, that will be consistent.
So I am fine with that.

