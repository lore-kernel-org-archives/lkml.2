Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2DTXrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 19:47:03 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58731 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2DTXrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 19:47:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
	<1333862139-31737-24-git-send-email-ebiederm@xmission.com>
	<20120418185610.GA5186@mail.hallyn.com>
Date: Fri, 20 Apr 2012 16:51:00 -0700
In-Reply-To: <20120418185610.GA5186@mail.hallyn.com> (Serge E. Hallyn's
	message of "Wed, 18 Apr 2012 18:56:10 +0000")
Message-ID: <m1397y55ej.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18eZnAMfUVC0yeks5OWP906g3d3fpru6mE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 24/43] userns: Convert ptrace, kill, set_priority permission checks to work with kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Beiderman (ebiederm@xmission.com):
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Update the permission checks to use the new uid_eq and gid_eq helpers
>> and remove the now unnecessary user_ns equality comparison.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> ---

>> @@ -1389,10 +1388,8 @@ static int kill_as_cred_perm(const struct cred *cred,
>>  			     struct task_struct *target)
>>  {
>>  	const struct cred *pcred = __task_cred(target);
>> -	if (cred->user_ns != pcred->user_ns)
>> -		return 0;
>> -	if (cred->euid != pcred->suid && cred->euid != pcred->uid &&
>> -	    cred->uid  != pcred->suid && cred->uid  != pcred->uid)
>> +	if (uid_eq(cred->euid, pcred->suid) && uid_eq(cred->euid, pcred->uid) &&
>
> These should be !uid_eq() right?
>> +	    uid_eq(cred->uid,  pcred->suid) && uid_eq(cred->uid,
>pcred->uid))

Yes.

Thank you for catching this.  This kind of mistake is unfortunately much
to easy to make.

Eric
