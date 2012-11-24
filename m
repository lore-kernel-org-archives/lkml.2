Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab2KXXuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 18:50:21 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37964 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2KXXuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 18:50:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>, Matt Fleming <matt.fleming@intel.com>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
	<1353482170-10160-12-git-send-email-yinghai@kernel.org>
	<50AD0CA1.8000904@zytor.com>
	<CAE9FiQUSjRT-r5ZE3WHVaKkUOhwFWkm9CTCv1Aa63DOsfMQMiQ@mail.gmail.com>
	<50AD291A.10600@zytor.com>
	<CAE9FiQVed0tXhbtmc_Gug0gFZ=s=j=N4B5Vr2_ZTmSj6L-65dw@mail.gmail.com>
	<a1ca794a-09d4-4d36-8c8c-67100cb3696e@email.android.com>
	<CAE9FiQXJO8uxT9Gzjv9e8XeiLzwBX7fwTFzDVy=oPfboG4L=3Q@mail.gmail.com>
	<CAE9FiQWeGz2TkLBrBZcoPrNABx51XK3xk58P+Zam_LRGoJdSiw@mail.gmail.com>
	<a8b15bf0-4e3b-4fde-9190-26890f9abf77@email.android.com>
	<CAE9FiQUoj9k0Tbqp8LC8Wb21_s_x8naiWX4zkX9pJG-oFnAQ9g@mail.gmail.com>
	<50AE70E7.6060204@zytor.com> <87haofi3d3.fsf@xmission.com>
	<50B104BC.90208@zytor.com> <50B124E9.400@zytor.com>
Date: Sat, 24 Nov 2012 17:50:10 -0600
In-Reply-To: <50B124E9.400@zytor.com> (H. Peter Anvin's message of "Sat, 24
	Nov 2012 11:50:01 -0800")
Message-ID: <87vccud0i5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19d0BjyA7P3YZCmxe60C4Z2Lh4/7JkEC/U=
X-SA-Exim-Connect-IP: 75.135.205.0
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 11/12] x86, boot: add fields to support load bzImage and ramdisk high
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 11/24/2012 09:32 AM, H. Peter Anvin wrote:
>> On 11/24/2012 04:37 AM, Eric W. Biederman wrote:
>>>
>>> Certainly /sbin/kexec isn't bothering to calculate the end of the setup
>>> header and just being far more conservative and using all of the 16bit
>>> real mode code as it's initializer.
>>>
>>
>> That's not conservative... that's just plain wrong.  It means you're
>> initializing the fields in struct boot_params with garbage instead of a
>> predictable value (zero).

It was conservative at the time the code was introduced and it most
definitely is not wrong.  The code predates the verbage in boot.txt.
Apparently no one bothered to see what /sbin/kexec was actually doing
when they documented the 32bit boot loader interface.  I was under the
impression that it was actual practice that was documented but in this
particular something else was documented instead.  Since /sbin/kexec did
not need any of the more recent features we simply have not noticed it
until now.

>> We could work around it with a sentinel hack... except you *also*
>> probably modify *some* fields and now we have a horrid mix of
>> initialized and uninitialized fields to sort out... and there really
>> isn't any sane way for the kernel to sort that out.
>>
>> We have a huge problem on our hands now because of it.
>>
>
> So, given the mess we now have on our hands... any suggestions how to best solve
> it?  There is the option of simply declaring old kexec binaries broken; they
> will then not work reliably with newer kernels, if they even work reliably now
> -- it is hard to know for certain.

I believe all added variables between the last version of the boot
protocol /sbin/kexec knows about and the current time were added in the
initialized data section.  Certainly we can check and that will tell us
how likely changes in arch/x86/boot/ have been regressions in the 32bit
entry point support.

As for solving this there is a simple solution.  Add a second jump
right after the first jump.   The variables after the second jump can
all be zero initialized.

And if we really care about breaking other boot loaders we can take a
survey and actually look and see what they do.  There really aren't that
many x86 boot loaders.

Eric
