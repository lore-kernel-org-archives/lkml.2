Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab1JOTEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 15:04:30 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41962 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754462Ab1JOTE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 15:04:29 -0400
Date: Sat, 15 Oct 2011 15:04:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Johannes Stezenbach <js@sig21.net>
cc: Markus Rechberger <mrechberger@gmail.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: <20111014224549.GA22810@sig21.net>
Message-ID: <Pine.LNX.4.44L0.1110151459030.15129-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Oct 2011, Johannes Stezenbach wrote:

> What I meant to say is Markus' statement that the device only
> works at a certain transfer size cannot be true since
> this size is not visible to the device via the USB bus.

That's what I would expect, too.  But did you take a look at the usbmon 
traces Markus acquired?

	http://marc.info/?l=linux-usb&m=131845614819045&w=2

They aren't completely definitive because the communications between
the computer and the device _before_ the bulk transfers started were
different.  However they do clearly show the device working with
24064-byte transfers and not working with 12288+11776-byte transfers.

> If you queue two URBs, one 12288 and 11776 bytes, the device
> does not see any difference to one URB with 24064.  It's just not
> in the USB wire protocol.

You can argue until you're blue in the face.  It won't affect the 
results that Markus got in real life.

>  It would make a difference if the
> device violated the spec and sent 188 byte packets. However, the
> spec says a short packet terminates the transfer.  But I wonder
> if this is really the case?

The device does not send short packets.  If it did, the 24064-byte 
transfers would end early.

Alan Stern

