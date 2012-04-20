Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab2DTXOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 19:14:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51491 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab2DTXOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 19:14:50 -0400
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
	<1333862139-31737-22-git-send-email-ebiederm@xmission.com>
	<20120418185106.GG4984@mail.hallyn.com>
Date: Fri, 20 Apr 2012 16:18:50 -0700
In-Reply-To: <20120418185106.GG4984@mail.hallyn.com> (Serge E. Hallyn's
	message of "Wed, 18 Apr 2012 18:51:06 +0000")
Message-ID: <m1obqm56w5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19cv2Oj1jiwtXcf15N8ZB/zlmh94oB5MyE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 22/43] userns: Convert capabilities related permsion checks
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Beiderman (ebiederm@xmission.com):
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> - Use uid_eq when comparing kuids
>>   Use gid_eq when comparing kgids
>> - Use __make_kuid(user_ns, 0) to talk about the user_namespace root uid
>>   Use __make_kgid(user_ns, 0) to talk about the user_namespace root gid
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>
> though, nit,
>
>> ---
>>  fs/open.c            |    3 ++-
>>  security/commoncap.c |   43 ++++++++++++++++++++++++++++---------------
>>  2 files changed, 30 insertions(+), 16 deletions(-)
>> 

>> diff --git a/security/commoncap.c b/security/commoncap.c
>> index dbd465a..9bf8df8 100644
>> --- a/security/commoncap.c
>> +++ b/security/commoncap.c
>> @@ -472,19 +472,24 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
>>  	struct cred *new = bprm->cred;
>>  	bool effective, has_cap = false;
>>  	int ret;
>> +	kuid_t root_uid;
>> +	kgid_t root_gid;
>
> the root_gid is assigned but never used.

Thanks snipped.  It doesn't look like there will ever be a use for it.

>>  
>>  	effective = false;
>>  	ret = get_file_caps(bprm, &effective, &has_cap);
>>  	if (ret < 0)
>>  		return ret;
>>  
>> +	root_uid = make_kuid(new->user_ns, 0);
>> +	root_gid = make_kgid(new->user_ns, 0);
>> +

Eric
