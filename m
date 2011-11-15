Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1KOBFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 20:05:40 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58964 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752900Ab1KOBFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 20:05:37 -0500
X-Sasl-enc: 11WTaSY5AgTiLIOGM6YpX+8jtjt8y56nMZaCcn1t5prK 1321319136
Date: Mon, 14 Nov 2011 16:59:51 -0800
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Chen <peter.chen@freescale.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        stern@rowland.harvard.edu, hzpeterchen@gmail.com
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
Message-ID: <20111115005951.GB26360@kroah.com>
References: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
 <201111142327.37524.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111142327.37524.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 11:27:37PM +0100, Rafael J. Wysocki wrote:
> On Monday, November 14, 2011, Peter Chen wrote:
> > There may be an issue when the user issue "reboot/shutdown" command, then
> > the device has shut down its hardware, after that, this runtime-pm featured
> > device's driver will probably be scheduled to do its suspend routine,
> > and at its suspend routine, it may access hardware, but the device has
> > already shutdown physically, then the system hang may be occurred.
> > 
> > I ran out this issue using an auto-suspend supported USB devices, like
> > 3G modem, keyboard. The usb runtime suspend routine may be scheduled
> > after the usb controller has been shut down, and the usb runtime suspend
> > routine will try to suspend its roothub(controller), it will access
> > register, then the system hang occurs as the controller is shutdown.
> > Signed-off-by: Peter Chen <peter.chen@freescale.com>
> 
> Greg, do you want me to take this one?

Please do:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
