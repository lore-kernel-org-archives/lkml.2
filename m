Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab2LNWcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:32:25 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:37541 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab2LNWcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:32:21 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-security-module@vger.kernel.org
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
	<87mwxhtxve.fsf@xmission.com> <87zk1hshk7.fsf_-_@xmission.com>
	<20121214032820.GA5115@mail.hallyn.com> <87bodxi9zw.fsf@xmission.com>
	<20121214152607.GA9266@mail.hallyn.com> <87bodwd4aw.fsf@xmission.com>
	<20121214161514.GA9962@mail.hallyn.com> <87r4ms5wpm.fsf@xmission.com>
	<20121214202921.GA11450@mail.hallyn.com>
Date: Fri, 14 Dec 2012 14:32:12 -0800
In-Reply-To: <20121214202921.GA11450@mail.hallyn.com> (Serge E. Hallyn's
	message of "Fri, 14 Dec 2012 20:29:21 +0000")
Message-ID: <87bodww9hv.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+0WCL8+ql0WVktDNDncJsJDBQGdrQW7m0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0005]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] Fix cap_capable to only allow owners in the parent user namespace to have caps.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):

>> A child user namespace having capabilities against processes in it's
>> parent seems totally bizarre and pretty dangerous from a capabilities
>> standpoint.
>
> How would it have them against its parent?

init_user_ns
   userns a --- created by kuid 1
     userns b -- created by kuid 2
        process c in userns b with kuid 1

Serge read the first permisison check in common_cap. 
Think what happens in the above example.

For the rest I understand your concern.

Serge please read and look at the patches I have posted to fix
the issues Andy found with the user namespace tree.  Especially
the fix to commit_creds.

After you have looked at the patches to fix the issues I will
be happy to discuss things further with you.

Eric

