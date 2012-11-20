Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab2KTSJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:09:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65249 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab2KTSJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:09:09 -0500
Date: Tue, 20 Nov 2012 10:09:05 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jean Delvare <khali@linux-fr.org>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [Update][PATCH 0/3] ACPI: Simplify "glueing" to physical nodes
Message-ID: <20121120180905.GC12328@kroah.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
 <20121118155539.GE17774@intel.com>
 <1758879.PKgPhTGcB7@vostro.rjw.lan>
 <4036218.zBRlg5OZsZ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4036218.zBRlg5OZsZ@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 01:55:46AM +0100, Rafael J. Wysocki wrote:
> On Sunday, November 18, 2012 10:10:33 PM Rafael J. Wysocki wrote:
> > On Sunday, November 18, 2012 05:55:39 PM Mika Westerberg wrote:
> > > On Sat, Nov 17, 2012 at 12:24:45PM +0100, Rafael J. Wysocki wrote:
> > > > Well, maybe there is one.  Perhaps we can make acpi_platform_notify() 
> > > > call acpi_bind_one() upfront and only if that fails, do the whole
> > > > type->find_device() dance?  Of course, acpi_bind_one() would need to
> > > > be modified slightly too, like in the patch below.
> > > > 
> > > > If we did that, acpi_i2c_add_device() would only need to assign acpi_handle
> > > > as appropriate before calling i2c_new_device() (and analogously for SPI).
> > > > 
> > > > What do you think? 
> > > 
> > > This is certainly better than the thing we use currently. It makes adding
> > > I2C and SPI support much shorter and simpler. If others don't object I
> > > would suggest that we switch to use this method.
> > 
> > OK, thanks.
> > 
> > The first of the following two patches is a slightly modified version of the
> > one that you commented.  Patch [2/2] implements the idea for platform devices
> > and since it modifies struct platform_device_info, I'm adding a CC to Greg.
> > 
> > The patches are on top of current linux-pm.git/linux-next.
> > 
> > It looks like we may be able to use this approach for PCI too, in which case
> > the whole .find_device() stuff won't be necessary any more.
> 
> Following is the series with the Greg's feedback taken into account.
> Patch [1/3] is the same as before with the bug found by Mika fixed, [2/3] is
> an additional patch adding struct acpi_dev_node to compile out unused stuff if
> CONFIG_ACPI is not set and [3/3] is the previous [2/2] rebased on top of it.

Looks great, thanks for the changes.  I'm assuming this will go through
your tree, right?

greg k-h
