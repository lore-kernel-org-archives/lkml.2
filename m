Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab0JLNze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:55:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60994 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932529Ab0JLNzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:55:32 -0400
Date: Tue, 12 Oct 2010 09:55:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Brokhman Tatyana <tlinder@codeaurora.org>
cc: linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 2/2] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <3bcbaf2980892d18960a399f235fd993.squirrel@www.codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1010120953070.1705-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010, Brokhman Tatyana wrote:

> Hi Alan
> 
> Thanks you for your comments. Please see my reply inline.

> > In addition, I suspect the dummy_hcd driver structure shouldn't contain
> > an address_device entry.  It should be present only in dummy_ss_hcd.
> 
> I'm not sure I follow...
> According to the code and comments in hub.c address_device cb is used if
> the host controller wishes to choose the device address itself instead of
> the address chosen by the core.

Correct.

>  It seems to me that there is nothing
> preventing the dummy_hcd from supplying such cb as well. Is there?
> Having both HS and SS dummy_hcd determine the device address seems more
> convenient for testing proposes.

For testing purposes, it is best to imitate the behavior of a real 
device as closely as possible.  USB-2.0 host controllers do not assign 
their own addresses to devices; they use the addresses provided by 
usbcore.  I think this is also true for the low/full/high-speed 
components of a USB-3.0 controller.

Alan Stern

