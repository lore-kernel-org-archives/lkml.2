Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397Ab2CGPqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:46:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62389 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2CGPqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:46:08 -0500
Message-ID: <1331135164.2516.8.camel@ayu>
Subject: Re: Change MAC address permanently
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 07 Mar 2012 10:46:04 -0500
In-Reply-To: <CAH9NwWcbYRq9z_i8BcuQoK05+=ugyLqymHh9H6y963xWNnp2EA@mail.gmail.com>
References: <CAH9NwWcbYRq9z_i8BcuQoK05+=ugyLqymHh9H6y963xWNnp2EA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 10:52 +0100, Christian Gmeiner wrote:
> Hi all,
> 
> I have found out that ioctl SIOCSIFHWADDR could be used to change the
> current MAC address
> of an Ethernet device. But the big problem is that after an reboot the
> change is gone. Is there
> an other way of changing the MAC address permanently?

An option that may be sufficient for your needs is if you simply modify
your Linux startup scripts to reset the MAC address of the card every
time the computer boots, by using a udev rule or editing the network
init script.

But if you /really/ want to change the MAC address burned into the
hardware...

In most PC network cards, the MAC address of the device is stored in an
EEPROM on the device, and has an initial value flashed when the device
is assembled.

Depending on the network card and driver in question, you may be able to
view and modify the contents of the EEPROM (which will contain various
other data that you want to avoid changing!) with the ethtool -e and -E
options. This can be a dangerous operation, so read the ethtool man page
first, and be careful.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

