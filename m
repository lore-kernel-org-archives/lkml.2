Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab2HQQar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:30:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36654 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab2HQQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:30:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120817150603.GA13684@kroah.com>
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
	<1345214637-4189-1-git-send-email-tmshlvck@gmail.com>
	<20120817150603.GA13684@kroah.com>
Date: Fri, 17 Aug 2012 18:30:36 +0200
Message-ID: <CAEB7QLBEdNArtKz9zP7R4Za54049jJqCEqhPvE6rS59j1tD0PQ@mail.gmail.com>
Subject: Re: [PATCHv3 1/1] [RFC] uartclk from serial_core exposed to sysfs
From: Tomas Hlavacek <tmshlvck@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, marek.vasut@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg!

On Fri, Aug 17, 2012 at 5:06 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> @@ -2355,6 +2373,14 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
>>       }
>>
>>       /*
>> +      * Expose uartclk in sysfs. Use driverdata of the tty device for
>> +      * referencing the UART port.
>> +      */
>> +     dev_set_drvdata(tty_dev, port);
>> +     if (device_create_file(tty_dev, &dev_attr_uartclk) < 0)
>> +             dev_err(tty_dev, "Failed to add uartclk attr\n");
>
> I think you just raced with userspace in creating the file after the
> device was announced to userspace.  Are you sure it's ok?
>
> If not (hint, I don't think so), please make it a default attribute of
> the device, which will then cause the file to be created before it is
> announced to userspace.  It will also be less code as you don't have to
> clean it up by hand :)

Do you mean I should modify the tty_register_device() function not to
use device_create() but it should rather do the device initialization
on it's own. And I should add add the attribute (via struct
attribute_group) to struct device in between device_initialize() and
device_add() calls. Did I get it right?

Thanks,
Tomas
