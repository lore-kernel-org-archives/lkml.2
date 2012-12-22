Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab2LVL1H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 06:27:07 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:54233 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2LVL1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 06:27:05 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2012 06:27:05 EST
From: Federico Vaga <federico.vaga@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] spidev.c: add sysfs attributes for SPI configuration
Date: Sat, 22 Dec 2012 12:21:15 +0100
Message-ID: <4348691.tj7B63aR8x@number-5>
User-Agent: KMail/4.9.4 (Linux/3.6.10-2.fc17.x86_64; KDE/4.9.4; x86_64; ; )
In-Reply-To: <20121222094725.797F03E03CE@localhost>
References: <1353777608-24934-1-git-send-email-federico.vaga@gmail.com> <1440955.3UsNh3CGzX@number-5> <20121222094725.797F03E03CE@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm cautious about adding operational interfaces to sysfs because it
> can be quite difficult to get the locking right. To begin with it
> splits up a single interface into multiple files, any of which can
> be held open by a process. Then there is the question of ordering
> of operations when there are multiple users. For instance, if there
> were two users, each of which using different transfer parameters,
> a sysfs interface doesn't provide any mechanism to group setting up
> the device with the transfer.
> 
> These are lessons learned the hard way with the gpio sysfs abi. I
> don't want to get caught in the same trap for spi.
> 
> g.

I understand the problem, but I think that for very simple test on 
devices, sysfs is easier. For example, it happens that a SPI device 
does not work correctly with a driver, so I want to verify the SPI 
traffic by writing directly the device commands and check with an 
oscilloscope. I think that an easy way is to use sysfs like this:

echo 123456 > speed_hz
[other options if needed]
echo  -n -e "\x12\x34" > /dev/spidev1.1
[oscilloscope]
hexdump -n 2 /dev/spidev1.1

This sysfs interface should be used only for testing/debugging, not to 
develop an user space driver on it; moreover, the ioctl interface is 
still there.

spidev_test and spidev_fdx does not allow me to customize tx buffer and 
I think (very personal opinion) that for debugging purpose is better 
sysfs with well known programs (echo, cat, hexdump, od) and 
oscilloscope. 

I know that I'm not so persuasive :) I can develop a simple program 
that can write custom tx buf with ioctl

-- 
Federico Vaga
