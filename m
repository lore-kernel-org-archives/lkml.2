Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab0FVQxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:53:16 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:35328 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab0FVQxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:53:15 -0400
Message-ID: <4C20EA74.6090109@pardus.org.tr>
Date: Tue, 22 Jun 2010 19:53:08 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de, rjw@sisk.pl
Subject: Re: [BISECTED] Suspend regression in v2.6.31 with Lenovo 3000 v200
References: <Pine.LNX.4.44L0.1006221039530.1631-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006221039530.1631-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:

> Okay, the bus is usb2, the device attached to port 5 is a USB camera, 
> and it uses the Ali m5602 driver.  I have seen similar reports before, 
> but they involved a webcam using the uvcvideo driver.
> 
> Anyway, the problem is that the camera sends a wakeup request, which
> causes the suspend to be aborted.  I can't imagine why a camera would
> want to send a wakeup request -- probably it's a bug in the firmware.
> You can work around it by manually (or in a udev script) disabling
> wakeup on the camera:
> 
> 	echo disabled >/sys/bus/usb/devices/2-5/power/wakeup
> 
> Or you can back-port the patch that fixed the problem, commit 
> 7aba8d014341341590ecb64050b7a026642a62eb (USB: don't enable remote 
> wakeup by default).
> 
> Alan Stern

Thank you very much for your help but it seems that core/hub.c in 2.6.31.13
doesn't even include device_set_wakeup_enable() call that the commit you've
mentioned removes. There are 2 calls in core/hcd.c and 1 in core/hcd-pci.c
which at a quick glance still exists in the current master.

Should I disable the the remote wakeup in somewhere else or does that commit
doesn't really fix the issue?

Regards,

Ozan Caglayan
