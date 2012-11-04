Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2KDU6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 15:58:51 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:42092 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275Ab2KDU6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 15:58:49 -0500
Message-ID: <1352062724.14888.206.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
From: Matt Fleming <matt@console-pimps.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Alessandro Crismani <alessandro.crismani@gmail.com>,
        Mikhail Bakhterev <mike.bakhterev@gmail.com>,
        Patrick H <kernel@feystorm.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Sun, 04 Nov 2012 20:58:44 +0000
In-Reply-To: <20121104174713.GA28414@elie.Belkin>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
	 <20121104174713.GA28414@elie.Belkin>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-11-04 at 09:47 -0800, Jonathan Nieder wrote:
> Matt Fleming wrote:
> 
> > --- a/drivers/platform/x86/Kconfig
> > +++ b/drivers/platform/x86/Kconfig
> > @@ -717,7 +717,7 @@ config XO15_EBOOK
> > 
> >  config SAMSUNG_LAPTOP
> >  	tristate "Samsung Laptop driver"
> > -	depends on X86
> > +	depends on X86 && !EFI
> 
> That means distros would just not get the samsung-laptop driver.
> Is there a runtime check that could be used instead?

Well, the closest thing we have at the moment is the 'efi_enabled'
variable, but that doesn't actually mean "We were booted from EFI?", it
means "Do we have EFI runtime services?", and that's not a broad enough
check for this case. We don't have access to the EFI runtime services
when a 64-bit kernel is booted from 32-bit EFI firmware or vice-versa.
Notably the chromebooks use this scheme. And seeing as Samsung make
chromebooks, I'm not convinced we won't hit that case.

But yeah, you've got a valid point. Clearly we need a way to check this
at runtime. I'll repsin this patch.

-- 
Matt Fleming, Intel Open Source Technology Center

