Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab2AISDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 13:03:34 -0500
Received: from bues.ch ([80.190.117.144]:46242 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330Ab2AISDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 13:03:33 -0500
Date: Mon, 9 Jan 2012 19:03:21 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Incorrect uses of get_driver()/put_driver()
Message-ID: <20120109190321.537038bc@milhouse>
In-Reply-To: <Pine.LNX.4.44L0.1201091202090.1541-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1201091133400.1541-100000@iolanthe.rowland.org>
	<Pine.LNX.4.44L0.1201091202090.1541-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jan 2012 12:35:09 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> drivers/ssb/main.c:146:               get_driver(&drv->drv);
> drivers/ssb/main.c:153:               put_driver(&drv->drv);
> 
> Michael, these are part of ssb_driver_get() and ssb_driver_put(), used
> in ssb_devices_freeze() and ssb_devices_thaw().  They don't currently
> do anything, but it looks as if they are meant to prevent the driver
> from being unloaded.  Should they be replaced with try_module_get()?  
> Or would it be good enough to call device_attach() in 
> ssb_devices_thaw()?

Hm, It seems that this code is trying to pin the ssb_driver, so that
it doesn't become invalid during the freeze period. So it most likely wants
to protect against module unload and driver unbind here. Not sure
if that actually works, though :/

-- 
Greetings, Michael.
