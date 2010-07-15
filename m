Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab0GOKD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 06:03:28 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:39735 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab0GOKD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 06:03:26 -0400
X-SpamScore: -31
X-BigFish: VPS-31(zz1432N98dN936eM148cMzz1202hzz15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5LFX3-02-06Y-02
X-M-MSG: 
Date: Thu, 15 Jul 2010 12:02:58 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Stephan Wolf <stephan@letzte-bankreihe.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] enable readback to get HPET working on ATI SB4x00,
 kernel 2.6.35_rc5
Message-ID: <20100715100258.GA20469@aftab>
References: <4C3DDDFF.5040302@letzte-bankreihe.de>
 <AANLkTim5fAwwhqP2J9pfOqeJACFf0OvK_MMZc1oZb3M4@mail.gmail.com>
 <20100714181152.GB15651@aftab>
 <AANLkTin71FbM5Eh7TDUHN0WvYHA5RubycflTxM5EWlvj@mail.gmail.com>
 <20100714183216.GC15651@aftab>
 <alpine.LFD.2.00.1007142134140.3321@localhost.localdomain>
 <4C3EB365.4030205@letzte-bankreihe.de>
 <alpine.LFD.2.00.1007151011550.3321@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1007151011550.3321@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, Jul 15, 2010 at 04:22:14AM -0400

> On Thu, 15 Jul 2010, Stephan Wolf wrote:
> > Am 14.07.2010 23:04, schrieb Thomas Gleixner:
> > 
> > > +static void __init ati_hpet_bugs(int num, int slot, int func)
> > > +{
> > > +#ifdef CONFIG_HPET_TIMER
> > > +	hpet_readback_cmp = 1;
> > > +#endif
> > > +}
> > > +
> > >   #define QFLAG_APPLY_ONCE 	0x1
> > >   #define QFLAG_APPLIED		0x2
> > >   #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
> > > @@ -220,6 +236,8 @@ static struct chipset early_qrk[] __init
> > >   	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
> > >   	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
> > >   	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
> > > +	{ PCI_VENDOR_ID_ATI, PCI_ANY_ID,
> > > +	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_hpet_bugs },
> > >   	{}
> > 
> > Hi, the patch above solves the problem on my machine.
> 
> Thanks for testing. 
> 
> Borislav, any opinion ?

Yep, good idea to match SMBus device class on ATI, cool. Quickly tested
on my SB700.

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

