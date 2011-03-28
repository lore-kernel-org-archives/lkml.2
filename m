Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab1C1TYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 15:24:18 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:46617 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab1C1TYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 15:24:15 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Mar 2011 15:24:14 EDT
X-Loopcount0: from 10.175.216.250
From: <Shyam_Iyer@Dell.com>
To: <randy.dunlap@oracle.com>, <jbarnes@virtuousgeek.org>
CC: <mjg59@srcf.ucam.org>, <Narendra_K@Dell.com>, <viro@zeniv.linux.org.uk>,
        <sfr@canb.auug.org.au>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <Matt_Domsch@Dell.com>,
        <Charles_Rose@Dell.com>, <Jordan_Hargrave@Dell.com>
Date: Tue, 29 Mar 2011 00:44:23 +0530
Subject: RE: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Thread-Topic: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Thread-Index: AcvtWVabPqcvnyN3S8CPxV4lfbgJTgAISvwQ
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D15702659CFB3D@BLRX7MCDC203.AMER.DELL.COM>
References: <20110223131536.GA16707@fedora14-r610.blr.amer.dell.com>
	<20110223131734.GA6275@srcf.ucam.org>
	<20110304101509.7eef7475@jbarnes-desktop>
 <20110328080220.1390d28e.randy.dunlap@oracle.com>
In-Reply-To: <20110328080220.1390d28e.randy.dunlap@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
> Sent: Monday, March 28, 2011 11:02 AM
> To: Jesse Barnes
> Cc: Matthew Garrett; K, Narendra; viro@zeniv.linux.org.uk;
> sfr@canb.auug.org.au; linux-kernel@vger.kernel.org; linux-
> next@vger.kernel.org; Iyer, Shyam; Domsch, Matt; Rose, Charles;
> Hargrave, Jordan
> Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
> allmodconfig
> 
> On Fri, 4 Mar 2011 10:15:09 -0800 Jesse Barnes wrote:
> 
> > On Wed, 23 Feb 2011 13:17:34 +0000
> > Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >
> > > On Wed, Feb 23, 2011 at 06:24:31PM +0530, Narendra_K@Dell.com
> wrote:
> > >
> > > > This patch fixes the following build breakage introduced by the
> patch
> > > > '[PATCH V3] Export ACPI _DSM provided firmware instance number
> and string to
> > > > sysfs'.
> > >
> > > First, you should include this as part of your original patch so
> that
> > > the build doesn't break during bisection.
> > >
> > > > This is fixed by making fs/nls/nls_base.c compile conditionally
> into
> > > > vmlinux by introducing a new config option CONFIG_NLS_BASE which
> is
> > > > selected by (ACPI || DMI || NLS).
> > >
> > > Why?
> > >
> > > > -obj-$(CONFIG_NLS)		+= nls/
> > > > +obj-y				+= nls/
> > >
> > > You seem to have just broken building any of the NLS code as
> modules.
> > >
> > > >  menuconfig NLS
> > > >  	tristate "Native language support"
> > > > +	select NLS_BASE
> > >
> > > All CONFIG_NLS does is build nls_base.
> > >
> > > > +config NLS_BASE
> > > > +	bool "Base NLS functions"
> > > > +	depends on ACPI || DMI
> > >
> > > What in this code depends on ACPI or DMI?
> > >
> > > > -obj-$(CONFIG_NLS)		+= nls_base.o
> > > > +obj-$(CONFIG_NLS_BASE)		+= nls_base.o
> > >
> > > And why make this change?
> > >
> > > Just have something like
> > >
> > > select NLS if (ACPI || DMI)
> > >
> > > in drivers/pci/Kconfig.
> >
> > Narendra, can you send me an updated patch including the build fix?
> > Either using this approach or the other one I outlined in my other
> mail.
> 
> 
> This driver still has build failures in linux-next 20110328.
> 
> pci-label.c:(.text+0x9a40): undefined reference to `utf16s_to_utf8s'
> 
> CONFIG_NLS=m

I don't get this.. you should not be getting CONFIG_NLS=m unless you have stripped you config files really.. :-) Is it possible to get your .config to hit this issue.

-Shyam
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your
> code ***
