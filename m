Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1LTNvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 08:51:32 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49407 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab1LTNv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 08:51:27 -0500
From: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] davinci: DA850 EVM: OHCI platform code
Thread-Topic: [PATCH] davinci: DA850 EVM: OHCI platform code
Thread-Index: AQHMvweySyTHtm9kN0+l7odViuYyipXkvdLg
Date: Tue, 20 Dec 2011 13:51:10 +0000
Message-ID: <47CEF8C4B26E8C44B22B028A650E0EA90659DC@DBDE01.ent.ti.com>
References: <1324363005-11320-1-git-send-email-prakash.pm@ti.com>
 <4EF06C64.8000708@mvista.com>
In-Reply-To: <4EF06C64.8000708@mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
> Hello.
> 
> On 20.12.2011 10:36, Manjunathappa, Prakash wrote:
> 
> > From: Ajay Kumar Gupta <ajay.gupta@ti.com>
> 
>     It's a good practice to CC the original author of the patch -- which
> I'm
> doing now...
> 
> > On this board the OHCI port's power control and over-current signals
> from
> > TPS2065 power switch are connected via GPIO1[15] and GPIO2[1]
> respectively,
> 
>     Ajay, your description seems to be copied unchganged from the
> analogous
> DA830 EVM patch, and thus doesn't match your patch: GPIO2[4] and
> GPIO6[13] are
> used apparently. Be more attentive to detail next time please.

Well, this patch was created long back for internal release work and
couldn't review this before it is sent out.

Prakash, Please correct the patch description as suggested.

Regards,
Ajay
> .
> > so we can implement the DA8xx OHCI glue layer's hooks for overriding
> the
> > root hub port's power and over-current status bits.
> 
> > We also have to properly set up the clocking mode in the CFGCHIP2
> register,
> > so that internal 24 MHz reference clock is fed to the USB 2.0 (MUSB)
> PHY and
> > its output is used to clock the USB 1.1 (OHCI) PHY...
> 
> > Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
> > ---
> >   arch/arm/mach-davinci/board-da850-evm.c |  126
> +++++++++++++++++++++++++++++++
> >   1 files changed, 126 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-
> davinci/board-da850-evm.c
> > index 6659a90..df74ba5 100644
> > --- a/arch/arm/mach-davinci/board-da850-evm.c
> > +++ b/arch/arm/mach-davinci/board-da850-evm.c
> [...]
> > @@ -734,6 +736,127 @@ static struct davinci_i2c_platform_data
> da850_evm_i2c_0_pdata = {
> [...]
> > +static int da850_evm_usb_ocic_notify(da8xx_ocic_handler_t handler)
> > +{
> > +	int irq		= gpio_to_irq(ON_BD_USB_OVC);
> > +	int error	= 0;
> > +
> > +	if (handler != NULL) {
> > +		da850_evm_usb_ocic_handler = handler;
> > +
> > +		error = request_irq(irq, da850_evm_usb_ocic_irq,
> IRQF_DISABLED |
> 
>     IRQF_DISABLED is a nop now -- just remove it.
> 
> WBR, Sergei
