Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab2KPUOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 15:14:14 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:49553 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab2KPUOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 15:14:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        bhelgaas@google.com, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 3/3] i2c / ACPI: add ACPI enumeration support
Date: Fri, 16 Nov 2012 21:18:35 +0100
Message-ID: <1525112.xFLEyNyU7b@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121116200934.GA17774@intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com> <5908031.ZEcDQlG5EW@vostro.rjw.lan> <20121116200934.GA17774@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 16, 2012 10:09:34 PM Mika Westerberg wrote:
> On Fri, Nov 16, 2012 at 09:02:36PM +0100, Rafael J. Wysocki wrote:
> > Ah, that's what's called by acpi_dev_get_resources().  But what about writing
> > it this way:
> > 
> > static int acpi_i2c_find_child_address(struct acpi_resource *ares, void *data)
> > {
> > 
> >        if (ares->type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
> >        	struct acpi_resource_i2c_serialbus *sb;
> > 
> >        	sb = &ares->data.i2c_serial_bus;
> >        	if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_I2C) {
> >        		struct acpi_i2c_find *i2c_find = data;
> > 
> >        		if (sb->slave_address == i2c_find->addr)
> > 				i2c_find->found = true;
> > 		}
> > 	}
> > 
> > 	/* Tell the ACPI core to skip this resource. */
> > 	return 1;
> > }
> 
> Not a problem at all, I'll do it like above and also with the SPI case.
> I'll wait til tomorrow for more comments and post v3 unless there are
> objections.

OK, thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
