Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab1E0R7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:59:30 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49632 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1E0R7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:59:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: prasad@linux.vnet.ibm.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck\, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        anderson@redhat.com
References: <20110526170722.GB23266@in.ibm.com>
	<20110526171209.GA17988@in.ibm.com>
Date: Fri, 27 May 2011 10:59:11 -0700
In-Reply-To: <20110526171209.GA17988@in.ibm.com> (K. Prasad's message of "Thu,
	26 May 2011 22:42:09 +0530")
Message-ID: <m1tycg9g9c.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+9x55Ko1Zy/DbN6VxZlq5sWNicv5SPrag=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;prasad@linux.vnet.ibm.com
X-Spam-Relay-Country: 
Subject: Re: [Patch 1/6] XPANIC: Add extended panic interface
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"K.Prasad" <prasad@linux.vnet.ibm.com> writes:

> commit e668fa1aea7844ac4c7ea09030a2f3e647a4adb1
> Author: Andi Kleen <ak@linux.intel.com>
> Date:   Fri Nov 19 18:36:44 2010 +0100
>
>     XPANIC: Add extended panic interface
>     
>     One panic size doesn't fit all.
>     
>     Machine check has some special requirements on panic, like:
>     - It wants to do a reboot timeout by default so that the machine
>     check event can be logged to disk after warm reboot.

There is certainly not comment to that effect and I have not see a
mechanism that does that.

>     - For memory errors it usually doesn't want to do crash dumps because
>     that can lead to crash loops (dumping corrupted memory would
>     lead to another machine check)

It usually doesn't, and it would not lead to a crash loop just a failure
to capture the cause of the crash.

>     - It doesn't want to do backtraces because machine checks
>     are not a kernel bug.

But it sure is nice to know where it happened anyway, so you can guess
the damage.  This sounds like more of the Andi thing where he doesn't
want to hear about memory errors, because it is not a software problem.

That is definitely not sufficient reason to turn off backtraces.

>     In a earlier patch this was done with various adhoc hacks,
>     but it's cleaner to extend panic to a 'xpanic' that directly
>     gets a flag and timeout argument.
>     
>     The only user right now will be x86 machine checks, but I consider
>     it likely that other users will switch to this too.
>     
>     For example one obvious candidate would be the "no root
>     found" panic which doesn't really deserve a backtrace.

That does seem like a good fit for that case.  However it doesn't seem
like a good fit for your case.

>     I exported a vpanic() interface too as a global. That's not
>     needed by the current user, but the interface has to exist
>     internally anyways and I could see how other code would
>     find a v* variant of panic useful.
>     
>     Originally based on a suggestion by H. Peter Anvin.
>     Signed-off-by: Andi Kleen <ak@linux.intel.com>

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

This entire chunk of two patches appears to be complete non-sense.

mce_panic_timeout is hard coded policy that userspace does not get
to control, that overrides userspace policy.

It looks to me like the right solution is just to delete the 
mce_panic_timeout.

As for the extra flags that you add the panic path.  They can
only make the code more fragile.

Eric
