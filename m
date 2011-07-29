Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1G2SJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:09:27 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36838 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1G2SJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:09:24 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4E32F2ED.4020000@codeaurora.org>
References: <CA+icZUV7R5hqTupiuZZKWcsZ5LOBGmY6xgmMTM7W3ojJo0Sp4w@mail.gmail.com>
	<20110728160136.771e2c0a.rdunlap@xenotime.net>
	<CA+icZUXLpThpEem+DPimemYVHqSKb5NAb5h_L-rMPWsD+WJTYg@mail.gmail.com>
	<20110728220926.6d1a91f4.rdunlap@xenotime.net>
	<CA+icZUVsJNSDzBvvH810POEydpaZxJZfM8J9bD+93+4d+88D_A@mail.gmail.com>
	<CA+icZUX=qM+xhJkteXs=F_RJP+k-Tzf3+Cp4ZdeatZ0cgHegBw@mail.gmail.com>
	<4E32F2ED.4020000@codeaurora.org>
Date: Fri, 29 Jul 2011 20:09:22 +0200
Message-ID: <CA+icZUWJ=VS6_oqibRbdU0D=TMpEpcB4DNd1i8QUF5MS+4rV8Q@mail.gmail.com>
Subject: Re: linux-next: Tree for July 28 ("copy_from_user_overflow" undefined)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 7:50 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 07/29/2011 02:45 AM, Sedat Dilek wrote:
>> [ CCing all people from 0416 patch ]
>>
>> OK, here a quick review and looking for suspicious commits:
> [snip]
>> -- a/lib/Makefile
>> +++ b/lib/Makefile
>> @@ -14,6 +14,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>>          proportions.o prio_heap.o ratelimit.o show_mem.o \
>>          is_single_threaded.o plist.o decompress.o find_next_bit.o
>>
>> +lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
>>  lib-$(CONFIG_MMU) += ioremap.o
>>  lib-$(CONFIG_SMP) += cpumask.o
>>
>> So, I can rebuild next-201107{27,28} with
>> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y and look again if the
>> build-breakage in binfmt_misc is gone.
>>
>> Any comments from x86 folk?
>
> I already noticed this and sent a fixup patch to Andrew. Looks like he
> never picked it up. The real fix is to change that lib-$(CONFIG... to
> obj-$(CONFIG...
>
> See https://lkml.org/lkml/2011/7/6/6 for the patch.
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
>

NO, Andrew didn't do so [1] and that's why the appropriate patch [2]
in linux-next misses it, too.
Grr, your patch is from 05-Jul-2011...

- Sedat -

[1] http://userweb.kernel.org/~akpm/mmotm/broken-out/consolidate-config_debug_strict_user_copy_checks.patch
[2] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=4df97ff66a102a89ecfa2f88051e30bdd54ad864
