Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1GGOKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:10:36 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:54785 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825Ab1GGOKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:10:34 -0400
X-Sasl-enc: 92W0+jSJrHaAT8fcrfgFInMT8N9wDjfs6JHx+Afx47VF 1310047833
Date: Thu, 7 Jul 2011 07:10:22 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.0-rc6: USB khubd deadlock when hub is powered down
Message-ID: <20110707141022.GC27648@kroah.com>
References: <20110707100501.68a21fb8@stein>
 <20110707152958.42c88aec@stein>
 <20110707153849.51691bc4@stein>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20110707153849.51691bc4@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 07, 2011 at 03:38:49PM +0200, Stefan Richter wrote:
> On Jul 07 Stefan Richter wrote:
> > It appears to be a regression from -rc4 to -rc6.  At the second occasion
> > that I switched the monitor off while running 3.0-rc6, the same happened
> > again.  (IOW judging from the mere two tries I did so far, this issue is
> > 100% reproducible.)
> > 
> > khubd locked up; no subsequent device re-attachments were recognized;
> > only an USB mouse that was attached to a motherboard USB port already
> > before the deadlock continued to let me move the pointer.
> 
> Sarah, "gitk v3.0-rc4.. drivers/usb/core/" makes it look like this is from
> commit fccf4e86200b8f5edd9a65da26f150e32ba79808.  When I find spare time I
> will test 3.0-rc6 with that one reverted.

Can you test Linus's tree, along with a patch sent yesterday from Alan
Stern to the linux-usb mailing list (attached below)?  That should
resolve this issue, if not, please let us know.

thanks,

greg k-h

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=s

>From stern+4e0774f0@rowland.harvard.edu Wed Jul  6 14:03:47 2011
Return-Path: <stern+4e0774f0@rowland.harvard.edu>
X-OfflineIMAP: 2303515278-5823848424
Delivered-To: unknown
Received: from imap.suse.de ([unix socket])
	 by imap-int (Cyrus v2.2.12) with LMTPA;
	 Wed, 06 Jul 2011 23:03:47 +0200
X-Sieve: CMU Sieve 2.2
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "relay.suse.de", Issuer "CAcert Class 3 Root" (verified OK))
	by imap.suse.de (Postfix) with ESMTPS id 685C43C539A9
	for <gregkh@imap.suse.de>; Wed,  6 Jul 2011 23:03:47 +0200 (CEST)
Received: by relay2.suse.de (Postfix)
	id 5F09B1855766; Wed,  6 Jul 2011 23:03:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id 53D4018552DE
	for <gregkh@suse.de>; Wed,  6 Jul 2011 23:03:47 +0200 (CEST)
Received: from relay2.suse.de ([127.0.0.1])
 by localhost (localhost [127.0.0.1]) (amavisd-new, port 10026) with ESMTP
 id 07676-11 for <gregkh@suse.de>; Wed,  6 Jul 2011 23:03:47 +0200 (CEST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 0B33018552CC
	for <gregkh@suse.de>; Wed,  6 Jul 2011 23:03:47 +0200 (CEST)
Received: from iolanthe.rowland.org (iolanthe.rowland.org [192.131.102.54])
	by mx2.suse.de (Postfix) with SMTP id A86F58B2F9
	for <gregkh@suse.de>; Wed,  6 Jul 2011 23:03:46 +0200 (CEST)
Received: (qmail 6472 invoked by uid 2102); 6 Jul 2011 17:03:45 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 6 Jul 2011 17:03:45 -0400
Date: Wed, 6 Jul 2011 17:03:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@suse.de>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
	=?iso-8859-1?Q?=C9ric?= Piel <E.A.B.Piel@tudelft.nl>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] USB: additional regression fix for device removal
In-Reply-To: <20110706204647.GC1460@suse.de>
Message-ID: <Pine.LNX.4.44L0.1107061658180.1995-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Virus-Scanned: by amavisd-new at localhost
X-Spam-Status: No, score=0.001 tagged_above=-20 required=5
 tests=[BAYES_50=0.001]
X-Spam-Score: 0.001
X-Spam-Level: 
Status: RO
Content-Length: 2323

Commit e534c5b831c8b8e9f5edee5c8a37753c808b80dc (USB: fix regression
occurring during device removal) didn't go far enough.  It failed to
take into account that when a driver claims multiple interfaces, it may
release them all at the same time.  As a result, some interfaces can
get released before they are unregistered, and we deadlock trying to
acquire the bandwidth_mutex that we already own.

This patch (asl478) handles this case by setting the "unregistering"
flag on all the interfaces before removing any of them.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@kernel.org>

---

This should take care of Eric's problem as well as Arkadiusz, since 
they seemed to be hitting the same thing (cdc_ether claiming multiple 
interfaces and hanging while releasing them).

Still, we need to rewrite this stuff.  A possible race remains, because 
a driver may try to change an altsetting at the same time as the device 
is removed.  Either the driver's disconnect routine would hang waiting 
for the altsetting change (which is waiting to acquire the 
bandwidth_mutex) or else the altsetting change would go through after 
the driver was unbound from the device.  Neither alternative is good.

Alan Stern



 drivers/usb/core/message.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: usb-3.0/drivers/usb/core/message.c
===================================================================
--- usb-3.0.orig/drivers/usb/core/message.c
+++ usb-3.0/drivers/usb/core/message.c
@@ -1147,6 +1147,14 @@ void usb_disable_device(struct usb_devic
 	 * any drivers bound to them (a key side effect)
 	 */
 	if (dev->actconfig) {
+		/*
+		 * FIXME: In order to avoid self-deadlock involving the
+		 * bandwidth_mutex, we have to mark all the interfaces
+		 * before unregistering any of them.
+		 */
+		for (i = 0; i < dev->actconfig->desc.bNumInterfaces; i++)
+			dev->actconfig->interface[i]->unregistering = 1;
+
 		for (i = 0; i < dev->actconfig->desc.bNumInterfaces; i++) {
 			struct usb_interface	*interface;
 
@@ -1156,7 +1164,6 @@ void usb_disable_device(struct usb_devic
 				continue;
 			dev_dbg(&dev->dev, "unregistering interface %s\n",
 				dev_name(&interface->dev));
-			interface->unregistering = 1;
 			remove_intf_ep_devs(interface);
 			device_del(&interface->dev);
 		}


--45Z9DzgjV8m4Oswq--
