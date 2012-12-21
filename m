Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911Ab2LUFHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:07:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:36027 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab2LUFHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:07:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,328,1355126400"; 
   d="scan'208";a="183262231"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v4 09/11] x86/head64.c: Early update ucode in 64-bit
Thread-Topic: [PATCH v4 09/11] x86/head64.c: Early update ucode in 64-bit
Thread-Index: AQHN3yYFVmoxtIcZeUWxSqmbqiPh75gjKeQA//+DbgCAAAURoA==
Date: Fri, 21 Dec 2012 05:07:02 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122047109A03@ORSMSX105.amr.corp.intel.com>
References: <1356032893-2730-1-git-send-email-fenghua.yu@intel.com>
	<1356032893-2730-10-git-send-email-fenghua.yu@intel.com>
 <CAE9FiQUCqeWH2qezRMH=PY39tiy4MhSF1yy77QUBfdtPMr_hqQ@mail.gmail.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf
> Of
> > Yinghai Lu
> > On Thu, Dec 20, 2012 at 11:48 AM, Fenghua Yu <fenghua.yu@intel.com>
> > wrote:
> > > From: Fenghua Yu <fenghua.yu@intel.com>
> > >
> > > This updates ucode on BSP in 64-bit mode. Paging and virtual
> address
> > are
> > > working now.
> > >
> > > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > > ---
> > >  arch/x86/kernel/head64.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> > > index e1cb611..1ccbaf1 100644
> > > --- a/arch/x86/kernel/head64.c
> > > +++ b/arch/x86/kernel/head64.c
> > > @@ -26,6 +26,7 @@
> > >  #include <asm/kdebug.h>
> > >  #include <asm/e820.h>
> > >  #include <asm/bios_ebda.h>
> > > +#include <asm/microcode.h>
> > >
> > >  /*
> > >   * Manage page tables very early on.
> > > @@ -179,6 +180,11 @@ void __init x86_64_start_kernel(char *
> > real_mode_data)
> > >         }
> > >         load_idt((const struct desc_ptr *)&idt_descr);
> > >
> > > +       /*
> > > +        * Load microcode early on BSP.
> > > +        */
> > > +       load_ucode_bsp(__va(real_mode_data));
> > > +
> > >         copy_bootdata(__va(real_mode_data));
> >
> > can you make load_ucode_bsp take boot_param directly instead of
> > real_mode_data. ?
> >
> > could be
> >
> >
> >         copy_bootdata(__va(real_mode_data));
> > +
> > +        /* Load microcode early on BSP. */
> > +       load_ucode_bsp(&boot_params);
> > +
> >
> > because copy_bootdata, already copy boot_params...
> >
> > Thanks
> >
> > Yinghai
> 
> That's right. Will fix this.

I'll call load_ucode_bsp(void) though which will access the global boot_params variable.

Thanks.

-Fenghua
