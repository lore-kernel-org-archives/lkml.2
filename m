Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab1KOXNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:13:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41161 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab1KOXN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:13:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during shutdown
Date: Wed, 16 Nov 2011 00:16:08 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Peter Chen <peter.chen@freescale.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        stern@rowland.harvard.edu, hzpeterchen@gmail.com
References: <1321231380-11631-1-git-send-email-peter.chen@freescale.com> <201111142327.37524.rjw@sisk.pl> <20111115005951.GB26360@kroah.com>
In-Reply-To: <20111115005951.GB26360@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111160016.09174.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 15, 2011, Greg KH wrote:
> On Mon, Nov 14, 2011 at 11:27:37PM +0100, Rafael J. Wysocki wrote:
> > On Monday, November 14, 2011, Peter Chen wrote:
> > > There may be an issue when the user issue "reboot/shutdown" command, then
> > > the device has shut down its hardware, after that, this runtime-pm featured
> > > device's driver will probably be scheduled to do its suspend routine,
> > > and at its suspend routine, it may access hardware, but the device has
> > > already shutdown physically, then the system hang may be occurred.
> > > 
> > > I ran out this issue using an auto-suspend supported USB devices, like
> > > 3G modem, keyboard. The usb runtime suspend routine may be scheduled
> > > after the usb controller has been shut down, and the usb runtime suspend
> > > routine will try to suspend its roothub(controller), it will access
> > > register, then the system hang occurs as the controller is shutdown.
> > > Signed-off-by: Peter Chen <peter.chen@freescale.com>
> > 
> > Greg, do you want me to take this one?
> 
> Please do:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Done, thanks!

Rafael
