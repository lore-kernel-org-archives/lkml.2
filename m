Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab0GOIWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 04:22:42 -0400
Received: from www.tglx.de ([62.245.132.106]:40490 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653Ab0GOIWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 04:22:40 -0400
Date: Thu, 15 Jul 2010 10:22:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephan Wolf <stephan@letzte-bankreihe.de>
cc: Borislav Petkov <borislav.petkov@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] enable readback to get HPET working on ATI SB4x00, kernel
 2.6.35_rc5
In-Reply-To: <4C3EB365.4030205@letzte-bankreihe.de>
Message-ID: <alpine.LFD.2.00.1007151011550.3321@localhost.localdomain>
References: <4C3DDDFF.5040302@letzte-bankreihe.de> <AANLkTim5fAwwhqP2J9pfOqeJACFf0OvK_MMZc1oZb3M4@mail.gmail.com> <20100714181152.GB15651@aftab> <AANLkTin71FbM5Eh7TDUHN0WvYHA5RubycflTxM5EWlvj@mail.gmail.com> <20100714183216.GC15651@aftab>
 <alpine.LFD.2.00.1007142134140.3321@localhost.localdomain> <4C3EB365.4030205@letzte-bankreihe.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010, Stephan Wolf wrote:
> Am 14.07.2010 23:04, schrieb Thomas Gleixner:
> 
> > +static void __init ati_hpet_bugs(int num, int slot, int func)
> > +{
> > +#ifdef CONFIG_HPET_TIMER
> > +	hpet_readback_cmp = 1;
> > +#endif
> > +}
> > +
> >   #define QFLAG_APPLY_ONCE 	0x1
> >   #define QFLAG_APPLIED		0x2
> >   #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
> > @@ -220,6 +236,8 @@ static struct chipset early_qrk[] __init
> >   	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
> >   	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
> >   	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
> > +	{ PCI_VENDOR_ID_ATI, PCI_ANY_ID,
> > +	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_hpet_bugs },
> >   	{}
> 
> Hi, the patch above solves the problem on my machine.

Thanks for testing. 

Borislav, any opinion ?

Thanks,

	tglx
