Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab0K0PCm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:02:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64292 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab0K0PCk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:02:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LHVjeAjkY50kwanNF0mYyWLRI5sNEmOCuyG7ZZCpkMUfkFlEn57r1SmdZvFvrZCQcF
         s37juoAU0qC/Oy/N9M58o8++y3Q/UnaqamIzVsyHDzxya0eSp6YCGnD7XFO6txFCiYyB
         6Y1pLADyRLKtMMnTBDXZjYrb/Btai15tgDgyE=
MIME-Version: 1.0
In-Reply-To: <20101126182328.GA20923@oksana.dev.rtsoft.ru>
References: <20101125171541.GA18152@suse.de>
	<Pine.LNX.4.44L0.1011251521310.26094-100000@netrider.rowland.org>
	<20101126151131.GA26602@oksana.dev.rtsoft.ru>
	<20101126170348.GA3331@suse.de>
	<20101126182328.GA20923@oksana.dev.rtsoft.ru>
Date: Sat, 27 Nov 2010 23:02:37 +0800
Message-ID: <AANLkTinocHZBS4O7A2vhc-p6qX0wt04EfAi5Q2xgxSJW@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] USB: cns3xxx: Add EHCI and OHCI bus glue for
 cns3xxx SOCs
From: Lin Mac <mkl0301@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/27 Anton Vorontsov <cbouatmailru@gmail.com>:
> On Fri, Nov 26, 2010 at 09:03:48AM -0800, Greg KH wrote:
> [...]
>> > > As far as the callbacks are concerned, this looks fine.
>> > >
>> > > Acked-by: Alan Stern <stern@rowland.harvard.edu>
>> >
>> > Thanks Alan!
>> >
>> > Greg, should I treat your 'to ack it as well' as 'Acked-by'? :-)
>>
>> Yes please:
>>       Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> Thanks!
>
>
> Lin,
>
> Now that I tried these patches on the real hardware (EV1.3,
> silicon ver. 0xA), USB doesn't seem to work for me. FWIW,
> I use U-Boot from BSP release 1.0.
>
> Here is how it looks:
>
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> cns3xxx-ehci cns3xxx-ehci.0: CNS3XXX EHCI Host Controller
> cns3xxx-ehci cns3xxx-ehci.0: new USB bus registered, assigned bus number 1
> cns3xxx-ehci cns3xxx-ehci.0: irq 64, io mem 0x82000000
> cns3xxx-ehci cns3xxx-ehci.0: USB 0.0 started, EHCI 0.00
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 0 ports detected
> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> cns3xxx-ohci cns3xxx-ohci.0: CNS3XXX OHCI Host controller
> cns3xxx-ohci cns3xxx-ohci.0: new USB bus registered, assigned bus number 2
> cns3xxx-ohci cns3xxx-ohci.0: irq 91, io mem 0x88000000
> cns3xxx-ohci cns3xxx-ohci.0: init err (00000000 0000)
> ohci_hcd: can't start cns3xxx-ohci.0
> cns3xxx-ohci cns3xxx-ohci.0: startup error -75
> cns3xxx-ohci cns3xxx-ohci.0: USB bus 2 deregistered
> cns3xxx-ohci: probe of cns3xxx-ohci.0 failed with error -75
>
> I assume this is somehow related to the old hardware I use,
> but please take a look.
>
> I tried this on both 2.6.36 and 2.6.37-rc3. You can find your
> patches in this tree
>
>  git://git.infradead.org/users/cbou/linux-cns3xxx.git master
>
> I'll try to investigate (found a small issue already, patch
> down below), but if you beat me to it, please send a patch
> agaist the cns3xxx tree.
> Thanks,
I saw this issue on EVB v1.3 chip rev B, with your tree.
I'll do more test and see what I can do there.
Sorry that I didn't notice it more earlier.

> - - - -
> ARM: cns3xxx: Make cns3xxx_pwr_soft_rst_force() to actually reset blocks
>
> commit 6eb5d146d4535 ("ARM: cns3xxx: Use IO memory accessors everywhere")
> breaks cns3xxx_pwr_soft_rst_force() function, so that it doesn't write
> cleared bit into the register.
>
> This patch fixes the issue by adding the necessary __raw_writel().
>
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> ---
>  arch/arm/mach-cns3xxx/pm.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-cns3xxx/pm.c b/arch/arm/mach-cns3xxx/pm.c
> index 78fbaba..5e57955 100644
> --- a/arch/arm/mach-cns3xxx/pm.c
> +++ b/arch/arm/mach-cns3xxx/pm.c
> @@ -67,6 +67,7 @@ static void cns3xxx_pwr_soft_rst_force(unsigned int block)
>                reg &= ~(block & PM_SOFT_RST_REG_MASK);
>        } else {
>                reg &= ~(block & PM_SOFT_RST_REG_MASK);
> +               __raw_writel(reg, PM_SOFT_RST_REG);
>                reg |= (block & PM_SOFT_RST_REG_MASK);
>        }
>
> --
> 1.7.0.5
>
>
