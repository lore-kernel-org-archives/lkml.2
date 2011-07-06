Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1GFLm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 07:42:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42648 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1GFLmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 07:42:25 -0400
Date: Wed, 6 Jul 2011 12:42:08 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, rtc-linux@googlegroups.com, dannf@hp.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: enable rtc-efi
Message-ID: <20110706114208.GA16578@srcf.ucam.org>
References: <4E12DBAB020000780004C1B2@nat28.tlf.novell.com>
 <20110705182913.GA31808@srcf.ucam.org>
 <4E142659020000780004C50D@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E142659020000780004C50D@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 08:09:45AM +0100, Jan Beulich wrote:
> >>> On 05.07.11 at 20:29, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > You haven't removed this from the IA64 code. Isn't that going to result 
> > in registering the same device twice?
> 
> How would code under arch/ia64/ and code under arch/x86/ ever
> manage to register the same device twice?

Gah. Sorry, I misread and thought thsi was in the generic code too.

> >> +static int __init rtc_init(void)
> >> +{
> >> +	if (efi_enabled && platform_device_register(&rtc_efi_dev) < 0)
> >> +		printk(KERN_ERR "unable to register rtc device...\n");
> > 
> > Ought to -ENODEV if efi isn't present? The error message should also be 
> > more verbose.
> 
> I would agree on the -ENODEV part, but the error message is what
> the original ia64 code (which I simply copied over and modified
> slightly) has, so if a change is needed it ought to be done there first
> I would think. Additionally I can't really see what meaningful addition
> to the error message you envision.

EFI is the only way to access the rtc on IA64, whereas on x86 you'll 
almost certainly also have direct hardware access as well. Make it clear 
which rtc device you're unable to register.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
