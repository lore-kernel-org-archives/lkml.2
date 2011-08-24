Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab1HXPPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 11:15:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60654 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750934Ab1HXPP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 11:15:29 -0400
Date: Wed, 24 Aug 2011 11:15:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mnazarewicz@google.com>
cc: Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with "max_speed"
In-Reply-To: <op.v0p3n2m9vgw7ix@mnazarewicz-glaptop>
Message-ID: <Pine.LNX.4.44L0.1108241114270.2010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011, Michal Nazarewicz wrote:

> I've found where my reasoning was faulty.  The usb_gadget_driver's
> max_speed is set before all the functions get added so composite.c has
> no way to figure those things in advance.  That's why we need to relay
> on usb_composite_driver's max_speed be set to a proper value.

This is what Felipe was complaining about earlier.  We shouldn't set 
max_speed or allow the UDC to connect to the host until all the 
functions have been added.

Alan Stern

