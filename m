Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2HCNHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:07:48 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:45909 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2HCNHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:07:45 -0400
References: <1343991184-3619-1-git-send-email-berrange@redhat.com> <cfa2e2c9-db52-40cd-979b-7a6084427190@email.android.com> <20120803125210.GD12870@redhat.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120803125210.GD12870@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 03 Aug 2012 06:07:36 -0700
To: "Daniel P. Berrange" <berrange@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Message-ID: <bef31b2b-429b-4b2b-981b-b230f9c6bfad@email.android.com>
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX196v8bslMbW/glsLBDdA/jShGwIXT2GvuI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3029]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Daniel P. Berrange" <berrange@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Forbid invocation of kexec_load() outside initial PID namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Daniel P. Berrange" <berrange@redhat.com> wrote:

>On Fri, Aug 03, 2012 at 05:45:40AM -0700, Eric W. Biederman wrote:
>> The solution is to use user namespaces and to only test ns_capable on
>the magic reboot path.
>> 
>> For the 3.7 timeframe that should be a realistic solution.
>
>Hmm, that would imply that if LXC wants to allow reboot()/CAP_SYS_BOOT
>they will be forced to use CLONE_NEWUSER. I was rather looking for a
>way
>to allow the container to keep CAP_SYS_BOOT, without also mandating use
>of user namespaces.

If we remove the use of CAP_SYS_BOOT on the container reboot path perhaps.

But you have hit one small issue in the huge pile of issues why giving contaners capabilities is generally a bad idea.

This is the reason I have been insisting on a reasonable version of user namespaces for a long time.

When the security issues become important it is time for user namespaces.   That is their purpose.

Eric



