Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0INODc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:03:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41190 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753496Ab0INODa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:03:30 -0400
Date: Tue, 14 Sep 2010 10:03:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Jiri Slaby <jslaby@suse.cz>, <phil@ipom.com>, <stable@kernel.org>,
        Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [34-stable regression] USB delay init quirk causes device events
 loss
In-Reply-To: <201009141403.00600.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.1009141001220.1648-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Oliver Neukum wrote:

> Am Montag, 13. September 2010, 17:37:49 schrieb Alan Stern:
> > Okay, I see the problem.  By moving usb_detect_quirks earlier, we end 
> > up calling usb_disable_autosuspend too soon -- before the 
> > pm_runtime_enable call in usb_new_device.  In 2.6.35 this doesn't 
> > matter because the implementation of usb_autosuspend_device has 
> > changed.
> > 
> > So yes, in the end it looks like the best course is to revert this
> > patch from 2.6.34.stable.  This is unfortunate but I don't see any way
> > around it without making changes that aren't present in the current
> > kernel. For example, the pm_runtime_set_active and pm_runtime_enable
> > calls could also be moved from usb_new_device into
> > hub_port_connect_change.
> 
> Calling usb_detect_quirks() twice?

The issue is moot now since Greg has already done the reversion.

But no, usb_detect_quirks should still be called only once.  The idea 
was to make sure this happens _after_ pm_runtime_set_active and 
pm_runtime_enable, by moving those two calls earlier.

Alan Stern

