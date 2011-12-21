Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab1LUFwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 00:52:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35302 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab1LUFwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 00:52:35 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>,
        "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH] davinci: DA850 EVM: OHCI platform code
Thread-Topic: [PATCH] davinci: DA850 EVM: OHCI platform code
Thread-Index: AQHMvuMCKNdu/0yQ4EWoLOXE9Vdo45XkNRcAgAGSTVA=
Date: Wed, 21 Dec 2011 05:52:13 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC026173@DBDE01.ent.ti.com>
References: <1324363005-11320-1-git-send-email-prakash.pm@ti.com>
 <4EF06C64.8000708@mvista.com>
In-Reply-To: <4EF06C64.8000708@mvista.com>
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

On Tue, Dec 20, 2011 at 16:37:16, Sergei Shtylyov wrote:
> Hello.
> 
> On 20.12.2011 10:36, Manjunathappa, Prakash wrote:
> 
> > From: Ajay Kumar Gupta <ajay.gupta@ti.com>
> 
>     It's a good practice to CC the original author of the patch -- which I'm 
> doing now...
> 

I did put author and maintainers in CC, my git send-email log shows it up as below. But I don't know why it doesnot appear when mails reach my inbox. Can you please let me know if I am missing any configuration?:

prakash@linux-psp-server:~/project/linux/linux_torvalds$ git send-email --smtp-server=192.168.247.13 --cc=nsekhar@ti.com --cc=linux-kernel@vger.kernel.org --cc=linux-arm-kernel@lists.infradead.org --cc=linux@arm.linux.org.uk 0001-davinci-DA850-EVM-OHCI-platform-code.patch
0001-davinci-DA850-EVM-OHCI-platform-code.patch
Who should the emails appear to be from? [Manjunathappa, Prakash <prakash.pm@ti.com>]
Emails will be sent from: Manjunathappa, Prakash <prakash.pm@ti.com>
Who should the emails be sent to? davinci-linux-open-source@linux.davincidsp.com
Message-ID to be used as In-Reply-To for the first email?
(mbox) Adding cc: Ajay Kumar Gupta <ajay.gupta@ti.com> from line 'From: Ajay Kumar Gupta <ajay.gupta@ti.com>'
(body) Adding cc: Ajay Kumar Gupta <ajay.gupta@ti.com> from line 'Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>'

From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: nsekhar@ti.com,
        linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk,
        Ajay Kumar Gupta <ajay.gupta@ti.com>
Subject: [PATCH] davinci: DA850 EVM: OHCI platform code
Date: Wed, 21 Dec 2011 11:05:38 +0530
Message-Id: <1324445738-7203-1-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.1

    The Cc list above has been expanded by additional
    addresses found in the patch commit message. By default
    send-email prompts before sending whenever this occurs.
    This behavior is controlled by the sendemail.confirm
    configuration setting.

    For additional information, run 'git send-email --help'.
    To retain the current behavior, but squelch this message,
    run 'git config --global sendemail.confirm auto'.

Send this email? ([y]es|[n]o|[q]uit|[a]ll):

> > On this board the OHCI port's power control and over-current signals from
> > TPS2065 power switch are connected via GPIO1[15] and GPIO2[1] respectively,
> 
>     Ajay, your description seems to be copied unchganged from the analogous 
> DA830 EVM patch, and thus doesn't match your patch: GPIO2[4] and GPIO6[13] are 
> used apparently. Be more attentive to detail next time please.
> 

I will fix this.

> > so we can implement the DA8xx OHCI glue layer's hooks for overriding the
> > root hub port's power and over-current status bits.
> 
> > We also have to properly set up the clocking mode in the CFGCHIP2 register,
> > so that internal 24 MHz reference clock is fed to the USB 2.0 (MUSB) PHY and
> > its output is used to clock the USB 1.1 (OHCI) PHY...
> 
> > Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
> > ---
> >   arch/arm/mach-davinci/board-da850-evm.c |  126 +++++++++++++++++++++++++++++++
> >   1 files changed, 126 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> > index 6659a90..df74ba5 100644
> > --- a/arch/arm/mach-davinci/board-da850-evm.c
> > +++ b/arch/arm/mach-davinci/board-da850-evm.c
> [...]
> > @@ -734,6 +736,127 @@ static struct davinci_i2c_platform_data da850_evm_i2c_0_pdata = {
> [...]
> > +static int da850_evm_usb_ocic_notify(da8xx_ocic_handler_t handler)
> > +{
> > +	int irq		= gpio_to_irq(ON_BD_USB_OVC);
> > +	int error	= 0;
> > +
> > +	if (handler != NULL) {
> > +		da850_evm_usb_ocic_handler = handler;
> > +
> > +		error = request_irq(irq, da850_evm_usb_ocic_irq, IRQF_DISABLED |
> 
>     IRQF_DISABLED is a nop now -- just remove it.
> 

Agreed, I will remove it.

Thanks,
Prakash
> WBR, Sergei
> 

