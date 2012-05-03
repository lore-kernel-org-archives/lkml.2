Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab2ECPdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:33:05 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49595 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932083Ab2ECPdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:33:02 -0400
Date: Thu, 3 May 2012 08:32:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] add support for IndustryPack devices
Message-ID: <20120503153257.GB20334@kroah.com>
References: <1336031267-10689-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336031267-10689-1-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 09:47:44AM +0200, Samuel Iglesias Gonsalvez wrote:
> Hello Kernel Developers,
> 
> The bunch of patches add support for IndustryPack devices as a carrier board
> called TEWS TPCI-200 and a mezzanine board called IP-OCTAL, among a virtual bus
> driver called ipack.
> 
> TPCI-200 is a bridge between PCIe and IndustryPack with 4 slots. IP-OCTAL is a
> 8 channel serial port device that, depending of the model, can talk RS-232,
> RS-422 or RS-485.
> 
> The ipack driver is just an abstraction of the bus providing the common
> operations between the two aforementioned devices.
> 
> These drivers have been tested some time ago in an old kernel version at CERN
> (2.6.24) and they are working there. The present ones are just a clean-up of the
> original ones to be, hopefully, integrated mainstream.
> 
> These drivers have several ugly hacks that I want to fix:
> 
> * TPCI-200: it receives the name of the mezzanine plugged in each slot by SYSFS.
>   No autodetection supported yet, because the mezzanine driver could not be
>   loaded at the time that the tpci200 driver loads.
> 
> * IP-OCTAL: it has a linked list which saves the devices it is currently
>   managing. It should use the driver_for_each_device() function. It is not there
>   due to the impossibility of using container_of macro to recover the
>   corresponding "struct ipoctal" because the attribute "struct ipack_device" is
>   a pointer. This code should be refactored.
> 
> * Ipack: the structures and API exported can be improved a lot. For example, the
>   way to unregistering mezzanine devices, doing the mezzanine driver a call to
>   remove_device() to notify the carrier driver, or the opposite with the call to
>   the ipack_driver_ops' remove() function could be improved.   

These things are what should show up in your TODO file, not the vague
sentances currently in there.

Care to redo it with that type of information and resend?

thanks,

greg k-h
