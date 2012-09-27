Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2I0AtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 20:49:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33081 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2I0Asy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 20:48:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Corey Minyard <cminyard@mvista.com>
Cc: minyard@acm.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, <linux-kernel@vger.kernel.org>
References: <1348681743-16129-1-git-send-email-minyard@acm.org>
	<87lifwmib4.fsf@xmission.com> <50639F4F.8010404@mvista.com>
Date: Wed, 26 Sep 2012 17:48:46 -0700
In-Reply-To: <50639F4F.8010404@mvista.com> (Corey Minyard's message of "Wed,
	26 Sep 2012 19:35:27 -0500")
Message-ID: <87wqzgl28h.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+mx66R7l09b4U98HY/PGlmondDB8IJQ3A=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: mvista.com]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Corey Minyard <cminyard@mvista.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] namespace: Add an identifier to the namespace file
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have fixed up Serge's email address and the linux-kernel email
address.

Corey Minyard <cminyard@mvista.com> writes:

> On 09/26/2012 07:16 PM, Eric W. Biederman wrote:
>> minyard@acm.org writes:
>>
>>> From: Corey Minyard <cminyard@mvista.com>
>>>
>>> Add a unique identifier to the network namespace file.  Each namespace
>>> will have an identifier, making it possible to find if two programs are
>>> in the same namespace, or if a program is using a persistent
>>> namespace.
>> Corey.
>>
>> Please have a peak inside of
>> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git userns-always-map-user-v59
>>
>> That implements consistent inode numbers across all of the
>> /proc/<pid>/ns/net files in the same network namespace so it is possible
>> to detect if one task is in the same network namespace as another.
>>
>> I believe that should have what you need.
>
> I did think about that, but I didn't do that for two reasons: 1) It
> seemed to go against the grain of procfs (well, and it seemed harder,
> too) and 2) I would like to add a netfilter based upon namespace.
>
> The first one is now moot, of course, but I'm not sure what to do about
> the second one. I know we have customers that are using our current VRF
> implementation to do exactly that, but I couldn't think of a way to do
> that. Perhaps I can use the proc inode number, because it will be fixed.
> I'll have to look into that.

For netfilter or any other interface what should happen is that a file
descriptor is passed in and the network namespace is derived from the
file descriptor.

Given that netfilter is per network namespace I'm not certain how
filtering per network namespace would make sense.

When I have poked my nose into netfilter I have had the hard problem
that I have not figured out how to translate the parameters supplied
by userspace into a more appropriate in kernel form, so I'm not certain
how to implement passing a file descriptor into netfilter efficiently.

>> I need to get my act together on a merge strategy for that bit of code.
>>
>>
>>> Signed-off-by: Corey Minyard <cminyard@mvista.com>
>>> ---
>>> The persistent network namespaces are quite useful, but I really need
>>> a way to determine if a program is running in one of these namespaces.
>>> I'm not sure if this is the best way, but I couldn't come up with
>>> much else that sounded feasible to me.
>> A globally unique name that I need another to implement yet another
>> namespace to deal with is something I don't even want to think about.
>
> I'm not sure it's quite that bad :-).

It is.

Imagine a system with one netork namespace per user, running containers
using vrfs.  It isn't hard to imagine plausible solutions that get you
nested 3 deep.

Eric

