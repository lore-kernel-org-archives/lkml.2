Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab2HQSof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:44:35 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50199 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810Ab2HQSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:44:19 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCHv3 1/1] [RFC] uartclk from serial_core exposed to sysfs
Date: Fri, 17 Aug 2012 20:44:14 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Tomas Hlavacek <tmshlvck@gmail.com>, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com> <CAEB7QLBEdNArtKz9zP7R4Za54049jJqCEqhPvE6rS59j1tD0PQ@mail.gmail.com> <20120817165446.GA12361@kroah.com>
In-Reply-To: <20120817165446.GA12361@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208172044.14868.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg KH,

> On Fri, Aug 17, 2012 at 06:30:36PM +0200, Tomas Hlavacek wrote:
> > Hello Greg!
> > 
> > On Fri, Aug 17, 2012 at 5:06 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >> @@ -2355,6 +2373,14 @@ int uart_add_one_port(struct uart_driver *drv,
> > >> struct uart_port *uport)
> > >> 
> > >>       }
> > >>       
> > >>       /*
> > >> 
> > >> +      * Expose uartclk in sysfs. Use driverdata of the tty device for
> > >> +      * referencing the UART port.
> > >> +      */
> > >> +     dev_set_drvdata(tty_dev, port);
> > >> +     if (device_create_file(tty_dev, &dev_attr_uartclk) < 0)
> > >> +             dev_err(tty_dev, "Failed to add uartclk attr\n");
> > > 
> > > I think you just raced with userspace in creating the file after the
> > > device was announced to userspace.  Are you sure it's ok?
> > > 
> > > If not (hint, I don't think so), please make it a default attribute of
> > > the device, which will then cause the file to be created before it is
> > > announced to userspace.  It will also be less code as you don't have to
> > > clean it up by hand :)
> > 
> > Do you mean I should modify the tty_register_device() function not to
> > use device_create() but it should rather do the device initialization
> > on it's own.
> 
> No, not at all.
> 
> > And I should add add the attribute (via struct attribute_group) to
> > struct device in between device_initialize() and device_add() calls.
> > Did I get it right?
> 
> No, make this a driver attribute, that way when the device is
> registered, it adds the attribute automagically to the device that is
> bound to it.

(hint, DEVICE_ATTR), right ?

> Does that make sense?
> 
> greg k-h

Best regards,
Marek Vasut
