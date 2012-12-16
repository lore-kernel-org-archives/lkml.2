Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab2LPSil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 13:38:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:8397 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab2LPSik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 13:38:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,294,1355126400"; 
   d="scan'208";a="265020985"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v3 08/10] x86/head64.c: Early update ucode in 64-bit
Thread-Topic: [PATCH v3 08/10] x86/head64.c: Early update ucode in 64-bit
Thread-Index: AQHN27U5Cxm9cfLkVkqEiPpUYGHzQJgcPMCA//+DPpA=
Date: Sun, 16 Dec 2012 18:38:37 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220470F8166@ORSMSX105.amr.corp.intel.com>
References: <1355654609-16800-1-git-send-email-fenghua.yu@intel.com>
	<1355654609-16800-9-git-send-email-fenghua.yu@intel.com>
 <CAE9FiQWFRMpxQTTbS+p21EjBvmetup75zD6ipc3COZg7=KyNig@mail.gmail.com>
In-Reply-To: <CAE9FiQWFRMpxQTTbS+p21EjBvmetup75zD6ipc3COZg7=KyNig@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu
> Sent: Sunday, December 16, 2012 9:59 AM
> To: Yu, Fenghua
> Cc: H Peter Anvin; Ingo Molnar; Thomas Gleixner; Mallick, Asit K;
> Tigran Aivazian; Andreas Herrmann; Borislav Petkov; linux-kernel; x86
> Subject: Re: [PATCH v3 08/10] x86/head64.c: Early update ucode in 64-
> bit
> 
> On Sun, Dec 16, 2012 at 2:43 AM, Fenghua Yu <fenghua.yu@intel.com>
> wrote:
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > This updates ucode in 64-bit mode. Paging and virtual address are
> working now.
> >
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > ---
> >  arch/x86/kernel/head64.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> > index 037df57..a512f56 100644
> > --- a/arch/x86/kernel/head64.c
> > +++ b/arch/x86/kernel/head64.c
> > @@ -25,6 +25,7 @@
> >  #include <asm/kdebug.h>
> >  #include <asm/e820.h>
> >  #include <asm/bios_ebda.h>
> > +#include <asm/microcode.h>
> >
> >  static void __init zap_identity_mappings(void)
> >  {
> > @@ -73,6 +74,11 @@ void __init x86_64_start_kernel(char *
> real_mode_data)
> >         /* clear bss before set_intr_gate with early_idt_handler */
> >         clear_bss();
> >
> > +       /*
> > +        * Load microcode early on BSP.
> > +        */
> > +       load_ucode_bsp(real_mode_data);
> > +
> >         /* Make NULL pointers segfault */
> >         zap_identity_mappings();
> >
> 
> So this patchset is after #PF handler set early page table version?
> 
> then load_ucode_bsp() should be after
> 
>    load_idt((const struct desc_ptr *)&idt_descr);
> 
> otherwise it will not work.
> 
> Yinghai

load_ucode_bsp() only accesses initrd image, a few global variables. It doesn't call any other kernel functions (e.g. printk or kmalloc()). It is like this mainly because it works on both 32 and 64 bit.

So there is no PF and idt should not impact the function, right?

Thanks.

-Fenghua
