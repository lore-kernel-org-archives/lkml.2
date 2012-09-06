Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2IFX6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 19:58:20 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:21337 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab2IFX6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 19:58:16 -0400
Message-ID: <1346975562.4732.256.camel@misato.fc.hp.com>
Subject: Re: [RFC PATCH 1/5] ACPI: Add acpi_lookup_driver() function
From: Toshi Kani <toshi.kani@hp.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
        liuj97@gmail.com, isimatu.yasuaki@jp.fujitsu.com
Date: Thu, 06 Sep 2012 17:52:42 -0600
In-Reply-To: <1346430252.4732.163.camel@misato.fc.hp.com>
References: <1346357766-14030-1-git-send-email-toshi.kani@hp.com>
	 <1346357766-14030-2-git-send-email-toshi.kani@hp.com>
	 <CAErSpo4nKzwFb6UfM068fqzW6J5ysKsP2cnngMnTA9GQaTmeXw@mail.gmail.com>
	 <1346430252.4732.163.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(snip)
 :
> > > +
> > > +       /* set HID to this device object */
> > > +       acpi_device_set_id(device);
> > > +
> > > +       /* lookup a matching driver */
> > > +       (void) bus_for_each_drv(device->dev.bus, NULL,
> > > +                                       device, acpi_match_driver);
> > > +       driver = device->driver;
> > 
> > This path is used when we receive a Notify to a device and a matching
> > driver has been registered, but the driver is not bound to the device.
> >  For example, it may be a newly-added device where we haven't bound a
> > driver to it yet.
> > 
> > Is there anything that prevents us from unloading the driver between
> > here (the point where we capture the "struct acpi_driver *") and the
> > point where we call "driver->ops.sys_notify"?
> 
> Hi Bjorn,
> 
> That's a very good question.  I will look into how we protect a driver
> from unloading when we try to attach & probe a driver in the
> acpi_add_single_object() path, and see if we can use a similar way to
> protect it here as well.

I have protected this path in version 2, which I just sent out.  It
calls .sys_notify() directly from bus_for_each_drv(), which protects the
driver entry by increasing its reference count while the callback
function is being called.

Thanks,
-Toshi
 



