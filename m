Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab0J0T3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:29:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51005 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab0J0T3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:29:18 -0400
Date: Wed, 27 Oct 2010 20:29:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: toshiba_acpi.c: Full TOS1900 device support
Message-ID: <20101027192913.GA14828@srcf.ucam.org>
References: <AANLkTikff5b9zhCLEmyoHZPTPaREuHE1qp21SLA0v=83@mail.gmail.com> <20101026192028.GA17880@srcf.ucam.org> <AANLkTinmsNzAkp_ZGcaNyVRVMu0Rc4-C+xPKuSOS5jRJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinmsNzAkp_ZGcaNyVRVMu0Rc4-C+xPKuSOS5jRJ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 01:24:15PM -0600, Azael Avalos wrote:
> Yes, actually the ACPI video driver does a better job of detecting the
> video device,
> so perhaps something like the following would be better IMHO for at least the
> backlight:

Yeah, that looks better.

> Is there an ACPI function that let's us query the display brightness?
> Because TOS1900 devices lack the HCI method to query the LCD status,
> and thus the proc interface will be useless, that is, if a userland (or any
> other) application is using it.

Ignore the proc interface. Everyone should be using sysfs now. _BQC is 
the standardised ACPI function for this, but it's not always 
implemented.

> > Ugh. Use i8042_install_filter instead, and just look at the raw i8042
> > stream. That'll avoid the ugly strncmp for the device names in order to
> > find the right device.
> >
> 
> Can you point me to some documents (if any) or even pieces of code
> that I can look at.
> 
> I've tried using the i8042_install_filter function, but I haven't had
> any luck so far,
> or perhaps I'm using it in wrong, due to my limited kernel knowledge.

Take a look at the dell-laptop driver in drivers/platform/x86.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
