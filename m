Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab0HCRiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:38:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34306 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab0HCRhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:37:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=xRkdedb5GlaDA4wwiaH6oO8gaaUdNfzmi7BPrQyohpTVtW5T3HUrFi+kWu8ODyqKtR
         aIp9FvHSt0DNgNsfQLZef5eqIayYpARjwgtrCbCVXvOheohcnvgjRoDcjIKFPbiHCa+o
         0jLmdQttYPMkdwNhAIlcSPN7PRtkqy799NrbI=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] USB-serial dummy cable driver
Date: Tue, 3 Aug 2010 19:36:39 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        nm127@freemail.hu, linux-kernel@vger.kernel.org, maxinbjohn@gmail.com,
        forest.bond@outpostembedded.com, vijaykumar@zilogic.com
References: <1280728807-20296-1-git-send-email-marek.vasut@gmail.com> <201008031814.15859.marek.vasut@gmail.com> <20100803163826.GA757@suse.de>
In-Reply-To: <20100803163826.GA757@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008031936.39556.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Út 3. srpna 2010 18:38:26 Greg KH napsal(a):
> On Tue, Aug 03, 2010 at 06:14:15PM +0200, Marek Vasut wrote:
> > Dne Út 3. srpna 2010 00:47:18 Greg KH napsal(a):
> > > On Mon, Aug 02, 2010 at 08:00:07AM +0200, Marek Vasut wrote:
> > > > This driver is used to implement USB-serial like behaviour over dummy
> > > > 
> > > > USB cables. These are used in the following devices:
> > > > 	Funsoft Serial USB driver
> > > > 	Genesys Logic GL620USB USB Laplink cable
> > > > 	HP4x (48/49) Serial cable
> > > > 	Motorola phones
> > > > 	Siemens USB-MPI Serial USB driver
> > > > 	ViVOpay USB Serial Driver
> > > > 	ZIO Motherboard USB driver
> > > 
> > > I like the idea, but not the name :)
> > 
> > Please don't expect miracles from me after 26 hours without sleep ;-)
> > 
> > > Ideally, all of these would be able to be handled by the usb-serial
> > > generic driver directly.
> > 
> > I just noticed that one. Stupid me.
> > 
> > > But really, having these multiple drivers is a good thing, they
> > > properly convey to the user what the device is, and it gives these
> > > developers and companies a sense of ownership over the code, and that
> > > matters at times.
> > > 
> > > So you lost the names of the devices with this patch, which isn't good.
> > 
> > Sheesh ... that's true, but having pile of copies of the same code is not
> > good either.
> 
> I agree, that's why I said it should be reduced.
> 
> > Can't we then just deprecate all these drivers and set correct udev
> > rules?
> 
> udev can not change the name of the device in sysfs, or the name in the
> kernel of the device.

That's right, but it can bind the generic driver with the hardware. And who 
would care about the driver name, really ? The interface just appears and that's 
what matters (to me and probably to users) ...
> 
> thanks,
> 
> greg k-h
