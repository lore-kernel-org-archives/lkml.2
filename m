Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab2LMWzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:55:52 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:47095 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab2LMWzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:55:51 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        LSM List <linux-security-module@vger.kernel.org>
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
	<87mwxhtxve.fsf@xmission.com> <87zk1hshk7.fsf_-_@xmission.com>
	<CA+55aFwXnFEFXbkwFPq9xt30xp2_6jfpBLd3E2bms79KKK=V1Q@mail.gmail.com>
Date: Thu, 13 Dec 2012 14:55:42 -0800
In-Reply-To: <CA+55aFwXnFEFXbkwFPq9xt30xp2_6jfpBLd3E2bms79KKK=V1Q@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 13 Dec 2012 14:43:36 -0800")
Message-ID: <87zk1hr28h.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/9PgD+4Au9yG1Xc14lIPGdfyChLQ+Iq4k=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1765]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] Fix cap_capable to only allow owners in the parent user namespace to have caps.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Dec 13, 2012 at 2:39 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> Andy Lutomirski pointed out that the current behavior of allowing the
>> owner of a user namespace to have all caps when that owner is not in a
>> parent user namespace is wrong.
>>
>> This is a bug introduced by the kuid conversion which made it possible
>> for the owner of a user namespace to live in a child user namespace.  I
>> goofed and totally missed this implication.
>
> Hmm. Shouldn't this be cc: stable if it was introduced in the kuid
> conversion? Or is it only an issue with your new namespace tree (which
> I haven't pulled yet)?

It should be CC stable.

I think I have fixed the bug I am hoping to get a second pair of eyeballs
before I send the patch officially.

The test for &init_user_ns keeps the bugs from affecting kernels with user
namespaces disabled.

The bug exists in 3.5 and 3.6 but barely matters because you can't
enable user namespaces without additional patches.

The bug exists in 3.7 but is should be of limited affect because
distributions are likely to prefer enabling nfs and fuse over user
namespaces.

I am going to step away for about an hour or so and then with hopefully
fresh eyes myself work to push the good version.  

Eric
