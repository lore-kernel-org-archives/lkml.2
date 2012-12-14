Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab2LNVn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 16:43:56 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:37835 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab2LNVnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 16:43:53 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        LSM List <linux-security-module@vger.kernel.org>
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
	<87mwxhtxve.fsf@xmission.com> <87zk1hshk7.fsf_-_@xmission.com>
	<20121214032820.GA5115@mail.hallyn.com> <87bodxi9zw.fsf@xmission.com>
	<20121214152607.GA9266@mail.hallyn.com> <87bodwd4aw.fsf@xmission.com>
	<20121214161514.GA9962@mail.hallyn.com> <87r4ms5wpm.fsf@xmission.com>
	<CA+55aFw5CMf0-o=yDt2Rj-SYH4pfW1L9QbNb6uKHEdzAyYcvGQ@mail.gmail.com>
Date: Fri, 14 Dec 2012 13:43:41 -0800
In-Reply-To: <CA+55aFw5CMf0-o=yDt2Rj-SYH4pfW1L9QbNb6uKHEdzAyYcvGQ@mail.gmail.com>
	(Linus Torvalds's message of "Fri, 14 Dec 2012 10:43:15 -0800")
Message-ID: <87wqwkz4vm.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19ujWisIi8JEoszTM9NCO9XRM4yFqaQESw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0655]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] Fix cap_capable to only allow owners in the parent user namespace to have caps.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, Dec 14, 2012 at 10:12 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> That said Serge I think I have lost track of the point of your question.
>
> .. and I'm a bit unsure what I should do about this all. Including
> pulling the pull request that actually can make this all matter.
>
> Hmm? Any consensus?

It looks like we have consensus (baring the color of the shed)
of what the code should look like for v3.8.

>From the most embarrassingly timed, but most useful review by Andy I have
4 fixes queued up in my development tree.

Fixing cap_capable to test for the parent namespace.
Fixing setns to require nsown_capable(CAP_SYS_ADMIN)
--
Fixing commit_creds to not clear task dumpable unnecessarily.
Fixing a typo in the description.

What I would like to do is to do is what I would if this was not the
middle of the merge window with changes like this.

Toss those patches out for last round of review.

Possibly toss the last two patches if there are any problems because
they are not necessary.

Put the patches in my for-next branch and have them sit in linux-next
for a day or three. 

Send you an updated pull request.


I am recovering from a cold so I am running slower than I would like
this week and would really rather not rush getting these patches out.

What I don't want to be is so cautious and careful that you decide to
pass on my pull request.  The code is harmless with user namespaces
disabled.  The code has been baking for a long time, some of it for much
too long and it is as solid as I think it will get out before being
merged.  Nor is the code complex Andy managed to dig and figure it all
out in about a day.

Linus does that work for you?

Eric
