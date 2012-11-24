Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063Ab2KXMh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 07:37:26 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:53853 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab2KXMhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 07:37:24 -0500
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
	<50AE70E7.6060204@zytor.com>
Date: Sat, 24 Nov 2012 04:37:12 -0800
In-Reply-To: <50AE70E7.6060204@zytor.com> (H. Peter Anvin's message of "Thu,
	22 Nov 2012 10:37:27 -0800")
Message-ID: <87haofi3d3.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19foSl5IaU36goWBB/2yq46Ios7OJaTV3A=
X-SA-Exim-Connect-IP: 75.135.205.0
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 11/12] x86, boot: add fields to support load bzImage and ramdisk high
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 11/22/2012 10:28 AM, Yinghai Lu wrote:
>>
>> has problem with old kexec, it only copy header from bzImage include
>> setup_header as boot_param.
>>
>
> How old are we talking here? This is a clear and blatant bug, and it would
> affect a whole bunch of things, not just this.  In fact, one really has to
> wonder how it can work at all.
>
> One option I guess would be to have a sentinel field which, if it is not zero,
> causes the kernel to zero all of struct setup_info outside of
> setup_header... however, I have a nasty suspicion that this kexec botch might be
> initializing some fields and leaving others unmodified, which basically means
> "there is no hope for sanity and it is just working by pure accident."
>
> Eric, do you have any insight here?

I seem to be missing something.

With respect to boot parameters when we are booting a bzImage
/sbin/kexec initializes the boot parameters with all of the 16bit real
mode code.  aka (setup_sects + 1) * 512 bytes.

I remember adding that as soon as we started having to deal with
pre-initialized fields in boot_params.

I don't have a clue what you folks are referring to as a bug.  

Looking I see this verbage in boot.txt

> For machine with some new BIOS other than legacy BIOS, such as EFI,
> LinuxBIOS, etc, and kexec, the 16-bit real mode setup code in kernel
> based on legacy BIOS can not be used, so a 32-bit boot protocol needs
> to be defined.
> 
> In 32-bit boot protocol, the first step in loading a Linux kernel
> should be to setup the boot parameters (struct boot_params,
> traditionally known as "zero page"). The memory for struct boot_params
> should be allocated and initialized to all zero. Then the setup header
> from offset 0x01f1 of kernel image on should be loaded into struct
> boot_params and examined. The end of setup header can be calculated as
> follow:
> 
> 	0x0202 + byte value at offset 0x0201
> 
> In addition to read/modify/write the setup header of the struct
> boot_params as that of 16-bit boot protocol, the boot loader should
> also fill the additional fields of the struct boot_params as that
> described in zero-page.txt.

Certainly /sbin/kexec isn't bothering to calculate the end of the setup
header and just being far more conservative and using all of the 16bit
real mode code as it's initializer.

Eric
