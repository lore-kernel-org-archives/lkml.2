Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2EJQma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:42:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56981 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab2EJQm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:42:28 -0400
Date: Thu, 10 May 2012 09:42:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Manohar Vanga <manohar.vanga@cern.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v4 1/3] Staging: IndustryPack bus for the Linux Kernel
Message-ID: <20120510164224.GA13964@kroah.com>
References: <1336570041-32724-1-git-send-email-siglesias@igalia.com>
 <20120509211338.GA23322@kroah.com>
 <1336659838.3458.24.camel@fourier.local.igalia.com>
 <20120510153728.GA18574@kroah.com>
 <3c71a30f539ee297f781beede0a411f3@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3c71a30f539ee297f781beede0a411f3@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 05:34:54PM +0100, Samuel Iglesias Gonsálvez wrote:
> >>> > +struct ipack_device {
> >>> > +   char board_name[IPACK_BOARD_NAME_SIZE];
> >>>
> >>> Why not use dev->name?
> >>
> >>May I be wrong, do you refer rename it to "name"?
> >
> >rename what?  Why do you need a board name for a device?
> >Shouldn't that
> >just be the "name" for the device?  And as such, just use the
> >field you
> >already have.
> >
> 
> In struct device there is the field "init_name". There is a "name"
> field in the corresponding struct kobject inside of dev. This is the
> reason of my misunderstanding.
> 
> I will change it.

Use the function call to set the name, not the field directly, otherwise
bad things could happen.

> >>> > +   char bus_name[IPACK_BOARD_NAME_SIZE];
> >
> >And, why do you need a bus name?  Shouldn't that be implied based on
> >what bus the device is attached to?
> >
> 
> This is the name of the bus device. The problem here is that the
> ipoctal mezzanine needs to save the IRQ vector in his memory space
> in a different address depending of the carrier board it is plugged
> to.
> 
> It is described in IP-OCTAL's datasheet. So this bus_name variable
> gives the way to do it.

But why is this a string?  I don't understand why this needs to be in
the device, shouldn't it just be determined on which bus the device was
assigned to?  Shouldn't this be part of the register function?  Pass in
the bus it should be registered to and all should be good.

greg k-h
