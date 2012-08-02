Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2HBLL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 07:11:58 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:44637 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2HBLLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 07:11:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        spender@grsecurity.net
References: <alpine.LFD.2.02.1203231926000.2542@ionos>
	<20120323190855.GA27213@www.outflux.net>
	<CAFLxGvzPVPyXPwjay4a01q1vx4K4Ht56bHjzswYrr1wvB_1dYw@mail.gmail.com>
Date: Thu, 02 Aug 2012 04:11:41 -0700
In-Reply-To: <CAFLxGvzPVPyXPwjay4a01q1vx4K4Ht56bHjzswYrr1wvB_1dYw@mail.gmail.com>
	(richard's message of "Thu, 2 Aug 2012 12:35:57 +0200")
Message-ID: <87pq7935w2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/wd0Jn2EXs6XBMto5EyOMyYi8sD0IucMA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;richard -rw- weinberger <richard.weinberger@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] futex: mark get_robust_list as deprecated
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

richard -rw- weinberger <richard.weinberger@gmail.com> writes:

> On Fri, Mar 23, 2012 at 8:08 PM, Kees Cook <keescook@chromium.org> wrote:
>> Notify get_robust_list users that the syscall is going away.
>>
>> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>
> I'm using this system call in an application and noticed that's marked
> as deprecated now.
> My application collects all kind of information from crashing programs.
> It's installed in /proc/sys/kernel/core_pattern.
>
> If program X is crashing it executes get_robust_list(X) to get the
> address of the robust list
> and reads the list from /proc/X/mem.
>
> Is there another way to get the robust list from another program (by it's pid)?

The folks doing checkpoint/restart claim to not need this, so there
might be a way either that or they just haven't hit this problem yet.

What you are doing sounds like a reasonable use of get_robust_list to me.

Eric
