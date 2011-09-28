Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1I1POO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:14:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60880 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753251Ab1I1POL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:14:11 -0400
Date: Wed, 28 Sep 2011 11:14:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sudarshan Jagadale <snjagadale@gmail.com>
cc: linux-pci@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <linux-hotplug@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: hot plug stable pci name or active pci name detection from /sys
 file system
In-Reply-To: <CAEYgNqL8eceFdX_2FSk6oXg2J-7QmijD6oWwQMBS-kn8BwZfPg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1109281104550.1735-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, Sudarshan Jagadale wrote:

> Hi ,
> 
> I want to create "dev->bus->bus_name" without using usb.h file/writting
> kenel module. is there any way to do this or read the active pci name from
> /sys/ diectory on linux os?
> 
> i need to generate the bus info field as follows created by usb_make_path().
> 
> please help to resolve this?

There's probably a way to do it using libudev, but I don't know 
anything about it.

Another way to do it is to read the "serial" file in the sysfs 
directory for the device's root hub.  For example, suppose your USB 
device has a sysfs name like 7-1.2.  The bus number is the part before 
the '-' character, in this example, 7.  Then the file you should read 
would be /sys/bus/usb/devices/usb7/serial.  Replace the '7' with the 
appropriate bus number for whatever device you're working on.

Alan Stern

