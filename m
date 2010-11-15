Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab0KOPGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:06:52 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59576 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757708Ab0KOPGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:06:50 -0500
Date: Mon, 15 Nov 2010 10:06:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pete Zaitcev <zaitcev@redhat.com>
cc: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] usbmon: correct computing of the ISO packets with
 mmap
In-Reply-To: <20101114231226.16782336@lembas.zaitcev.lan>
Message-ID: <Pine.LNX.4.44L0.1011151002060.1606-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010, Pete Zaitcev wrote:

> On Mon, 15 Nov 2010 06:48:40 +0100
> Németh Márton <nm127@freemail.hu> wrote:
> 
> > ev_type == 'S' && usb_urb_dir_out(urb)  ---> data is available, we'll need it
> 
> The write submission case should be covered by the transfer_buffer_length,
> I think. Is there a driver that only sets the ISO descriptors but not
> the overall length?

If there is, it's a bug.  usb_submit_urb() could check for that sort of 
thing -- although so far nobody has complained of problems, so checking 
doesn't seem necessary.

Other things usb_submit_urb() could check for, but currently doesn't, 
include:

	Make sure the packet offsets are non-decreasing;

	Make sure the packet don't overlap in the buffer;

	Make sure the spacing between two consecutive packets
	in the buffer doesn't exceed some upper limit (needed
	by ehci-hcd).

Alan Stern

