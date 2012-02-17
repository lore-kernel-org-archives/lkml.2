Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2BQWEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:04:05 -0500
Received: from xes-mad.com ([216.165.139.218]:58143 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab2BQWEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:04:01 -0500
Date: Fri, 17 Feb 2012 16:03:48 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter@roeck-us.net>, Peter Tyser <ptyser@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3 v3] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <23e491f9-cb12-4bba-b5b0-a9948b17c984@zimbra>
In-Reply-To: <20120217222155.435195d2@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC15 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static void __devexit lpc_ich_remove(struct pci_dev *dev)
> > +{
> > +	mfd_remove_devices(&dev->dev);
> > +
> > +	if (lpc_ich_gpio_save > 0)
> > +		pci_write_config_byte(dev, GPIOCTRL, (u8)lpc_ich_gpio_save);
> > +	if (lpc_ich_acpi_save > 0)
> > +		pci_write_config_byte(dev, ACPICTRL, (u8)lpc_ich_acpi_save);
> 
> I think you really mean >= 0 above. And the casts aren't needed. You
> should also reset lpc_ich_gpio_save and lpc_ich_acpi_save to -1 after
> restoring the values, it matters if the device is removed and re-added
> through sysfs.

I seriously almost changed that compare in this patch... I wish I had. I've
made these changes, now.

> This cleanup is missing from the error path in lpc_ich_probe, BTW.
> You may want to move it to a separate function so that you can call it
> from both lpc_ich_probe and lpc_ich_remove.

Good point. I've got this change ready to go, too. Thanks.

-Aaron S.
