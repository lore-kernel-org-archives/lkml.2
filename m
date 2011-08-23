Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1HWOh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:37:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50556 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752070Ab1HWOhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:37:24 -0400
Date: Tue, 23 Aug 2011 10:37:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mnazarewicz@google.com>
cc: Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with "max_speed"
In-Reply-To: <op.v0n67imkvgw7ix@mnazarewicz-glaptop>
Message-ID: <Pine.LNX.4.44L0.1108231030270.2069-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, Michal Nazarewicz wrote:

> My understanding was that one could consciously create a composite gadget
> such that not all of the functions support all of the speeds.

That's an important point.  If somebody wants to build a composite 
gadget that includes both midi and storage support, the storage driver 
would be able to go all the way up to SuperSpeed (or rather, it will 
once Felipe's patch is finished and merged) but the midi driver would 
only support full speed.  So what speed should the UDC connect at?

In cases like this there's really no way to know.  Ultimately the best 
approach would be to update the midi driver, but that's a long-term 
sort of thing.

Usually when the kernel can't decide something, it asks the user for 
help (by allowing the user to specify the speed via a module parameter, 
for instance).  In this case even that wouldn't work, because the 
gadget's userspace isn't aware of which functions the host's user will 
want to utilize.

At the moment I don't know the best answer.  This is something we 
should all think about.

Alan Stern

