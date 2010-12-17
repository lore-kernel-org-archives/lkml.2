Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab0LQFRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 00:17:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54456 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0LQFRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 00:17:35 -0500
Message-ID: <4D0AF23D.4010909@zytor.com>
Date: Thu, 16 Dec 2010 21:16:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101207105053.GA2803@redhat.com> <4CFE89FE.1090901@kernel.org> <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <4D0AD976.3020504@zytor.com> <3C6B7683-9CDC-4C4A-A32A-56227DE01387@kernel.org> <4D0AE231.4010804@zytor.com> <4D0AEB0F.5020909@kernel.org>
In-Reply-To: <4D0AEB0F.5020909@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 08:46 PM, Yinghai Lu wrote:
>>
>> Second, this patch only applies if "crashkernel=" is not specified, so
>> it doesn't even apply to your situation.
> current code:
>         /* 0 means: find the address automatically */
>         if (crash_base <= 0) {
>                 const unsigned long long alignment = 16<<20;    /* 16M */
> 
>                 /*
>                  *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
>                  */
>                 crash_base = memblock_find_in_range(alignment,
>                                DEFAULT_BZIMAGE_ADDR_MAX, crash_size, alignment);
> 
>                 if (crash_base == MEMBLOCK_ERROR) {
>                         pr_info("crashkernel reservation failed - No suitable area found.\n");
>                         return;
>                 }
>         } else {
>                 unsigned long long start;
> 
>                 start = memblock_find_in_range(crash_base,
>                                  crash_base + crash_size, crash_size, 1<<20);
>                 if (start != crash_base) {
>                         pr_info("crashkernel reservation failed - memory is in use.\n");
>                         return;
>                 }
>         }
> 
> first branch : will take only crash_size.
> second branch : will need to specify crash_base and crash_size.
> 
>>
>> Third, if you have to specify "crashkernel=" that means that there is
>> yet another problem here that should be fixed.
> 
> no, every kdump need to specify crashkernel=128M or more.
> 

Oh, you're referring to crashkernel size.  Okay, this is somewhat
different.  However, the margin is just too small on 64 bits, then.  How
far up can we actually get away with on 64 bits currently?  4 GiB?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

