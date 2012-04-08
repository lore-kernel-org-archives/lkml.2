Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2DHWFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 18:05:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40590 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2DHWE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 18:04:58 -0400
MIME-Version: 1.0
In-Reply-To: <m1iph9ewsy.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
	<CAFLxGvwyx6S6+eZtR=UNSQe_O+W7oZW=GosseL54HGpjtYGXjg@mail.gmail.com>
	<m1iph9ewsy.fsf@fess.ebiederm.org>
Date: Mon, 9 Apr 2012 00:04:56 +0200
Message-ID: <CAFLxGvwHtA028V2XudM-5HXmXCPw5ENL5E_nHKZh_gbrsRV69g@mail.gmail.com>
Subject: Re: [REVIEW][PATCH 0/43] Completing the user namespace
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 8, 2012 at 11:30 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> richard -rw- weinberger <richard.weinberger@gmail.com> writes:
>
>> On Sun, Apr 8, 2012 at 7:10 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> - Capabilities are localized to the current user namespace making
>>>  it safe to give the initial user in a user namespace all capabilities.
>>>
>>
>> So, this makes LXC and friends ready for hostile environments?
>> IOW a root user (with all capabilities) sitting in his own namespace can no
>> longer ham the host?
>
> The user namespace now restricts the root user in a container to being
> able to do no more harm than any other user can do.  Additionally suid
> executables can no longer lead to having all power on the system.  Which
> means that the only privilege escalation attacks available from a
> container require kernel bugs.
>
> With my version of user namespaces you no longer have to worry about the
> container root writing to files in /proc or /sys and changing the
> behavior of the system.  Nor do you have to worry about messages passed
> across unix domain sockets to d-bus having a trusted uid and being
> allowed to do something nasty.
>
> It allows for applications with no capabilities to use multiple
> uids and to implement privilege separation.
>
> I certainly see user namespaces like this as having the potential
> to make linux systems more secure.
>
> You will have to make your own threat assessment to decide if that is
> enough of an improvement to start deploying containers in what you
> consider hostile environments.
>
>
>
> For me the big potential I see is that it makes possible the creation of
> a container without privilege (today the uid mapping setup still
> requires privilege), and it allows a lot of things that the existence of
> suid root executables has prevented us from making unprivileged before.
>
> After the core is settled we can start looking at patches to allow
> unprivileged creation of other namespaces.  Unprivileged mounts.
> Unprivileged use of the networking stack.  Bringing many of the
> improvements that linux has seen over the years to unprivileged
> users.
>
> I also see great potential for April fools day jokes.  You log in and
> try to fix something and discover you are not the root you thought you
> were.  Does that count as a hostile environment?
>

Yep. Sounds great!
I'll give your patch set a try within the next few days on my LXC testbed. :-)

-- 
Thanks,
//richard
