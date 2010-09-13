Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab0IMPR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:17:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56639 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751493Ab0IMPR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:17:56 -0400
Date: Mon, 13 Sep 2010 11:17:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
        <pingc@wacom.com>, linux-pm <linux-pm@lists.linux-foundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>
Subject: Re: [linux-pm] wacom + runtime PM = AA deadlock
In-Reply-To: <201009131656.18199.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.1009131114050.1315-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010, Oliver Neukum wrote:

> PM in this driver looks broken. Please try this.
> 
> In short you want to drop the PM reference and depend on remote
> wakeup and busy marking for this driver. Currently it gets a reference
> on every open() but never drops it.
> 
> For locking you depend on the PM core's internal lock. You simply
> make sure you have a PM reference during open() and close()

Is there any point in resuming the device during close() just in order
to kill the interrupt URB?  It seems counterproductive -- if the device 
had been suspended then there wouldn't be any interrupt URB to kill in 
the first place.

Alan Stern

