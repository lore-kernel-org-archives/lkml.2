Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab2JCPVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:21:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44775 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515Ab2JCPVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:21:13 -0400
From: Florian Fainelli <florian@openwrt.org>
To: Manuel Lauss <manuel.lauss@gmail.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Thomas Meyer <thomas@m3y3r.de>,
        "David S. Miller" <davem@davemloft.net>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/25] MIPS: Alchemy: use the ehci platform driver
Date: Wed, 03 Oct 2012 17:20:10 +0200
Message-ID: <5730774.qPbnpD5QP3@flexo>
Organization: OpenWrt
User-Agent: KMail/4.8.5 (Linux/3.2.0-24-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAOLZvyEfagtJSQyL7MHkw+40NYbmFtT35Y4b8pGNUNc6dTzS=Q@mail.gmail.com>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org> <1349276601-8371-8-git-send-email-florian@openwrt.org> <CAOLZvyEfagtJSQyL7MHkw+40NYbmFtT35Y4b8pGNUNc6dTzS=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2012 17:14:21 Manuel Lauss wrote:
> On Wed, Oct 3, 2012 at 5:03 PM, Florian Fainelli <florian@openwrt.org> wrote:
> > Use the ehci platform driver power_{on,suspend,off} callbacks to perform 
the
> > USB block gate enabling/disabling as what the ehci-au1xxx.c driver does.
> >
> > Signed-off-by: Florian Fainelli <florian@openwrt.org>
> > ---
> >  arch/mips/alchemy/common/platform.c |   23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/mips/alchemy/common/platform.c 
b/arch/mips/alchemy/common/platform.c
> > index c0f3ce6..57335a2 100644
> > --- a/arch/mips/alchemy/common/platform.c
> > +++ b/arch/mips/alchemy/common/platform.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/serial_8250.h>
> >  #include <linux/slab.h>
> > +#include <linux/usb/ehci_pdriver.h>
> >
> >  #include <asm/mach-au1x00/au1000.h>
> >  #include <asm/mach-au1x00/au1xxx_dbdma.h>
> > @@ -122,6 +123,25 @@ static void __init alchemy_setup_uarts(int ctype)
> >  static u64 alchemy_ohci_dmamask = DMA_BIT_MASK(32);
> >  static u64 __maybe_unused alchemy_ehci_dmamask = DMA_BIT_MASK(32);
> >
> > +/* Power on callback for the ehci platform driver */
> > +static int alchemy_ehci_power_on(struct platform_device *pdev)
> > +{
> > +       return alchemy_usb_control(ALCHEMY_USB_EHCI0, 1);
> > +}
> > +
> > +/* Power off/suspend callback for the ehci platform driver */
> > +static void alchemy_ehci_power_off(struct platform_device *pdev)
> > +{
> > +       alchemy_usb_control(ALCHEMY_USB_EHCI0, 0);
> > +}
> > +
> > +static struct usb_ehci_pdata alchemy_ehci_pdata = {
> > +       .need_io_watchdog       = 0,
> 
> This member doesn't exist.

Thanks to get_maintainers.pl you did not get the patch that adds it, and it 
seems like the mailing-list archives did not get it everywhere too, I can 
ensure you that's is there, it's actually PATCH 6/25 of this serie.
--
Florian
