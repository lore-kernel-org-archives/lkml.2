Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776Ab2EXUs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:48:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41429 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757859Ab2EXUs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:48:27 -0400
Date: Thu, 24 May 2012 16:48:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Josh Boyer <jwboyer@redhat.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: USB device PM oddity in 3.5
In-Reply-To: <20120524203655.GK1143@zod.bos.redhat.com>
Message-ID: <Pine.LNX.4.44L0.1205241646080.1186-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012, Josh Boyer wrote:

> I'm testing Linus' tree as the merge window happens, and I've hit an
> issue with what I believe is USB device power management (or something)
> that is causing my mouse and keyboard to become unresponsive.  After a
> very short time of non-use, either device will cut out.  I can move the
> mouse around but it doesn't relay to the screen and I noticed this is
> because the laser is turned off.  If I click a button on it, it will
> turn back on and function again until a small period of non-use.  The
> keyboard exhibits similar behavior, "ignoring" the first few key strokes
> until it wakes back up.
> 
> I found this thread:
> 
> http://thread.gmane.org/gmane.linux.usb.general/64292
> and
> http://marc.info/?t=133552726500001&r=1&w=2
> 
> which have similar symptoms, but the kernels I'm using have the
> subsequent patches applied.  I'm doing a git bisect at the moment, with
> 72c04af as the starting good commit and 61011677 as the first bad.  I'll
> let you know what comes of this, but I thought I'd mail about it now in
> case anyone has any ideas.

It sounds like you have autosuspend enabled on the mouse and keyboard, 
and they don't work very well with it.  Setting the sysfs power/control 
attributes for the two devices to "on" will prevent autosuspend.

I don't know why this would have started happening after a kernel 
upgrade.  Those settings are normally controlled by userspace apps.  
Let us know what you find.

Alan Stern

