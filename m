Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab0GNSMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:12:15 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:48173 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779Ab0GNSMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:12:13 -0400
X-SpamScore: -45
X-BigFish: VPS-45(zz1432N98dN179dN140eM9371P15bfMzz1202hzz15d4Rz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5K7W4-01-DL0-02
X-M-MSG: 
Date: Wed, 14 Jul 2010 20:11:52 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stephan Wolf <stephan@letzte-bankreihe.de>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] enable readback to get HPET working on ATI SB4x00,
 kernel 2.6.35_rc5
Message-ID: <20100714181152.GB15651@aftab>
References: <4C3DDDFF.5040302@letzte-bankreihe.de>
 <AANLkTim5fAwwhqP2J9pfOqeJACFf0OvK_MMZc1oZb3M4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <AANLkTim5fAwwhqP2J9pfOqeJACFf0OvK_MMZc1oZb3M4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, Jul 14, 2010 at 09:13:39AM -0700

> On Wed, Jul 14, 2010 at 8:55 AM, Stephan Wolf
> <stephan@letzte-bankreihe.de> wrote:
> >
> >  After commit 30a564be9d9554c168a654eddc2165869cc0d7bf "x86, hpet: Restrict
> > read back to affected ATI chipsets" hpet did not work anymore on HP nx6325.
> > The machine hangs on booting until a keystroke was taken. After a short time
> > machine hangs again until next keystroke. Applying the following patch
> > solves the issue for me.
> 
> Ok, this makes sense. Bugs in the ATI chipset is why
> 'hpet_readback_cmp' exists in the first place. HOWEVER, clearly that
> commit changed it to be about too few ATI chipsets.
> 
> So right now, for
> 
>  - PCI_DEVICE_ID_ATI_SBX00_SMBUS:
>      force disable HPET MSI
>      force HPET readback
> 
>  - PCI_DEVICE_ID_ATI_IXP400_SMBU
>      force-enable HPET
>      ...and than your patch makes it force HPET readback
> 
> but that doesn't actually make much sense in the bigger picture,
> because there are other ATI chipsets that are related and presumably
> also affected. What about IXP[23]00_SMBUS? And what about the IXP7
> series (SBX00 is IXP6, afaik)?

Right, so the original commit introducing the readback did it for all
ATI chipsets: 72d43d9bc9210d24d09202eaf219eac09e17b339. We've been
running fine with it so far modulo the Intel ICH9 issue.

I'll try to find out which chipsets are actually affected but in the
meantime we might want to do a temporary fix by enabling the readback
back(!) on all ATI chipsets so that we don't uncover anymore bugs like
the one above, hmmm?

> And I added Andreas to the cc, maybe he knows what's up.

He'll be back on Mo.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

