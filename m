Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab2FEM4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:56:06 -0400
Received: from mx2.parallels.com ([64.131.90.16]:33840 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab2FEM4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:56:04 -0400
Message-ID: <4FCE0157.4080007@parallels.com>
Date: Tue, 5 Jun 2012 16:53:43 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@free.fr>
CC: Serge Hallyn <serge.hallyn@canonical.com>, <kir@parallels.com>,
        <Michael@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        <linux-kernel@vger.kernel.org>, Kerrisk <mtk.manpages@gmail.com>,
        Tejun Heo <tj@kernel.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Devel] Re: [PATCH] allow a task to join a pid namespace
References: <1338816828-25312-1-git-send-email-glommer@parallels.com> <4FCDD315.502@free.fr> <4FCDD346.9090008@parallels.com> <4FCDD8A0.1070608@parallels.com> <4FCE0101.6010908@free.fr>
In-Reply-To: <4FCE0101.6010908@free.fr>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 04:52 PM, Daniel Lezcano wrote:
> On 06/05/2012 12:00 PM, Glauber Costa wrote:
>> On 06/05/2012 01:37 PM, Glauber Costa wrote:
>>> On 06/05/2012 01:36 PM, Daniel Lezcano wrote:
>>>> On 06/04/2012 03:33 PM, Glauber Costa wrote:
>>>>> Currently, it is possible for a process to join existing
>>>>> net, uts and ipc namespaces. This patch allows a process to join an
>>>>> existing pid namespace as well.
>>>>>
>>>>> For that to remain sane, some restrictions are made in the calling
>>>>> process:
>>>>>
>>>>> * It needs to be in the parent namespace of the namespace it wants to
>>>>> jump to
>>>>> * It needs to sit in its own session and group as a leader.
>>>>>
>>>>> The rationale for that, is that people want to trigger actions in a
>>>>> Container
>>>>> from the outside. For instance, mainstream linux recently gained the
>>>>> ability
>>>>> to safely reboot a container. It would be desirable, however, that
>>>>> this
>>>>> action is triggered from an admin in the outside world, very much
>>>>> like a
>>>>> power switch in a physical box.
>>>>>
>>>>> This would also allow us to connect a console to the container,
>>>>> provide a
>>>>> repair mode for setups without networking (or with a broken one), etc.
>>>>
>>>> Hi Glauber,
>>>>
>>>> I am in favor of this patch but I think the pidns support won't be
>>>> complete and some corner-cases are not handled.
>>>>
>>>> May be you can look at Eric's patchset [1] where, IMO, everything is
>>>> taken into account. Some of the patches may be already upstream.
>>>>
>>>> Thanks
>>>> -- Daniel
>>>
>>> I don't remember seeing such patchset in the mailing lists, but that
>>> might be my fault, due to traffic...
>>>
>>> I'll take a look. If it does what I need, I can just drop this.
>>>
>>
>> Ok. In a quick look, it does not seem to go all the way. This is just
>> by reading, but your reboot patch, for instance, is unlikely to work
>> with that, since if it doesn't alter pid->level, things like task
>> ns_of_pid won't work.
>>
>> Running the test scripts I wrote for my testing of that patch also
>> doesn't seem to produce the expected result:
>>
>> after doing setns, the pid won't show up in that namespace.
>
> Yes, AFAIR, pid won't show up, you have to do fork-exec.

Ah, so you mean the kid will show up... Well, ok.

That's acceptable, but how about the behavior I am proposing ? (in the 
patch I sent as a reply to this thread).

I believe it to be saner, even though there is a price tag attached to 
it. None of the other setns calls require you to do any such trickery...

