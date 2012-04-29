Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab2D2WzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 18:55:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34473 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab2D2WzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 18:55:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120429124724.GA27784@liondog.tnic>
References: <20120227115905.GB9943@elte.hu>
	<1332974587-15452-1-git-send-email-kjwinchester@gmail.com>
	<4F99A69B.4040004@zytor.com>
	<CAELBVzAi_yndZbDc0TkXhbqzn2wULpnsFMA_dop=Uvaii8tkqg@mail.gmail.com>
	<1a0aaa16-df06-40bf-88c7-28180455e6b9@email.android.com>
	<CAELBVzAN33S4_VATnO7FaNjNaObqHsp+OXPsQYeve1N_qUztcA@mail.gmail.com>
	<20120429124724.GA27784@liondog.tnic>
Date: Sun, 29 Apr 2012 19:55:05 -0300
Message-ID: <CAELBVzDCSFyQ43RZjH2zCayprABakq6y=i5tRtnm-rNsQUWH9w@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] x86: Cleanup and simplify cpu-specific data
From: Kevin Winchester <kjwinchester@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Kevin Winchester <kjwinchester@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 April 2012 09:47, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Apr 27, 2012 at 08:37:36PM -0300, Kevin Winchester wrote:
>> Alright, my git/make skills must be lacking.  I just checked out
>> 3.4-rc4 to a new branch, and then git cherry-picked my 5 patches onto
>> that branch.
>
> FWIW,
>
> you probably would need to rediff them again because they don't apply
> cleanly on current linus (v3.4-rc4-308-gf7b006931751):
>
> x86: Move per cpu cpu_llc_id to a field in struct cpuinfo_x86
>
> This simplifies the various code paths using this field as it
> groups the per-cpu data together.
>
> Acked-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> --------------------------
> Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all y
> Applying: x86: Move per cpu cpu_llc_id to a field in struct cpuinfo_x86
> error: patch failed: arch/x86/kernel/apic/apic_numachip.c:208
> error: arch/x86/kernel/apic/apic_numachip.c: patch does not apply
> error: patch failed: arch/x86/kernel/cpu/amd.c:350
> error: arch/x86/kernel/cpu/amd.c: patch does not apply
> Patch failed at 0002 x86: Move per cpu cpu_llc_id to a field in struct cpuinfo_x86
> When you have resolved this problem run "git am --resolved".
> If you would prefer to skip this patch, instead run "git am --skip".
> To restore the original branch and stop patching run "git am --abort".
>
> Or it could be due to fuzz which git cannot stomach but patch can.
>
> Anyway, applying the mbox of your 5 patches on -rc4 got me further but
> choked on the last patch:
>
> Applying: x86: Remove #ifdef CONFIG_SMP sections by moving smp_num_siblings into common.c
> error: patch failed: arch/x86/kernel/process.c:17
> error: arch/x86/kernel/process.c: patch does not apply
> Patch failed at 0005 x86: Remove #ifdef CONFIG_SMP sections by moving smp_num_siblings into common.c
> When you have resolved this problem run "git am --resolved".
> If you would prefer to skip this patch, instead run "git am --skip".
> To restore the original branch and stop patching run "git am --abort".
>
> Applying it with patch worked though, probably due to fuzziness.

Perhaps I sent the wrong set of patches in my last mailing, as that
would explain why everyone else is having trouble that I am not.  I'll
try to confirm and resend.

>
>> Then I ran:
>>
>> $ make ARCH=i386 allnoconfig
>> $ make ARCH=i386
>>
>> And the build completed without warnings or errors.  Should that be
>> equivalent to what you did to build i386 allnoconfig?  If so, then I
>> wonder why I would not see those problems.
>>
>> Can anyone offer any advice?
>
> Other than that, i386 all{no,yes,mod}config seem to build fine here.
>

That's good at least, since it seems to concur with my experience here.

Thanks,

-- 
Kevin
