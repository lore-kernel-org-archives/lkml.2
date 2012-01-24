Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab2AXGOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 01:14:45 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60665 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab2AXGOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 01:14:43 -0500
Date: Tue, 24 Jan 2012 00:14:30 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-bluetooth@vger.kernel.org
Cc: Andres Cimmarusti <acimmarusti@gmail.com>, linux-kernel@vger.kernel.org,
        info@linuxcertified.com, Paul Fertser <fercerpav@gmail.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: firmware loading failure for AR3011 (0cf3:3000 or 0cf3:3005 ?)
Message-ID: <20120124061430.GB30210@burratino>
References: <CAH=dYrHhttmRjkVuo9QvJ5_Uqd+BJGCJJkaMw8153RW1SFv9dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH=dYrHhttmRjkVuo9QvJ5_Uqd+BJGCJJkaMw8153RW1SFv9dA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andres Cimmarusti wrote[1]:

> This is my device:
>
> Bus 001 Device 003: ID 0cf3:3000 Atheros Communications, Inc. AR3011 Bluetooth (no firmware)
>
> It does not turn on and kern.log shows following errors:
>
> [    9.335184] ath3k_load_firmware: Can't change to loading configuration err
> [    9.335413] ath3k: probe of 1-1.3:1.0 failed with error -110

Further investigation revealed that the problem seems to be in
userspace: various kernels including a 2.6.32.y-based and 3.1.8-based
one reproducibly exhibit this behavior with a Debian wheezy userspace
and do _not_ exhibit the problem in Debian squeeze, Ubuntu 11.10, or
Fedora 16.  More results:

 * The problem does not seem to be udev: downgrading udev in wheezy
   does not make the problem go away, and upgrading udev in squeeze
   does not provoke trouble.

 * The problem does not seem to be firmware-atheros: upgrading the
   firmware in squeeze does not provoke trouble.

 * The problem does not seem to be usb-modeswitch, for similar
   reasons.  (You can see us grasping at straws here.)

I guess the next natural component to blame is bluez.

Any hints (e.g., debugging switches) for tracking this down?

Thanks,
Jonathan

[1] http://bugs.debian.org/641749
