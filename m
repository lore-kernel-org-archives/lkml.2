Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab0IUQkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:40:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59134 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab0IUQkc (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 21 Sep 2010 12:40:32 -0400
Date: Tue, 21 Sep 2010 12:38:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        venkatesh.pallipadi@intel.com, markh@compro.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fwd: patch: HPET force enable for CX700 / VIA Epia LT  was:
 Re: hpet timers gone?
Message-ID: <20100921163811.GC21459@dumpdata.com>
References: <4C90C829.2080005@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C90C829.2080005@xs4all.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 03:20:41PM +0200, Udo van den Heuvel wrote:
> Hello,
> 
> Who can help me get this minor patch into the kernel?

You need to CC these folks:
konrad@phenom:~/work/linux$ scripts/get_maintainer.pl -f arch/x86/kernel/quirks.c 
Thomas Gleixner <tglx@linutronix.de>
Ingo Molnar <mingo@redhat.com>
H. Peter Anvin <hpa@zytor.com>
x86@kernel.org
Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Mark Hounschell <markh@compro.net>
linux-kernel@vger.kernel.org

Which I just did on your e-mail.

> 
> Kind regards,
> Udo
> 
> -------- Original Message --------
> Subject: patch: HPET force enable for CX700 / VIA Epia LT  was: Re: hpet
> timers gone?
> Date: Tue, 14 Sep 2010 07:15:08 +0200
> From: Udo van den Heuvel <udovdh@xs4all.nl>
> To: Robert Hancock <hancockrwd@gmail.com>
> CC: linux-kernel@vger.kernel.org
> 
> On 2010-09-14 01:16, Robert Hancock wrote:
> > On Mon, Sep 13, 2010 at 8:52 AM, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
> >> So what else can I do to enable HPET?
> > 
> > At this point, not much, unless you can track down the chipset
> > information that would allow us to implement force enabling HPET on
> > that chipset..
> 
> Signed-off-by: Udo van den Heuvel <udovdh@xs4all.nl>
> 
> --- a/arch/x86/kernel/quirks.c	2010-09-13 18:02:14.639710309 +0200
> +++ b/arch/x86/kernel/quirks.c	2010-09-13 18:02:06.095280815 +0200
> @@ -344,6 +344,8 @@
>  			 vt8237_force_enable_hpet);
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237,
>  			 vt8237_force_enable_hpet);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_CX700,
> +			 vt8237_force_enable_hpet);
> 
>  static void ati_force_hpet_resume(void)
>  {
> 
> Patch does make hpet appear on VIA Epia LT (CX700M2 chipset) with
> hpet=force on kernel commandline.
> 
> 
> Udo
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
