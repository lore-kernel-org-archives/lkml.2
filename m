Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2BTRac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:30:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35383 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab2BTRaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:30:30 -0500
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <1329696488-16970-7-git-send-email-hpa@zytor.com> <CAMuHMdV2-StqLjnMXk8EDbfMSUik7BWuQ1phNSoUq_D0i_1icQ@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CAMuHMdV2-StqLjnMXk8EDbfMSUik7BWuQ1phNSoUq_D0i_1icQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 06/30] sysinfo: Use explicit types in <linux/sysinfo.h>
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 20 Feb 2012 09:29:45 -0800
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, hjl.tools@gmail.com
Message-ID: <4ae6abe6-b935-4033-a9b6-31fa5f58e3c6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not really... it comes down to "implicit padding in kernel ABI structures is bad".  They can easily become security holes.



Geert Uytterhoeven <geert@linux-m68k.org> wrote:

>On Mon, Feb 20, 2012 at 01:07, H. Peter Anvin <hpa@zytor.com> wrote:
>> --- a/include/linux/sysinfo.h
>> +++ b/include/linux/sysinfo.h
>> @@ -1,22 +1,24 @@
>>  #ifndef _LINUX_SYSINFO_H
>>  #define _LINUX_SYSINFO_H
>>
>> +#include <linux/types.h>
>> +
>>  #define SI_LOAD_SHIFT  16
>>  struct sysinfo {
>> -       long uptime;                    /* Seconds since boot */
>> -       unsigned long loads[3];         /* 1, 5, and 15 minute load
>averages */
>> -       unsigned long totalram;         /* Total usable main memory
>size */
>> -       unsigned long freeram;          /* Available memory size */
>> -       unsigned long sharedram;        /* Amount of shared memory */
>> -       unsigned long bufferram;        /* Memory used by buffers */
>> -       unsigned long totalswap;        /* Total swap space size */
>> -       unsigned long freeswap;         /* swap space still available
>*/
>> -       unsigned short procs;           /* Number of current
>processes */
>> -       unsigned short pad;             /* explicit padding for m68k
>*/
>> -       unsigned long totalhigh;        /* Total high memory size */
>> -       unsigned long freehigh;         /* Available high memory size
>*/
>> -       unsigned int mem_unit;          /* Memory unit size in bytes
>*/
>> -       char _f[20-2*sizeof(long)-sizeof(int)]; /* Padding: libc5
>uses this.. */
>> +       __kernel_long_t uptime;         /* Seconds since boot */
>> +       __kernel_ulong_t loads[3];      /* 1, 5, and 15 minute load
>averages */
>> +       __kernel_ulong_t totalram;      /* Total usable main memory
>size */
>> +       __kernel_ulong_t freeram;       /* Available memory size */
>> +       __kernel_ulong_t sharedram;     /* Amount of shared memory */
>> +       __kernel_ulong_t bufferram;     /* Memory used by buffers */
>> +       __kernel_ulong_t totalswap;     /* Total swap space size */
>> +       __kernel_ulong_t freeswap;      /* swap space still available
>*/
>> +       __u16 procs;                    /* Number of current
>processes */
>> +       __u16 pad;                      /* Explicit padding for m68k
>*/
>
>Fueling the discussion about natural vs. 4-byte alignment?
>
>> +       __kernel_ulong_t totalhigh;     /* Total high memory size */
>> +       __kernel_ulong_t freehigh;      /* Available high memory size
>*/
>> +       __u32 mem_unit;                 /* Memory unit size in bytes
>*/
>> +       char _f[20-2*sizeof(__kernel_ulong_t)-sizeof(__u32)];   /*
>Padding: libc5 uses this.. */
>>  };
>
>Gr{oetje,eeting}s,
>
>                        Geert
>
>--
>Geert Uytterhoeven -- There's lots of Linux beyond ia32 --
>geert@linux-m68k.org
>
>In personal conversations with technical people, I call myself a
>hacker. But
>when I'm talking to journalists I just say "programmer" or something
>like that.
>                                -- Linus Torvalds

-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
