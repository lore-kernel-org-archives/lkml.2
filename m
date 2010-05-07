Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0EGI3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:29:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:37984 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab0EGI3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:29:31 -0400
Date: Fri, 7 May 2010 10:29:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
       Oliver Neukum <oneukum@suse.de>, linux-pm@lists.linux-foundation.org,
       list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Subject: Re: [linux-pm] s2ram slow (radeon) / failing (usb)
In-Reply-To: <Pine.LNX.4.44L0.1005061426160.1708-100000@iolanthe.rowland.org>
Message-ID: <alpine.LNX.2.00.1005071028320.9849@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1005061426160.1708-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010, Alan Stern wrote:

> On Thu, 6 May 2010, Bruno [UTF-8] Prémont wrote:
> 
> > > Bruno, can you confirm that the hang occurs during one of those 
> > > cancel_work_sync() calls?
> > 
> > No, it's not one of the cancel_work_sync() that hangs but it's the
> > del_timer_sync() right before them that hangs!
> > (del_timer_sync() also hangs if I put it last, so the cancel_work_sync()
> > don't hang anything)
> > 
> > static void hid_cancel_delayed_stuff(struct usbhid_device *usbhid)
> > {
> > 	del_timer_sync(&usbhid->io_retry); /* this one never returns */
> > 	cancel_work_sync(&usbhid->restart_work);
> > 	cancel_work_sync(&usbhid->reset_work);
> > }
> 
> Okay, I see what the problem is.  In usbhid_start() there's a bunch of
> statements initializing parts of the usbhid structure.  When probing
> fails those statements don't get executed, so the timer and workqueue
> things aren't set up properly.
> 
> This patch should fix it.

Indeed, good catch, thanks a lot Alan!

Could you please send to me with your Signed-off-by: line and short 
changelog, so that I could apply it with proper credit being given to you?

And Bruno, thanks a lot for excellent testing efforts.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
