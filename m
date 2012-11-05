Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab2KERt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:49:29 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:4921 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2KERt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:49:27 -0500
Date: Mon, 5 Nov 2012 18:49:10 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com, grant.likely@secretlab.ca,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121105184910.1ecad91d@endymion.delvare>
In-Reply-To: <20121105171248.GJ24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
	<CACRpkdaZqka7g2ECAyD_bKhnoULhCP6cTJwMyEsTuVxiUiHy+A@mail.gmail.com>
	<20121105150326.3bbf69df@endymion.delvare>
	<1925265.4Cx64DgKbB@vostro.rjw.lan>
	<20121105145315.GI24532@intel.com>
	<20121105161920.44e8e1cb@endymion.delvare>
	<20121105171248.GJ24532@intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2012 19:12:48 +0200, Mika Westerberg wrote:
> On Mon, Nov 05, 2012 at 04:19:20PM +0100, Jean Delvare wrote:
> > I2C core fears that you're mixing up everything ;) I2C adapter devices
> > are struct i2c_adapter aka i2c-0, i2c-1 etc. i2c_client is for slave
> > devices. There's nothing wrong with i2c_clients sharing ->name, that's
> > even how device driver matching is achieved. The uniqueness of
> > i2c_clients is on their bus_id which is the combination of i2c adapter
> > number and slave address (e.g. 0-0050)
> 
> Yeah, I mixed I2C adapter and client. Thanks for correcting.
> 
> So if we create one I2C adapter from the platform bus code as we do now and
> then for each I2CSerialBus connector we create one I2C client (well, the
> one that is created when i2c_new_device() is called), everything should
> work, right?

Yes.

> Then I suggest that we have a list of serial bus resources in the struct
> acpi_device and create the I2C clients based on that.
> 
> > i2c_adapter->name should, OTOH, be unique. In i2c bus drivers we
> > usually append the base I/O address at the end of the name to guarantee
> > that. ACPI will have to come up with something similar.
> 
> It should already be unique in case of ACPI. We use ACPI _HID and _UID to
> achieve that.

Perfect.

-- 
Jean Delvare
