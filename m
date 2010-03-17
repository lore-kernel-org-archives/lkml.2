Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab0CQPfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:35:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50417 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752471Ab0CQPe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:34:57 -0400
Date: Wed, 17 Mar 2010 11:34:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] V2 usb console improvements series
In-Reply-To: <4BA0EB57.30405@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1003171132560.1734-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010, Jason Wessel wrote:

> On 03/17/2010 09:30 AM, Alan Stern wrote:
> > On Tue, 16 Mar 2010, Jason Wessel wrote:
> >
> >   
> >> Part of having the console stable requires that usb sysrq handler get
> >> executed in a tasklet.  The hcd device lock is always held while the
> >> driver call backs are executed.  The means you cannot get the sysrq
> >> printk's out to the usb console device after the in_flight urb queue
> >> is filled.
> >>     
> >
> > Either I don't understand this comment properly or else it is simply
> > wrong.  HCDs do not continue to hold their locks when handing completed
> > URBs back to drivers.  The giveback call occurs with interrupts
> > disabled, but no locks are held.
> >
> >   
> 
> The call back from the urb processing holds a lock.

Which callback and which lock, exactly?  Surely not the "hcd device
lock" as your description says, and maybe not the "driver call back".

Alan Stern

