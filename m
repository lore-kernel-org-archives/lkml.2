Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab1LUF4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 00:56:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41703 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab1LUF4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 00:56:37 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>,
        "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] davinci: DA850 EVM: OHCI platform code
Thread-Topic: [PATCH] davinci: DA850 EVM: OHCI platform code
Thread-Index: AQHMvuMCKNdu/0yQ4EWoLOXE9Vdo45XkN+kAgAGTyeA=
Date: Wed, 21 Dec 2011 05:56:24 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC026189@DBDE01.ent.ti.com>
References: <1324363005-11320-1-git-send-email-prakash.pm@ti.com>
 <4EF06EC2.3070907@mvista.com>
In-Reply-To: <4EF06EC2.3070907@mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Tue, Dec 20, 2011 at 16:47:22, Sergei Shtylyov wrote:
> Hello.
> 
> On 20-12-2011 10:36, Manjunathappa, Prakash wrote:
> 
> > From: Ajay Kumar Gupta<ajay.gupta@ti.com>
> 
> > On this board the OHCI port's power control and over-current signals from
> > TPS2065 power switch are connected via GPIO1[15] and GPIO2[1] respectively,
> > so we can implement the DA8xx OHCI glue layer's hooks for overriding the
> > root hub port's power and over-current status bits.
> 
> > We also have to properly set up the clocking mode in the CFGCHIP2 register,
> > so that internal 24 MHz reference clock is fed to the USB 2.0 (MUSB) PHY and
> > its output is used to clock the USB 1.1 (OHCI) PHY...
> 
> > Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
> 
>     BTW, Prakash, as you'r on the patch's disrtibution path, shouldn't you add 
> your signoff as well?
> 

Yes, I will make it point to keep my signoff as well while distributing.

> > ---
> >   arch/arm/mach-davinci/board-da850-evm.c |  126 +++++++++++++++++++++++++++++++
> >   1 files changed, 126 insertions(+), 0 deletions(-)
> 
> > diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> > index 6659a90..df74ba5 100644
> > --- a/arch/arm/mach-davinci/board-da850-evm.c
> > +++ b/arch/arm/mach-davinci/board-da850-evm.c
> [...]
> > +static __init void da850_evm_usb_init(void)
> > +{
> [...]
> > +	ret = gpio_request(ON_BD_USB_DRV, "ON_BD_USB_DRV");
> > +	if (ret) {
> > +		printk(KERN_ERR "%s: failed to request GPIO for USB 1.1 port "
> > +		       "power control: %d\n", __func__, ret);
> > +		return;
> > +	}
> > +	gpio_direction_output(ON_BD_USB_DRV, 0);
> 
>     You should also use gpio_request_one() instead 
> gpio_request()/gpio_direction_output() pair.
> 

Agreed, I will use gpio_request_one().

> > +
> > +	ret = gpio_request(ON_BD_USB_OVC, "ON_BD_USB_OVC");
> > +	if (ret) {
> > +		printk(KERN_ERR "%s: failed to request GPIO for USB 1.1 port "
> > +		       "over-current indicator: %d\n", __func__, ret);
> > +		return;
> > +	}
> > +	gpio_direction_input(ON_BD_USB_OVC);
> 
>     Same here.
> 

Agreed.

Thanks,
Prakash

> WBR, Sergei
> 

