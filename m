Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab2LUFtC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:49:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60873 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab2LUFs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:48:57 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQVHuNkT3BLUW3hJf6mWbNq+kWmohwSNJMxxO1sYvyCxOQ@mail.gmail.com>
References: <1356032893-2730-1-git-send-email-fenghua.yu@intel.com> <1356032893-2730-10-git-send-email-fenghua.yu@intel.com> <CAE9FiQUCqeWH2qezRMH=PY39tiy4MhSF1yy77QUBfdtPMr_hqQ@mail.gmail.com> <3E5A0FA7E9CA944F9D5414FEC6C7122047109A03@ORSMSX105.amr.corp.intel.com> <CAE9FiQVHuNkT3BLUW3hJf6mWbNq+kWmohwSNJMxxO1sYvyCxOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 09/11] x86/head64.c: Early update ucode in 64-bit
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 20 Dec 2012 21:48:32 -0800
To: Yinghai Lu <yinghai@kernel.org>, "Yu, Fenghua" <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Message-ID: <f10c02a1-fb8a-4f6f-8d86-d3a330f83688@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Careful... accessing global varibles is tricky on the 32-bit side.

Yinghai Lu <yinghai@kernel.org> wrote:

>Yeah, even better!
>
>32 bit has bootparms copied too
>
>
>On Thursday, December 20, 2012, Yu, Fenghua wrote:
>
>> > > From: yhlu.kernel@gmail.com <javascript:;> [mailto:
>> yhlu.kernel@gmail.com <javascript:;>] On Behalf
>> > Of
>> > > Yinghai Lu
>> > > On Thu, Dec 20, 2012 at 11:48 AM, Fenghua Yu
><fenghua.yu@intel.com<javascript:;>
>> >
>> > > wrote:
>> > > > From: Fenghua Yu <fenghua.yu@intel.com <javascript:;>>
>> > > >
>> > > > This updates ucode on BSP in 64-bit mode. Paging and virtual
>> > address
>> > > are
>> > > > working now.
>> > > >
>> > > > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com <javascript:;>>
>> > > > ---
>> > > >  arch/x86/kernel/head64.c | 6 ++++++
>> > > >  1 file changed, 6 insertions(+)
>> > > >
>> > > > diff --git a/arch/x86/kernel/head64.c
>b/arch/x86/kernel/head64.c
>> > > > index e1cb611..1ccbaf1 100644
>> > > > --- a/arch/x86/kernel/head64.c
>> > > > +++ b/arch/x86/kernel/head64.c
>> > > > @@ -26,6 +26,7 @@
>> > > >  #include <asm/kdebug.h>
>> > > >  #include <asm/e820.h>
>> > > >  #include <asm/bios_ebda.h>
>> > > > +#include <asm/microcode.h>
>> > > >
>> > > >  /*
>> > > >   * Manage page tables very early on.
>> > > > @@ -179,6 +180,11 @@ void __init x86_64_start_kernel(char *
>> > > real_mode_data)
>> > > >         }
>> > > >         load_idt((const struct desc_ptr *)&idt_descr);
>> > > >
>> > > > +       /*
>> > > > +        * Load microcode early on BSP.
>> > > > +        */
>> > > > +       load_ucode_bsp(__va(real_mode_data));
>> > > > +
>> > > >         copy_bootdata(__va(real_mode_data));
>> > >
>> > > can you make load_ucode_bsp take boot_param directly instead of
>> > > real_mode_data. ?
>> > >
>> > > could be
>> > >
>> > >
>> > >         copy_bootdata(__va(real_mode_data));
>> > > +
>> > > +        /* Load microcode early on BSP. */
>> > > +       load_ucode_bsp(&boot_params);
>> > > +
>> > >
>> > > because copy_bootdata, already copy boot_params...
>> > >
>> > > Thanks
>> > >
>> > > Yinghai
>> >
>> > That's right. Will fix this.
>>
>> I'll call load_ucode_bsp(void) though which will access the global
>> boot_params variable.
>>
>> Thanks.
>>
>> -Fenghua
>>

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
