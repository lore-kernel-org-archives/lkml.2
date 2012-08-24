Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2HXWg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 18:36:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52745 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751879Ab2HXWgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 18:36:22 -0400
Message-ID: <1345847781.32359.15.camel@joe2Laptop>
Subject: Re: [PATCH] ACPI: power: Use KERN_DEBUG when no power resources are
 found
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Lin Ming <minggr@gmail.com>, Len Brown <lenb@kernel.org>,
        Aaron Lu <aaron.lu@amd.com>, linux-kernel@vger.kernel.org,
        Aaron Lu <aaron.lwe@gmail.com>, stable@vger.kernel.org
Date: Fri, 24 Aug 2012 15:36:21 -0700
In-Reply-To: <20120823132646.GD18279@aftab.osrc.amd.com>
References: <1344564353-493-1-git-send-email-aaron.lu@amd.com>
	 <20120823132646.GD18279@aftab.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 15:26 +0200, Borislav Petkov wrote:
> On Fri, Aug 10, 2012 at 10:05:53AM +0800, Aaron Lu wrote:
> > commit a606dac368eed5696fb38e16b1394f1d049c09e9 adds support to link
> > devices which have _PRx, if a device does not have _PRx, a warning
> > message will be printed.
> > 
> > This commit is for ZPODD on Intel's platform, on AMD's platform, there
> > is no _PRx to support ZPODD, we use _PSx.
> > 
> > So instead of printing a useless warning message on AMD's platform,
> > changing the print level to DEBUG to suppress this message.
[]
> > diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
[]
> > @@ -460,7 +460,7 @@ int acpi_power_resource_register_device(struct device *dev, acpi_handle handle)
> >  	return ret;
> >  
> >  no_power_resource:
> > -	printk(KERN_WARNING PREFIX "Invalid Power Resource to register!");
> > +	printk(KERN_DEBUG PREFIX "Invalid Power Resource to register!");

Perhaps add something like:
	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
		printk(etc...)
instead?


