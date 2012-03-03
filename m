Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2CCLn4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 06:43:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62800 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2CCLnz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 06:43:55 -0500
MIME-Version: 1.0
In-Reply-To: <20120302223853.GA24929@kroah.com>
References: <20120224152051.GA23232@mail.gnudd.com> <20120225004008.GA3973@kroah.com>
 <1380686.VGpImaUmFA@harkonnen> <20120302223853.GA24929@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 3 Mar 2012 12:43:34 +0100
Message-ID: <CAPXgP13-5URbxH9u344CnreRP2v9VR-ADcQRUBA5AdNj26P+LA@mail.gmail.com>
Subject: Re: How to make a bus with heterogeneous devices?
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Federico Vaga <federico.vaga@gmail.com>,
        Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 23:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Mar 02, 2012 at 11:18:59AM +0100, Federico Vaga wrote:

>> Maybe I'm missing something.
>
> I think you are.
>
> Kay, you know this area of the driver core better than I do at the
> moment, given your most recent changes here.  Any reason why Alessandro
> and Federico can't do the same thing that the sysdev rework did for
> their devices here?

Maybe I miss something but it sounds not that different from USB.

You have a bus that enumerates devices and a "bus driver" creates a
generic device on that bus for everything it finds. These devices stay
generic, do not have type-specific attributes, but export matches
again to bind other device-specific drivers, which create _new_ child
devices below the generic ones with the proper attributes matching
their individual type of devices. So every "logical" device is always
represented by one generic device and one type-specific child device.

All these devices, the generic ones and the type-specific ones can be
on the same bus (struct bus_type) when they get a "struct device_type"
assigned which carries the device-type specific set of attributes.

It's like USB, where we get a plain "usb_device" for every device
connected, then we look at each device to find out how many
"usb_interface" childs we need to create, and every interface device
offers again matches for more drivers again, like tty, storage, video,
... to bind to as child devices.

Wouldn't that work?

Kay
