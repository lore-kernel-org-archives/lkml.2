Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1C1PCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:02:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61564 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1C1PCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:02:38 -0400
Date: Mon, 28 Mar 2011 08:02:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Narendra_K@Dell.com,
        viro@zeniv.linux.org.uk, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Shyam_Iyer@Dell.com, Matt_Domsch@Dell.com, Charles_Rose@Dell.com,
        Jordan_Hargrave@Dell.com
Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Message-Id: <20110328080220.1390d28e.randy.dunlap@oracle.com>
In-Reply-To: <20110304101509.7eef7475@jbarnes-desktop>
References: <20110223131536.GA16707@fedora14-r610.blr.amer.dell.com>
	<20110223131734.GA6275@srcf.ucam.org>
	<20110304101509.7eef7475@jbarnes-desktop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D90A303.00F3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011 10:15:09 -0800 Jesse Barnes wrote:

> On Wed, 23 Feb 2011 13:17:34 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > On Wed, Feb 23, 2011 at 06:24:31PM +0530, Narendra_K@Dell.com wrote:
> > 
> > > This patch fixes the following build breakage introduced by the patch
> > > '[PATCH V3] Export ACPI _DSM provided firmware instance number and string to
> > > sysfs'.
> > 
> > First, you should include this as part of your original patch so that 
> > the build doesn't break during bisection.
> > 
> > > This is fixed by making fs/nls/nls_base.c compile conditionally into
> > > vmlinux by introducing a new config option CONFIG_NLS_BASE which is
> > > selected by (ACPI || DMI || NLS).
> > 
> > Why?
> > 
> > > -obj-$(CONFIG_NLS)		+= nls/
> > > +obj-y				+= nls/
> > 
> > You seem to have just broken building any of the NLS code as modules.
> > 
> > >  menuconfig NLS
> > >  	tristate "Native language support"
> > > +	select NLS_BASE
> > 
> > All CONFIG_NLS does is build nls_base.
> > 
> > > +config NLS_BASE
> > > +	bool "Base NLS functions"
> > > +	depends on ACPI || DMI
> > 
> > What in this code depends on ACPI or DMI?
> > 
> > > -obj-$(CONFIG_NLS)		+= nls_base.o
> > > +obj-$(CONFIG_NLS_BASE)		+= nls_base.o
> > 
> > And why make this change?
> > 
> > Just have something like
> > 
> > select NLS if (ACPI || DMI)
> > 
> > in drivers/pci/Kconfig.
> 
> Narendra, can you send me an updated patch including the build fix?
> Either using this approach or the other one I outlined in my other mail.


This driver still has build failures in linux-next 20110328.

pci-label.c:(.text+0x9a40): undefined reference to `utf16s_to_utf8s'

CONFIG_NLS=m

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
