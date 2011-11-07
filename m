Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1KGTze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:55:34 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55210 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751348Ab1KGTzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:55:33 -0500
Date: Mon, 7 Nov 2011 14:55:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tim Vlaar <Tvlaar@ptgrey.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        Markus Rechberger <mrechberger@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: <BADF286A08026E4DAFA9622608E3D8DB063CE25890@rosser.pointgrey.local>
Message-ID: <Pine.LNX.4.44L0.1111071451330.2004-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011, Tim Vlaar wrote:

> Hi Sarah,
> 
> One of our cameras can produce 60MB images.  We usually queue up 10
> images.  In Windows we have had customers queue up 100s of images at
> 2-3MB/image, but not at 60MB at a time ... yet.  That could easily
> amount to 60x10 = 600MB of in flight data or more.  Should there be a
> limit as long as there is memory available?

This is debatable.  There are limits on how much memory a single 
process can allocate, but those limits don't apply to usbfs.  Even the 
patch Sarah referred to doesn't impose a per-process limit, but rather 
an overall global limit.

If we make the usbfs limit adjustable, one of the settings could be "no 
limit".  Then nothing would prevent you from using up more and more 
memory for your USB transfers until the machine runs out.  :-)

Alan Stern

