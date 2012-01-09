Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab2AISO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 13:14:58 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39730 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755795Ab2AISO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 13:14:56 -0500
Date: Mon, 9 Jan 2012 10:14:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Incorrect uses of get_driver()/put_driver()
Message-ID: <20120109181449.GF15083@core.coreip.homeip.net>
References: <Pine.LNX.4.44L0.1201091133400.1541-100000@iolanthe.rowland.org>
 <Pine.LNX.4.44L0.1201091202090.1541-100000@iolanthe.rowland.org>
 <20120109190321.537038bc@milhouse>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120109190321.537038bc@milhouse>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 07:03:21PM +0100, Michael Büsch wrote:
> On Mon, 9 Jan 2012 12:35:09 -0500 (EST)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > drivers/ssb/main.c:146:               get_driver(&drv->drv);
> > drivers/ssb/main.c:153:               put_driver(&drv->drv);
> > 
> > Michael, these are part of ssb_driver_get() and ssb_driver_put(), used
> > in ssb_devices_freeze() and ssb_devices_thaw().  They don't currently
> > do anything, but it looks as if they are meant to prevent the driver
> > from being unloaded.  Should they be replaced with try_module_get()?  
> > Or would it be good enough to call device_attach() in 
> > ssb_devices_thaw()?
> 
> Hm, It seems that this code is trying to pin the ssb_driver, so that
> it doesn't become invalid during the freeze period. So it most likely wants
> to protect against module unload and driver unbind here. Not sure
> if that actually works, though :/
> 

Not at all ;)

-- 
Dmitry
