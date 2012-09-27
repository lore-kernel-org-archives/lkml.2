Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2I0BHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 21:07:46 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62294 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab2I0BHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 21:07:45 -0400
Message-ID: <5063A6DD.9070202@acm.org>
Date: Wed, 26 Sep 2012 20:07:41 -0500
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Corey Minyard <cminyard@mvista.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] namespace: Add an identifier to the namespace file
References: <1348681743-16129-1-git-send-email-minyard@acm.org> <87lifwmib4.fsf@xmission.com> <50639F4F.8010404@mvista.com> <87wqzgl28h.fsf@xmission.com>
In-Reply-To: <87wqzgl28h.fsf@xmission.com>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 07:48 PM, Eric W. Biederman wrote:
> I have fixed up Serge's email address and the linux-kernel email
> address.
>
> Corey Minyard <cminyard@mvista.com> writes:
>
>> On 09/26/2012 07:16 PM, Eric W. Biederman wrote:
>>> minyard@acm.org writes:
>>>
>>>> From: Corey Minyard <cminyard@mvista.com>
>>>>
>>>> Add a unique identifier to the network namespace file.  Each namespace
>>>> will have an identifier, making it possible to find if two programs are
>>>> in the same namespace, or if a program is using a persistent
>>>> namespace.
>>> Corey.
>>>
>>> Please have a peak inside of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git userns-always-map-user-v59
>>>
>>> That implements consistent inode numbers across all of the
>>> /proc/<pid>/ns/net files in the same network namespace so it is possible
>>> to detect if one task is in the same network namespace as another.
>>>
>>> I believe that should have what you need.
>> I did think about that, but I didn't do that for two reasons: 1) It
>> seemed to go against the grain of procfs (well, and it seemed harder,
>> too) and 2) I would like to add a netfilter based upon namespace.
>>
>> The first one is now moot, of course, but I'm not sure what to do about
>> the second one. I know we have customers that are using our current VRF
>> implementation to do exactly that, but I couldn't think of a way to do
>> that. Perhaps I can use the proc inode number, because it will be fixed.
>> I'll have to look into that.
> For netfilter or any other interface what should happen is that a file
> descriptor is passed in and the network namespace is derived from the
> file descriptor.
>
> Given that netfilter is per network namespace I'm not certain how
> filtering per network namespace would make sense.
>
> When I have poked my nose into netfilter I have had the hard problem
> that I have not figured out how to translate the parameters supplied
> by userspace into a more appropriate in kernel form, so I'm not certain
> how to implement passing a file descriptor into netfilter efficiently.

Yeah, that's kind of where I am stuck, too. netfilter used to be global,
so if it's not, this may be a "You can't do that any more".

>>> I need to get my act together on a merge strategy for that bit of code.
>>>
>>>
>>>> Signed-off-by: Corey Minyard <cminyard@mvista.com>
>>>> ---
>>>> The persistent network namespaces are quite useful, but I really need
>>>> a way to determine if a program is running in one of these namespaces.
>>>> I'm not sure if this is the best way, but I couldn't come up with
>>>> much else that sounded feasible to me.
>>> A globally unique name that I need another to implement yet another
>>> namespace to deal with is something I don't even want to think about.
>> I'm not sure it's quite that bad :-).
> It is.
>
> Imagine a system with one netork namespace per user, running containers
> using vrfs.  It isn't hard to imagine plausible solutions that get you
> nested 3 deep.

I read through all the patches you had for this, and I realized what you
meant. Yeah, it's that bad.

Thanks again.

-corey
