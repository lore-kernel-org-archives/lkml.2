Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab1BIPZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 10:25:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49346 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1BIPZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 10:25:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q4dmV5HavU17ldy3osWUuQqHst4IOSgRNTygkVD+RgeeWV5K6pxPGOCZn+fOuj9PdS
         I4cbRiV/30YT2K5ekcth49dsnwU+fyewqqObC61eKGJpewuQN/5M80mOpBiNBA8FDvbV
         nDI//EBMuCoWgcLB6DmOh7uMkToReT5UnhwNQ=
Subject: Re: [PATCH v3] EHCI bus glue for on-chip PMC MSP USB controller.
From: Anoop P A <anoop.pa@gmail.com>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
        "ust@denx.de" <ust@denx.de>,
        "pkondeti@codeaurora.org" <pkondeti@codeaurora.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gadiyar@ti.com" <gadiyar@ti.com>,
        "alek.du@intel.com" <alek.du@intel.com>,
        "jacob.jun.pan@intel.com" <jacob.jun.pan@intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>
In-Reply-To: <4D52AE7E.8000907@parrot.com>
References: <AANLkTimu_gzsd3NY+HDp7jV+EMtrHGZq7qNc3OedyT3C@mail.gmail.com>
	 <1296127736-28208-1-git-send-email-anoop.pa@gmail.com>
	 <4D52AE7E.8000907@parrot.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 21:14:56 +0530
Message-ID: <1297266296.29250.69.camel@paanoop1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 16:10 +0100, Matthieu CASTET wrote:
> Anoop P.A a écrit :
> 
> >  config XPS_USB_HCD_XILINX
> > diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
> > index 6fee3cd..a591890 100644
> > --- a/drivers/usb/host/ehci-hcd.c
> > +++ b/drivers/usb/host/ehci-hcd.c
> > @@ -262,6 +262,8 @@ static void tdi_reset (struct ehci_hcd *ehci)
> >         if (ehci_big_endian_mmio(ehci))
> >                 tmp |= USBMODE_BE;
> >         ehci_writel(ehci, tmp, reg_ptr);
> > +       if (ehci->pmc_msp_tdi)
> > +               usb_hcd_tdi_set_mode(ehci);
> >  }
> This is ugly to add callback to your driver here.
> How this will build on other platform, usb_hcd_tdi_set_mode is only 
> defined on ehci-pmcmsp.c

I got that will remove it from patch and resend.the patch got carried
from an older kernel :( .

Thanks

> 
> 
> > +void usb_hcd_tdi_set_mode(struct ehci_hcd *ehci)
> > +{
> > +	u8 *base;
> > +	u8 *statreg;
> > +	u8 *fiforeg;
> > +	u32 val;
> > +	struct ehci_regs *reg_base = ehci->regs;
> > +
> > +	/* get register base */
> > +	base = (u8 *)reg_base + USB_EHCI_REG_USB_MODE;
> > +	statreg = (u8 *)reg_base + USB_EHCI_REG_USB_STATUS;
> > +	fiforeg = (u8 *)reg_base + USB_EHCI_REG_USB_FIFO;
> > +
> > +	/* set the controller to host mode and BIG ENDIAN */
> > +	ehci_writel(ehci, (USB_CTRL_MODE_HOST | USB_CTRL_MODE_BIG_ENDIAN
> > +		| USB_CTRL_MODE_STREAM_DISABLE), (u32 *)base);
> > +
> We have done that in tdi_reset, why do you do it again ?
> 
> 
> Matthieu


