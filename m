Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab1FBN4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:56:39 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40554 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab1FBN4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:56:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>
References: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
	<BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com>
	<m18vtkq57c.fsf@fess.ebiederm.org>
	<BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com>
	<20110602134338.0c56160e@lxorguk.ukuu.org.uk>
	<BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com>
Date: Thu, 02 Jun 2011 06:56:27 -0700
In-Reply-To: <BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com> (Lucas De
	Marchi's message of "Thu, 2 Jun 2011 10:02:50 -0300")
Message-ID: <m1hb88e3qs.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/z0HdzhB1zR/eyunZcRmbGg60bvwynoNU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lucas De Marchi <lucas.demarchi@profusion.mobi>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysctl: add support for poll()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:

> On Thu, Jun 2, 2011 at 9:43 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>> The alternative is to have a process constantly polling and reading
>>> the file, which is nothing we even want to think about in 2011.
>>
>> Or to manage it properly.
>
> What if the user decides do invoke sethostname syscall "by hand"?
> Hostname would change beneath any other process that is trying to
> manage it properly. What this patch does is to notify that process
> that something happened.
>
>
>>> It's just another special case to bring us out of the UNIX stone age
>>> of doing things. :)
>>
>> Unfortunately not. It's a misguided attempt to follow stone age Unix 'one
>> short name' policy. Forget utsname node names, they are a historical
>> quirk of UUCP and friends and on many OS platforms will be limited to 15
>> chars !
>>
>> As to poll in general I can see some of the other proc files being
>> more relevant, eg for process monitoring tools being able to poll
>> in /proc/<pid> and some of the proc/sys and sysctl data that does change
>> meaningfully. Utsname however is not one of those things.
>>
>
> With this patch in, if anyone wants to manage a file under /proc/sys
> there's really a small amount of code to write. He only has to define
> the new poll struct for that file.

The support currently appears cumbersome to add, and it adds what appear
to be unnecessary wake ups (say when the hostname in another uts
namespace changes).

There is no explanation at all of why you care about the nis domainname.

Since there does not appear to be a specific problem that this problem
is being aimed at, since the code just looks like extra maintenance and
since the code needed to support this appears to be unnecessarily
cumbersome I am going to nack the patch for now.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

If the goal here is just to fix the general case then we probably
want to get inotify going on proc files instead of poll.  Either
that or we want pollable files to appear as something besides files
so that it is clear to their users that poll will work.

Eric
