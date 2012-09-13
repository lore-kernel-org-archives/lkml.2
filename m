Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab2IMNsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:48:25 -0400
Received: from mail.x86-64.org ([217.9.48.20]:34909 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab2IMNsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:48:22 -0400
Date: Thu, 13 Sep 2012 15:48:19 +0200
From: Borislav Petkov <bp@amd64.org>
To: Aaron Lu <aaron.lwe@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Lin Ming <minggr@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI: power: Use KERN_DEBUG when no power resources are
 found
Message-ID: <20120913134819.GD19691@aftab.osrc.amd.com>
References: <1344564353-493-1-git-send-email-aaron.lu@amd.com>
 <20120823132646.GD18279@aftab.osrc.amd.com>
 <1345847781.32359.15.camel@joe2Laptop>
 <20120829020134.GA1761@aaronlu.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120829020134.GA1761@aaronlu.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 10:01:36AM +0800, Aaron Lu wrote:
> On Fri, Aug 24, 2012 at 03:36:21PM -0700, Joe Perches wrote:
> > On Thu, 2012-08-23 at 15:26 +0200, Borislav Petkov wrote:
> > > On Fri, Aug 10, 2012 at 10:05:53AM +0800, Aaron Lu wrote:
> > > > commit a606dac368eed5696fb38e16b1394f1d049c09e9 adds support to link
> > > > devices which have _PRx, if a device does not have _PRx, a warning
> > > > message will be printed.
> > > > 
> > > > This commit is for ZPODD on Intel's platform, on AMD's platform, there
> > > > is no _PRx to support ZPODD, we use _PSx.
> > > > 
> > > > So instead of printing a useless warning message on AMD's platform,
> > > > changing the print level to DEBUG to suppress this message.
> > []
> > > > diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> > []
> > > > @@ -460,7 +460,7 @@ int acpi_power_resource_register_device(struct device *dev, acpi_handle handle)
> > > >  	return ret;
> > > >  
> > > >  no_power_resource:
> > > > -	printk(KERN_WARNING PREFIX "Invalid Power Resource to register!");
> > > > +	printk(KERN_DEBUG PREFIX "Invalid Power Resource to register!");
> > 
> > Perhaps add something like:
> > 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
> > 		printk(etc...)
> > instead?
> 
> Sorry for not describing this problem clear, this would also occur on
> Intel platforms as long as that device we are calling this register
> function on does not have any power resource attached to it.
> 
> So the problem is actually, does the acpi_power_resource_register_device
> function expect such input devices that they do not have any power
> resource attached? If yes, then it shouldn't complain with a warning
> message; if no, then we should probably check these conditions before
> making such a call.
> 
> Looking at the function itself, I think it expects such devices so a
> warning message here is not appropriate.

This is still present in -rc5.

Linus, this message obviously warns for no good reason. Can you please
pick up the patch at http://marc.info/?l=linux-kernel&m=134456468110431
since ACPI people don't seem to react here.

Btw, Aaron, the stable tag should be covering 3.4 too because the patch
that added the message actually is 0090def6c37c8:

$ git tag --contains 0090def6c37c8
v3.4
v3.4-rc1
v3.4-rc2
v3.4-rc3
v3.4-rc4
v3.4-rc5
v3.4-rc6
v3.4-rc7
v3.4.1
v3.4.2
v3.4.3
v3.4.4
v3.4.5
v3.4.6
v3.4.7
v3.5
v3.5-rc1
v3.5-rc2
v3.5-rc3
v3.5-rc4
v3.5-rc5
v3.5-rc6
v3.5-rc7
v3.6-rc1
v3.6-rc2
v3.6-rc3
v3.6-rc4
v3.6-rc5

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
