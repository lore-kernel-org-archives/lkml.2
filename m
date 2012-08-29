Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab2H2CCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 22:02:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44694 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab2H2CCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 22:02:07 -0400
Date: Wed, 29 Aug 2012 10:01:36 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Borislav Petkov <bp@amd64.org>, Lin Ming <minggr@gmail.com>,
        Len Brown <lenb@kernel.org>, Aaron Lu <aaron.lu@amd.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI: power: Use KERN_DEBUG when no power resources are
 found
Message-ID: <20120829020134.GA1761@aaronlu.sh.intel.com>
References: <1344564353-493-1-git-send-email-aaron.lu@amd.com>
 <20120823132646.GD18279@aftab.osrc.amd.com>
 <1345847781.32359.15.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345847781.32359.15.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 03:36:21PM -0700, Joe Perches wrote:
> On Thu, 2012-08-23 at 15:26 +0200, Borislav Petkov wrote:
> > On Fri, Aug 10, 2012 at 10:05:53AM +0800, Aaron Lu wrote:
> > > commit a606dac368eed5696fb38e16b1394f1d049c09e9 adds support to link
> > > devices which have _PRx, if a device does not have _PRx, a warning
> > > message will be printed.
> > > 
> > > This commit is for ZPODD on Intel's platform, on AMD's platform, there
> > > is no _PRx to support ZPODD, we use _PSx.
> > > 
> > > So instead of printing a useless warning message on AMD's platform,
> > > changing the print level to DEBUG to suppress this message.
> []
> > > diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> []
> > > @@ -460,7 +460,7 @@ int acpi_power_resource_register_device(struct device *dev, acpi_handle handle)
> > >  	return ret;
> > >  
> > >  no_power_resource:
> > > -	printk(KERN_WARNING PREFIX "Invalid Power Resource to register!");
> > > +	printk(KERN_DEBUG PREFIX "Invalid Power Resource to register!");
> 
> Perhaps add something like:
> 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
> 		printk(etc...)
> instead?

Sorry for not describing this problem clear, this would also occur on
Intel platforms as long as that device we are calling this register
function on does not have any power resource attached to it.

So the problem is actually, does the acpi_power_resource_register_device
function expect such input devices that they do not have any power
resource attached? If yes, then it shouldn't complain with a warning
message; if no, then we should probably check these conditions before
making such a call.

Looking at the function itself, I think it expects such devices so a
warning message here is not appropriate.

-Aaron
