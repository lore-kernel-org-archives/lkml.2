Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab1FTRfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:35:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53713 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755819Ab1FTRfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:35:36 -0400
Date: Mon, 20 Jun 2011 13:35:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nicolas Pitre <nico@fluxnic.net>
cc: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Alexander Holler <holler@ahsoftware.de>, <linux-usb@vger.kernel.org>,
        <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
 the packed attribute
In-Reply-To: <alpine.LFD.2.00.1106201306210.2142@xanadu.home>
Message-ID: <Pine.LNX.4.44L0.1106201329390.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Nicolas Pitre wrote:

> Are we talking past each other?
> 
> Remember that I was the one asking if the align attribute was needed in 
> the first place.  If it is not then by all means please get rid of it!
> 
> But if it _is_ needed, then the generated code can be much better if the 
> packed attribute is _also_ followed by the align attribute to 
> increase it from 1.

According to Arnd, any remaining possible issues will be addressed by
changing the implementation of readl/writel on ARM.  It doesn't look as
though the ehci files need anything else done.

As far as I can tell, the other structures in ehci.h have 
((aligned(32)) simply in order to save space, since there can be large 
numbers of these structures allocated.  That doesn't apply to the 
structures in ehci_def.h; there will only be one of each.

Alan Stern

