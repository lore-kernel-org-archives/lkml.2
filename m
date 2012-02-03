Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab2BCKmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 05:42:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37962 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab2BCKma convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 05:42:30 -0500
MIME-Version: 1.0
In-Reply-To: <4F2BB715.8090803@mvista.com>
References: <1328255503-17575-1-git-send-email-xiyou.wangcong@gmail.com>
	<4F2BB715.8090803@mvista.com>
Date: Fri, 3 Feb 2012 11:42:29 +0100
X-Google-Sender-Auth: 0VIJ_JdIqTzDV-8ukczOExntKlU
Message-ID: <CAMuHMdVU4TNg=cdmRyH1DhhHKkhaBtcdS8Q+5wtUZTyV+nRg5g@mail.gmail.com>
Subject: Re: [Patch] mips: do not redefine BUILD_BUG()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, Hillf Danton <dhillf@gmail.com>,
        linux-mips@linux-mips.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 11:29, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
>> include/linux/kernel.h:717:1: error: "BUILD_BUG" redefined
>> arch/mips/include/asm/page.h:43:1: error: this is the location of the
>> previous definition

>> --- a/arch/mips/include/asm/page.h
>> +++ b/arch/mips/include/asm/page.h
>> @@ -39,9 +39,7 @@
>>  #define HPAGE_MASK    (~(HPAGE_SIZE - 1))
>>  #define HUGETLB_PAGE_ORDER    (HPAGE_SHIFT - PAGE_SHIFT)
>>  #else /* !CONFIG_HUGETLB_PAGE */
>> -# ifndef BUILD_BUG
>
>   Not clear why we get the error if we're protected with #ifndef...

Because this is the first definition. It's redefined later.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
