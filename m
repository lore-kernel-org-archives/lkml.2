Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab0D1P7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:59:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60602 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755135Ab0D1P7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:59:05 -0400
Date: Wed, 28 Apr 2010 11:59:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
cc: Josua Dietze <digidietze@draisberghof.de>, Daniel Mack <daniel@caiaq.de>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: USB gadget with drivers "on board"
In-Reply-To: <op.vbu6nahq7p4s8u@pikus>
Message-ID: <Pine.LNX.4.44L0.1004281156100.1944-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010, [utf-8] Michał Nazarewicz wrote:

> So it will be enough to change the USB device class for the zeroth
> interface for udev to recognise the mass storage to be ejected?  Note
> that I will use mass storage in the second mode as well.

No, you also have to go through a disconnect-reconnect cycle on the USB 
bus.  When you do, changing the bInterfaceClass value will be 
sufficient to tell the kernel that the device needs to be 
re-enumerated.

> Also, I think that it might be a good idea to make some "standardised"
> mechanism for all such devices so that a generic udev code could be
> written.  Adding things to the descriptors may be difficult in a way,
> but maybe adding "[NoCD]" to the interface name would be enough.

I seriously doubt you'll be able to convince all the other
manufacturers to agree to a standardized convention for this.

Alan Stern

