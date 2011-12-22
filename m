Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab1LVM1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 07:27:38 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33865 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab1LVM1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 07:27:35 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
Subject: RE: [PATCH v2] davinci: DA850 EVM: OHCI platform code
Thread-Topic: [PATCH v2] davinci: DA850 EVM: OHCI platform code
Thread-Index: AQHMv7InDpObXctwwU2vJttYJMzT/5XmAl8w///TswCAAAVmgIAB7OYQ
Date: Thu, 22 Dec 2011 12:27:16 +0000
Message-ID: <DF0F476B391FA8409C78302C7BA518B6053054@DBDE01.ent.ti.com>
References: <1324452002-8388-1-git-send-email-prakash.pm@ti.com>
 <DF0F476B391FA8409C78302C7BA518B6051CB9@DBDE01.ent.ti.com>
 <4EF1CB8A.10309@mvista.com> <4EF1D011.8060103@mvista.com>
In-Reply-To: <4EF1D011.8060103@mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.157.80]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 17:54:49, Sergei Shtylyov wrote:
> Hello.
> 
> On 21-12-2011 16:05, I wrote:
> 
> >> On Wed, Dec 21, 2011 at 12:50:02, Manjunathappa, Prakash wrote:
> >>> From: Ajay Kumar Gupta<ajay.gupta@ti.com>
> 
> >>> On this board the OHCI port's power control and over-current signals from
> >>> TPS2065 power switch are connected via GPIO2[4] and GPIO6[13] respectively,
> >>> so we can implement the DA8xx OHCI glue layer's hooks for overriding the
> >>> root hub port's power and over-current status bits.
> 
> >>> We also have to properly set up the clocking mode in the CFGCHIP2 register,
> >>> so that internal 24 MHz reference clock is fed to the USB 2.0 (MUSB) PHY and
> >>> its output is used to clock the USB 1.1 (OHCI) PHY...
> 
> >>> Signed-off-by: Ajay Kumar Gupta<ajay.gupta@ti.com>
> >>> Signed-off-by: Manjunathappa, Prakash<prakash.pm@ti.com>
> 
> >> This is the third copy of OHCI platform setup code which is almost
> >> the same except for the GPIO numbers.
> 
> > Well, in my counting, it's only second, DA830 EVM being the first one.
> > What's the third?
> 
>     Ah, I missed Hawkboard... :-)
> 
>  >    I designed the hub interface to be as abstract as I could, and now you're
>  > proposing to add GPIO to it? No, I have no clear idea how to keeep it
>  > abstract and add GPIO support at the same time. I would have been grateful to
>  > TI if I didn't have to invent this at all and they stop saving on OHCI pins.
> 
>     Well, I have one idea. We can create a separate module in 
> arch/arm/mach-davinci/, named say ohci.c, put the shared code there and pass 
> to it the GPIOs actually used via a function call. Or maybe use existing 
> arch/arm/mach-davinci/usb.c.

Thanks Sergei. I think using the existing usb.c would be a better idea.

Prakash,

Can you please go ahead with this approach and post updated patches.

Thanks,
Sekhar
