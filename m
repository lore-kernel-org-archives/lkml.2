Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234Ab1CDVa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:30:28 -0500
Received: from kroah.org ([198.145.64.141]:38813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760210Ab1CDVa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:30:26 -0500
Date: Fri, 4 Mar 2011 13:28:51 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
Message-ID: <20110304212851.GB28680@kroah.com>
References: <20110303204749.GY3663@linux.intel.com>
 <20110303211336.GA32645@kroah.com>
 <20110303214104.GZ3663@linux.intel.com>
 <20110303215155.GA30451@kroah.com>
 <20110303220735.GA3663@linux.intel.com>
 <20110303222226.GA30966@kroah.com>
 <20110304124348.6419c661@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304124348.6419c661@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 12:43:48PM +0000, Alan Cox wrote:
> On Thu, 3 Mar 2011 14:22:26 -0800
> > > How would the driver know that it should call request_firmware()?
> > > Do it every 60 seconds in case somebody's downloaded some new firmware?
> > 
> > Ick, no, just use the function provided that lets you create a firmware
> > request and be notified when it is written to,
> > request_firmware_nowait().  That is what it is there for.
> 
> Bunkum
> 
> It's there for automated loading of needed firmware

And non-automated loading of firmware as well.  Dell uses this for
updating their BIOSes just fine, with a userspace tool that initiates
the loading of the firmware.

> > Anyway, just use request_firmware_nowait(), you will be fine.
> 
> Not really. You've got no way with the request_firmware interface for the
> user space and kernel space to reliably time objects together eg to do
> user side work before a firmware load.

How does Dell do it?

> Almost all the other stuff in the kernel which is for firmware
> programming as opposed to automatic loading is not using request_firmware
> - and for good reasons like needing to be able to specify the path to the
> object reliably - which cannot be done with namespaces.
> 
> From a security perspective, a correctness perspective, for reliability
> and managability request_firmware is the wrong interface for flashing new
> firmware.

Tell me how you really feel now :)

So, what could be changed in the current firmware interface to fix this
problem in a manner which would solve these perceived issues?

thanks,

greg k-h
