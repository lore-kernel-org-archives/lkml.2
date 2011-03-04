Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab1CDSP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:15:27 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:48524 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759903Ab1CDSPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:15:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=iXCHwgjehfETE7Xi4F8Y0zSXiutCDTuoVxCILBECtkhQ0WAot98T8ODTCNfEXPWxtEixkCLEqehZVSYGgeQqkwCD+6B53sSo5ZrVWxAmuw87k40ez7cq798vwYWLcX11;
Date: Fri, 4 Mar 2011 10:15:09 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Narendra_K@Dell.com, viro@zeniv.linux.org.uk, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Shyam_Iyer@Dell.com, Matt_Domsch@Dell.com, Charles_Rose@Dell.com,
        Jordan_Hargrave@Dell.com
Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Message-ID: <20110304101509.7eef7475@jbarnes-desktop>
In-Reply-To: <20110223131734.GA6275@srcf.ucam.org>
References: <20110223131536.GA16707@fedora14-r610.blr.amer.dell.com>
	<20110223131734.GA6275@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 13:17:34 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Wed, Feb 23, 2011 at 06:24:31PM +0530, Narendra_K@Dell.com wrote:
> 
> > This patch fixes the following build breakage introduced by the patch
> > '[PATCH V3] Export ACPI _DSM provided firmware instance number and string to
> > sysfs'.
> 
> First, you should include this as part of your original patch so that 
> the build doesn't break during bisection.
> 
> > This is fixed by making fs/nls/nls_base.c compile conditionally into
> > vmlinux by introducing a new config option CONFIG_NLS_BASE which is
> > selected by (ACPI || DMI || NLS).
> 
> Why?
> 
> > -obj-$(CONFIG_NLS)		+= nls/
> > +obj-y				+= nls/
> 
> You seem to have just broken building any of the NLS code as modules.
> 
> >  menuconfig NLS
> >  	tristate "Native language support"
> > +	select NLS_BASE
> 
> All CONFIG_NLS does is build nls_base.
> 
> > +config NLS_BASE
> > +	bool "Base NLS functions"
> > +	depends on ACPI || DMI
> 
> What in this code depends on ACPI or DMI?
> 
> > -obj-$(CONFIG_NLS)		+= nls_base.o
> > +obj-$(CONFIG_NLS_BASE)		+= nls_base.o
> 
> And why make this change?
> 
> Just have something like
> 
> select NLS if (ACPI || DMI)
> 
> in drivers/pci/Kconfig.

Narendra, can you send me an updated patch including the build fix?
Either using this approach or the other one I outlined in my other mail.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
