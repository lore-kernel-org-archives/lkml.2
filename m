Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1AGUKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:10:53 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:39266 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1AGUKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:10:52 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eric Paris <eparis@parisplace.org>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, eparis@redhat.com
References: <1294302325-22593-1-git-send-email-amwang@redhat.com>
	<m1bp3uifln.fsf@fess.ebiederm.org>
	<AANLkTinLhAuSny735kofonAkaqwJvjjDHMUed_r03rVc@mail.gmail.com>
Date: Fri, 07 Jan 2011 12:10:44 -0800
In-Reply-To: <AANLkTinLhAuSny735kofonAkaqwJvjjDHMUed_r03rVc@mail.gmail.com>
	(Eric Paris's message of "Thu, 6 Jan 2011 14:02:47 -0500")
Message-ID: <m1k4igjwzf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19H4/ZA2IExXPvxXw7t4DuwoZOzDDSRhMo=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Eric Paris <eparis@parisplace.org>
X-Spam-Relay-Country: 
Subject: Re: [Patch] kexec_load: check CAP_SYS_MODULE
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@parisplace.org> writes:

> On Thu, Jan 6, 2011 at 3:47 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Amerigo Wang <amwang@redhat.com> writes:
>>
>>> Eric pointed out that kexec_load() actually allows you to
>>> run any code you want in ring0, this is more like CAP_SYS_MODULE.
>>
>> Let me get this straight you want to make the permission checks
>> less stringent by allowing either CAP_SYS_MODULE or CAP_SYS_BOOT?
>
> Nope, read my patch again.  It actually requires BOTH of them.

Ah right.  Testing the negative and going to -EPERM.

>> CAP_SYS_BOOT is the correct capability.  Sure you can run any
>> code but only after rebooting.  I don't see how this differs
>> from any other reboot scenario.
>
> The difference is that after a reboot the bootloader and the system
> control what code is run.  kexec_load() immediately runs the new
> kernel which is not controlled by the bootloader or by the system.
> Imagine a situation where the bootloader and the /boot directory are
> RO (enforced by hardware).   kexec_load() would let you run any kernel
> code you want on the box whereas reboot would not.

The scenario is imaginable (not common but imaginable) but I don't see
how requiring CAP_SYS_MODULE makes anything better.

If I was building a configuration where I didn't want anyone to be able
to direct the kernel into a different state by locking down the
bootloaders I expect I would compile out the syscall as well.

Most bootloaders have the option of booting something else the mechanism
is just different. I really don't see what the addition of
CAP_SYS_MODULE gains you.

Right now CAP_SYS_BOOT still makes sense to me and CAP_SYS_MODULE stills
seems like nonsense in this context.

Eric
