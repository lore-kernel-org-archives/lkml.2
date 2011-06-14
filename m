Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab1FNHeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 03:34:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab1FNHeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 03:34:01 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Unbinding drivers for resources that are in use
Date: Tue, 14 Jun 2011 08:41:11 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc2-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Greg KH <greg@kroah.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
References: <Pine.LNX.4.44L0.1106131048080.1983-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106131048080.1983-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106140841.11631.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 13. Juni 2011, 17:10:57 schrieb Alan Stern:
> Therefore I'm asking if the driver core should add a refcount to every
> struct device for keeping track of the number of open file references
> (or other types of resource) using this device.  If this number is
> nonzero, the kernel should prevent the device from being unbound from
> its driver -- except of course in cases where the device has been
> hot-unplugged; there's nothing we can do to prevent errors when this
> happens.
> 

Firstly, the user may want to unbind a driver for a device that is in use.
 
Secondly, the driver doesn't know in the general case. You've given the best example
yourself. A driver certainly must not know about mounted filesystems. Things
get really hairy if you consider i-scsi and related stuff.

So I'd say it would be major work for an additional feature that doesn't
help in the case that hurts most.

Now, if you are looking for a quick and dirty solution, you could export the
pm counters and provide an ioctl for unbind if zero.

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
