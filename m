Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2HRWWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 18:22:20 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34672 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2HRWWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 18:22:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1344961490-4068-1-git-send-email-levinsasha928@gmail.com>
	<1344961490-4068-3-git-send-email-levinsasha928@gmail.com>
	<87txw5hw0s.fsf@xmission.com> <50300E9A.1060501@gmail.com>
Date: Sat, 18 Aug 2012 15:21:59 -0700
In-Reply-To: <50300E9A.1060501@gmail.com> (Sasha Levin's message of "Sat, 18
	Aug 2012 23:52:26 +0200")
Message-ID: <877gsvzvqw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18+DQTxc9VfVuyKsXqQlr7n7yEn7cJDLk8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <levinsasha928@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 02/16] user_ns: use new hashtable implementation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> On 08/15/2012 01:52 AM, Eric W. Biederman wrote:
>> Sasha Levin <levinsasha928@gmail.com> writes:
>>> > Switch user_ns to use the new hashtable implementation. This reduces the amount of
>>> > generic unrelated code in user_ns.
>> Two concerns here.
>> 1) When adding a new entry you recompute the hash where previously that
>>    was not done.  I believe that will slow down adding of new entries.
>
> Since the hashtable doesn't expose the internal hashing to the user of the
> hashtable it would require adding a new interface to deal with in.
>
> I don't feel that a whole new interface to optimize out something which is very
> cheap (one multiplication + shift) in this case, I'd rather avoid having a new
> interface.
>
> Is it ok with you if I leave it as is in the next version of the
> patch?

No problem.  I was largely reviewing for potential gotchas, and things
that make me go hmm.

I don't think setuid is called enough for the hash table to be much of
a hotpath.  Although I haven't profiled it.

Eric

