Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1BWOqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 09:46:13 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57462 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab1BWOqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 09:46:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: David Howells <dhowells@redhat.com>,
        LSM <linux-security-module@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com
References: <20110217150224.GA26334@mail.hallyn.com>
	<29677.1298462729@redhat.com> <20110223135814.GA1859@mail.hallyn.com>
Date: Wed, 23 Feb 2011 06:46:00 -0800
In-Reply-To: <20110223135814.GA1859@mail.hallyn.com> (Serge E. Hallyn's
	message of "Wed, 23 Feb 2011 13:58:14 +0000")
Message-ID: <m1fwreu7vb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Vbvds3/nZmZ9k56K9TJLltsX4tOfcFjQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.2 SARE_LWSHORTT BODY: SARE_LWSHORTT
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: User namespaces and keys
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting David Howells (dhowells@redhat.com):
>> 
>> I guess we need to look at how to mix keys and namespaces again.
>
>>From strictly kernel pov, at the moment, keys are strictly usable only
> by the user in your own user namespace.
>
> We may want to look at this again, but for now I think that would be a
> safe enough default.  Later, we'll probably want the user creating a
> child_user_ns to allow his keys to be inherited by the child user_ns.
> Though, as I type that, it seems to me that that'll just become a
> maintenance pain, and it's just plain safer to have the user re-enter
> his keys, sharing them over a file if needed.
>
> I'm going to not consider the TPM at the moment :)
>
>> Possibly the trickiest problem with keys is how to upcall key construction to
>> /sbin/request-key when the keys may be of a different user namespace.
>
> Hm, jinkeys, yes.

Serge short term this is where I think we need to add a check or two so
that keys only work in the init_user_ns.  When the rest of the details
are sorted out we can open up the use of keys some more.

As the first stage of converting the network stack we added patches
that turned off everything in non init namespaces.   Those patches
were trivial and easy to review, and it made the conversion process
a lot easier.  I suspect for keys and possibly security modules and
anything else that does is related we want to turn off by default.

Then once the core of user namespaces is safe to unshare without
privilege we can come back and get the more difficult bits.

Eric
