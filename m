Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab1BRDxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:53:47 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53720 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab1BRDxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:53:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217162146.1b8e45e0.akpm@linux-foundation.org>
Date: Thu, 17 Feb 2011 19:53:37 -0800
In-Reply-To: <20110217162146.1b8e45e0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 17 Feb 2011 16:21:46 -0800")
Message-ID: <m1vd0i6lry.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19r1ZBBUA7PB4ZOJs1WWm/yNx1W+EmSPsQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: userns: targeted capabilities v5
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 17 Feb 2011 15:02:24 +0000
> "Serge E. Hallyn" <serge@hallyn.com> wrote:
>
>> Here is a repost of my previous user namespace patch, ported onto
>> last night's git head.
>> 
>> It fixes several things I was doing wrong in the last (v4)
>> posting, in particular:
>> 
>> 	1. don't set uts_ns->user_ns to current's when !CLONE_NEWUTS
>> 	2. add a ipc_ns->user_ns which owns ipc_ns, and use that to
>> 	   decide CAP_IPC_OWNER
>> 	3. fix logic flaw caused by bad parantheses
>> 	4. allow do_prlimit to current
>> 	5. don't always give root full privs to init_user_ns
>> 
>> The expected course of development for user namespaces is laid out
>> at https://wiki.ubuntu.com/UserNamespace.
>
> Seems like a nice feature to be developing.
>
> I worry about the maturity of it all at this stage.  How far along is
> it *really*?
>
> Is anyone else working with you on developing and reviewing this work?

I did a lot of the initial design and I have been reviewing as I have
time.

Andrew at a practical level we have to merge this incrementally.
Anything much bigger than Serge's current patchset will be too big to
review.  The first really bit step is making capabilities local to the
user namespace, and that is what this patchset does along with using
that localness in some good places.

Eric

