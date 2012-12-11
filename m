Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2LKTiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:38:21 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:32830 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2LKTiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:38:20 -0500
MIME-Version: 1.0
In-Reply-To: <50C78927.6080302@linaro.org>
References: <1355242260-28762-1-git-send-email-stefani@seibold.net> <50C78927.6080302@linaro.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Dec 2012 11:37:59 -0800
Message-ID: <CALCETrUFsHPrzm-B=9fJac_-3b+sihWmW2sev23B4zXSh2PBqQ@mail.gmail.com>
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
To: John Stultz <john.stultz@linaro.org>
Cc: stefani@seibold.net, linux-kernel@vger.kernel.org, ak@linux.intel.com,
        aarcange@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 11:27 AM, John Stultz <john.stultz@linaro.org> wrote:
> On 12/11/2012 08:11 AM, stefani@seibold.net wrote:
>>
>> From: Stefani Seibold <stefani@seibold.net>
>>
>> This small patch add the functions vdso_gettimeofday(),
>> vdso_clock_gettime()
>> and vdso_time() support to the VDSO for x86 32-bit kernels.
>>
>> The reason to do this was to get a fast reliable time stamp. Many
>> developers
>> uses TSC to get a fast time time stamp, without knowing the pitfalls. VDSO
>> time functions a fast and reliable way, because the kernel knows the best
>> time
>> source and the P- and C-state of the CPU.
>
> Very cool. There have been similar implementations of this patch over the
> years, but they were all bit more hackish then this.
>
>
>
>> For x86 the vclock_gettime.c currently supports only the HPET and TSC
>> timer,
>> the ACPI timer should be easily to add with an other patch.
>
> Although the ACPI PM timer requires port-io which would need tweaking to
> allow normal users to access it. And I'm not sure if the performance would
> be much improved, as the port-io probably dominates the performance cost.
>

I'd actually advocate going the other way and removing hpet vdso
support.  Last time I benchmarked this, a syscall took about 20ns on
my box, and reading the hpet counter took about 750ns, giving
approximately no gain to the hpet-via-vdso optimization.

--Andy
