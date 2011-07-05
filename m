Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1GES3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 14:29:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45712 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1GES3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 14:29:32 -0400
Date: Tue, 5 Jul 2011 19:29:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        rtc-linux@googlegroups.com, dannf@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: enable rtc-efi
Message-ID: <20110705182913.GA31808@srcf.ucam.org>
References: <4E12DBAB020000780004C1B2@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E12DBAB020000780004C1B2@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 08:38:51AM +0100, Jan Beulich wrote:
> Besides a Kconfig change this just requires creating a respective
> platform device.

Couple of other issues:

> +static struct platform_device rtc_efi_dev = {
> +	.name = "rtc-efi",
> +	.id = -1,
> +};

You haven't removed this from the IA64 code. Isn't that going to result 
in registering the same device twice?

> +static int __init rtc_init(void)
> +{
> +	if (efi_enabled && platform_device_register(&rtc_efi_dev) < 0)
> +		printk(KERN_ERR "unable to register rtc device...\n");

Ought to -ENODEV if efi isn't present? The error message should also be 
more verbose.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
