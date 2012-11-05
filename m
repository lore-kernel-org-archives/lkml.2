Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab2KEMN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:13:28 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:42247 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752059Ab2KEMNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:13:25 -0500
Message-ID: <1352117601.14888.278.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
From: Matt Fleming <matt@console-pimps.org>
To: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Alessandro Crismani <alessandro.crismani@gmail.com>,
        Mikhail Bakhterev <mike.bakhterev@gmail.com>,
        Patrick H <kernel@feystorm.net>, "H. Peter Anvin" <hpa@zytor.com>,
        stable@vger.kernel.org
Date: Mon, 05 Nov 2012 12:13:21 +0000
In-Reply-To: <CAHR064isMXk8qkqhBJ==9sRRP7xC_j_K5rqXApza-LNkosp5mg@mail.gmail.com>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
	 <CAHR064isMXk8qkqhBJ==9sRRP7xC_j_K5rqXApza-LNkosp5mg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-11-04 at 17:44 +0000, Corentin Chary wrote:
> On Sun, Nov 4, 2012 at 5:35 PM, Matt Fleming <matt@console-pimps.org> wrote:
> > From: Matt Fleming <matt.fleming@intel.com>
> >
> > We've started getting reports of users seeing Machine Check Exceptions
> > when booting their Samsung laptops in UEFI mode,
> >
> >      https://bugzilla.kernel.org/show_bug.cgi?id=47121
> >
> > This module seems to be the culprit as it's grovelling around in the
> > 0xf0000 region which has no mapping in either the e820 or EFI memory
> > maps on the affected machines.
> >
> > Reported-by: Alessandro Crismani <alessandro.crismani@gmail.com>
> > Reported-by: Mikhail Bakhterev <mike.bakhterev@gmail.com>
> > Tested-by: Patrick H <kernel@feystorm.net>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Matthew Garrett <mjg@redhat.com>
> > Cc: Corentin Chary <corentincj@iksaif.net>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> > ---
> >  drivers/platform/x86/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> > index c86bae8..0fe5200 100644
> > --- a/drivers/platform/x86/Kconfig
> > +++ b/drivers/platform/x86/Kconfig
> > @@ -717,7 +717,7 @@ config XO15_EBOOK
> >
> >  config SAMSUNG_LAPTOP
> >         tristate "Samsung Laptop driver"
> > -       depends on X86
> > +       depends on X86 && !EFI
> >         depends on RFKILL || RFKILL = n
> >         depends on BACKLIGHT_CLASS_DEVICE
> >         select LEDS_CLASS
> > --
> > 1.7.11.7
> >
> 
> Acked-by: Corentin Chary <corentin.chary@gmail.com>
> 
> Matthew could you merge this in your tree ? Thanks.
> 
> Matt, any idea if SABI doesn't exist on these machines, or is just
> mapped somewhere else ?
> By any luck, could Samsung tell you how to safely detect SABI aware machines ?

I don't know whether or not SABI exists on these machines and I don't
have one of them to try and figure that out, sorry.

-- 
Matt Fleming, Intel Open Source Technology Center

