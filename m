Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0INMCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 08:02:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:59360 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab0INMC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 08:02:29 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [34-stable regression] USB delay init quirk causes device events loss
Date: Tue, 14 Sep 2010 14:03:00 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, phil@ipom.com, stable@kernel.org,
        Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1009131118180.1315-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009131118180.1315-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009141403.00600.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 13. September 2010, 17:37:49 schrieb Alan Stern:
> Okay, I see the problem.  By moving usb_detect_quirks earlier, we end 
> up calling usb_disable_autosuspend too soon -- before the 
> pm_runtime_enable call in usb_new_device.  In 2.6.35 this doesn't 
> matter because the implementation of usb_autosuspend_device has 
> changed.
> 
> So yes, in the end it looks like the best course is to revert this
> patch from 2.6.34.stable.  This is unfortunate but I don't see any way
> around it without making changes that aren't present in the current
> kernel. For example, the pm_runtime_set_active and pm_runtime_enable
> calls could also be moved from usb_new_device into
> hub_port_connect_change.

Calling usb_detect_quirks() twice?

	Regards
		Oliver
