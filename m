Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab0GNTaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:30:55 -0400
Received: from www.tglx.de ([62.245.132.106]:36423 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383Ab0GNTax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:30:53 -0400
Date: Wed, 14 Jul 2010 21:30:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephan Wolf <stephan@letzte-bankreihe.de>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] enable readback to get HPET working on ATI SB4x00, kernel
 2.6.35_rc5
In-Reply-To: <AANLkTim5fAwwhqP2J9pfOqeJACFf0OvK_MMZc1oZb3M4@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1007142124180.3321@localhost.localdomain>
References: <4C3DDDFF.5040302@letzte-bankreihe.de> <AANLkTim5fAwwhqP2J9pfOqeJACFf0OvK_MMZc1oZb3M4@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1557804114-1279135804=:3321"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1557804114-1279135804=:3321
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 14 Jul 2010, Linus Torvalds wrote:

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
> 
> So I get the feeling that this is incomplete, or at least needs
> thinking about those other ATI chipsets too.
> 
> Thomas? And I added Andreas to the cc, maybe he knows what's up.

Hmpf. The only report I ever got was against SBX00 and I can reproduce
on my own machine. My IXP400_SMBUS box works fine without the
readback.

/me is confused
--8323328-1557804114-1279135804=:3321--
