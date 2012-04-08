Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2DHV0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 17:26:40 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52166 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab2DHV0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 17:26:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
	<CAFLxGvwyx6S6+eZtR=UNSQe_O+W7oZW=GosseL54HGpjtYGXjg@mail.gmail.com>
Date: Sun, 08 Apr 2012 14:30:21 -0700
In-Reply-To: <CAFLxGvwyx6S6+eZtR=UNSQe_O+W7oZW=GosseL54HGpjtYGXjg@mail.gmail.com>
	(richard's message of "Sun, 8 Apr 2012 19:40:52 +0200")
Message-ID: <m1iph9ewsy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/aPIeIDL/MZdPsbDl/4GaaQ64foB4F6HQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1103]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;richard -rw- weinberger <richard.weinberger@gmail.com>
X-Spam-Relay-Country: **
Subject: Re: [REVIEW][PATCH 0/43] Completing the user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

richard -rw- weinberger <richard.weinberger@gmail.com> writes:

> On Sun, Apr 8, 2012 at 7:10 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> - Capabilities are localized to the current user namespace making
>>  it safe to give the initial user in a user namespace all capabilities.
>>
>
> So, this makes LXC and friends ready for hostile environments?
> IOW a root user (with all capabilities) sitting in his own namespace can no
> longer ham the host?

The user namespace now restricts the root user in a container to being
able to do no more harm than any other user can do.  Additionally suid
executables can no longer lead to having all power on the system.  Which
means that the only privilege escalation attacks available from a
container require kernel bugs.

With my version of user namespaces you no longer have to worry about the
container root writing to files in /proc or /sys and changing the
behavior of the system.  Nor do you have to worry about messages passed
across unix domain sockets to d-bus having a trusted uid and being
allowed to do something nasty.

It allows for applications with no capabilities to use multiple
uids and to implement privilege separation.

I certainly see user namespaces like this as having the potential
to make linux systems more secure.

You will have to make your own threat assessment to decide if that is
enough of an improvement to start deploying containers in what you
consider hostile environments.



For me the big potential I see is that it makes possible the creation of
a container without privilege (today the uid mapping setup still
requires privilege), and it allows a lot of things that the existence of
suid root executables has prevented us from making unprivileged before.

After the core is settled we can start looking at patches to allow
unprivileged creation of other namespaces.  Unprivileged mounts.
Unprivileged use of the networking stack.  Bringing many of the
improvements that linux has seen over the years to unprivileged
users.

I also see great potential for April fools day jokes.  You log in and
try to fix something and discover you are not the root you thought you
were.  Does that count as a hostile environment?

Eric
