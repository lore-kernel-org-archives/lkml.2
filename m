Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2BTL7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:59:13 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43041 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab2BTL7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:59:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of geert.uytterhoeven@gmail.com designates 10.180.99.7 as permitted sender) smtp.mail=geert.uytterhoeven@gmail.com; dkim=pass header.i=geert.uytterhoeven@gmail.com
MIME-Version: 1.0
In-Reply-To: <CACPZLaWnqxN_pWfonakqQ5i2W+prKFi6RVErebbO_FB6tw0Pew@mail.gmail.com>
References: <1329664319-3128-1-git-send-email-geert@linux-m68k.org>
	<1329664319-3128-2-git-send-email-geert@linux-m68k.org>
	<CACPZLaWnqxN_pWfonakqQ5i2W+prKFi6RVErebbO_FB6tw0Pew@mail.gmail.com>
Date: Mon, 20 Feb 2012 12:59:10 +0100
X-Google-Sender-Auth: 9WXJGwSEa5eLhHkQmo0oLdW-UqU
Message-ID: <CAMuHMdUm=juT2efdHPzELK1MEeb1FJRQmS6=ajMqxmB_f5M4AQ@mail.gmail.com>
Subject: Re: [microblaze-linux] [PATCH 2/5] microblaze: s/#if[!]
 CONFIG/#if[n]def CONFIG/
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: John Williams <john.williams@petalogix.com>
Cc: Jiri Kosina <trivial@kernel.org>, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 01:27, John Williams
<john.williams@petalogix.com> wrote:
> NACK - please see comments below
>
> On Mon, Feb 20, 2012 at 1:11 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Cc: Michal Simek <monstr@monstr.eu>
>> Cc: microblaze-uclinux@itee.uq.edu.au
>> ---
>>  arch/microblaze/include/asm/exceptions.h |    2 +-
>>  arch/microblaze/include/asm/irqflags.h   |    2 +-
>>  arch/microblaze/kernel/entry-nommu.S     |    2 +-
>>  arch/microblaze/kernel/entry.S           |    4 ++--
>>  arch/microblaze/kernel/setup.c           |    4 ++--
>>  5 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/microblaze/include/asm/exceptions.h b/arch/microblaze/include/asm/exceptions.h
>> index e6a8dde..48c197b 100644
>> --- a/arch/microblaze/include/asm/exceptions.h
>> +++ b/arch/microblaze/include/asm/exceptions.h
>> @@ -25,7 +25,7 @@
>>  /* Define MSR enable bit for HW exceptions */
>>  #define HWEX_MSR_BIT (1 << 8)
>>
>> -#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
>> +#ifdef CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
>
> We actually care about the value of this one - it is always defined,
> but is either 0 or 1 depending upon the presence or absence of this
> feature in the target CPU.
>
> These CPU feature-related configs are defined in
> arch/microblaze/platform/generic/Kconfig.auto
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=arch/microblaze/platform/generic/Kconfig.auto;h=25a6f019e94d5d9a1c884dfef9e906435685f980;hb=HEAD
>
> not as bools, but as integers.  Kconfig.auto is actually a placeholder
> for a design file which is emitted from the MicroBlaze CPU / SoC
> design tool flow and copied into place by the user.
>
> In my view these should remain integers rather than booleans for a
> couple of reasons:
>  * breakage for all current users
>  * MicroBlaze is an evolving architecture, there are other cases of
> seemingly boolean HW parametesr growing to become integers, such as
> the USE_FPU option.  Once upon a time it was yes/no, now there's 2
> different flavours of FPU as well as 'none'.  MSR is just as likely to
> change in future.
>
>> -#if CONFIG_MANUAL_RESET_VECTOR
>> +#ifdef CONFIG_MANUAL_RESET_VECTOR
>
> This guy is also always defined (Kconfig 'hex' type), we just need to
> do something different for a non-zero value.

Sorry, I missed these are not bool values.

To avoid this from happening again, perhaps it's a good idea to
explicitly write e.g.

#if CONFIG_MANUAL_RESET_VECTOR != 0

like is done for other int config values?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
