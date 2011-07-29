Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab1G2Ruq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:50:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47888 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab1G2Rup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:50:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6422"; a="106669580"
Message-ID: <4E32F2ED.4020000@codeaurora.org>
Date: Fri, 29 Jul 2011 10:50:37 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: Tree for July 28 ("copy_from_user_overflow" undefined)
References: <CA+icZUV7R5hqTupiuZZKWcsZ5LOBGmY6xgmMTM7W3ojJo0Sp4w@mail.gmail.com> <20110728160136.771e2c0a.rdunlap@xenotime.net> <CA+icZUXLpThpEem+DPimemYVHqSKb5NAb5h_L-rMPWsD+WJTYg@mail.gmail.com> <20110728220926.6d1a91f4.rdunlap@xenotime.net> <CA+icZUVsJNSDzBvvH810POEydpaZxJZfM8J9bD+93+4d+88D_A@mail.gmail.com> <CA+icZUX=qM+xhJkteXs=F_RJP+k-Tzf3+Cp4ZdeatZ0cgHegBw@mail.gmail.com>
In-Reply-To: <CA+icZUX=qM+xhJkteXs=F_RJP+k-Tzf3+Cp4ZdeatZ0cgHegBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 02:45 AM, Sedat Dilek wrote:
> [ CCing all people from 0416 patch ]
>
> OK, here a quick review and looking for suspicious commits:
[snip]
> -- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -14,6 +14,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>          proportions.o prio_heap.o ratelimit.o show_mem.o \
>          is_single_threaded.o plist.o decompress.o find_next_bit.o
>
> +lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
>  lib-$(CONFIG_MMU) += ioremap.o
>  lib-$(CONFIG_SMP) += cpumask.o
>
> So, I can rebuild next-201107{27,28} with
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y and look again if the
> build-breakage in binfmt_misc is gone.
>
> Any comments from x86 folk?

I already noticed this and sent a fixup patch to Andrew. Looks like he
never picked it up. The real fix is to change that lib-$(CONFIG... to
obj-$(CONFIG...

See https://lkml.org/lkml/2011/7/6/6 for the patch.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

