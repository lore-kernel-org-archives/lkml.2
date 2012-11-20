Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab2KTRXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:23:01 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40154 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2KTRW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:22:59 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steve French <smfrench@gmail.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Steve French <sfrench@samba.org>
References: <87pq38wimv.fsf@xmission.com>
	<1353415420-5457-1-git-send-email-ebiederm@xmission.com>
	<1353415420-5457-4-git-send-email-ebiederm@xmission.com>
	<CAH2r5mt91Av7w6GQUPNu2A9EGRNbPGGAhMO=EobOMi5Cn8gh5g@mail.gmail.com>
Date: Tue, 20 Nov 2012 09:22:42 -0800
In-Reply-To: <CAH2r5mt91Av7w6GQUPNu2A9EGRNbPGGAhMO=EobOMi5Cn8gh5g@mail.gmail.com>
	(Steve French's message of "Tue, 20 Nov 2012 10:56:40 -0600")
Message-ID: <87lidwqjdp.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18psH8+QZ937nTWEeSdosJn4Mmi2yDL0R0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0018]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Steve French <smfrench@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH RFC 04/12] userns: Convert cifs to use kuid/kgid where appropriate
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> Do you have a pointer to the background on kuid/kgid

You might try this lwn article
https://lwn.net/Articles/491310/

In a nutshell each user namespace has it's own view of uid_t and gid_t
values.  Those values are mapped into kernel internal kuid_t and kgid_t
values.  Then user space interfaces convert from kuid_t and kgid_t when
read from userspace.

The initial user namespace as a 1-1 identity mapping between kuid_t and
uid_t values.

kuid_t and kgid_t are not assignment compatible with uid_t and gid_t so
that if the conversions are left out a compile error results.

My strategy is to push kuid_t and kgid_t values as deeply into the
kernel data structures as possible so that there is a high propbability
that when we get it wrong a compile error will happen.

Eric
