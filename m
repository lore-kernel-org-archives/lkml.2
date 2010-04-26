Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0DZTeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:34:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38265 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751306Ab0DZTeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:34:23 -0400
Date: Mon, 26 Apr 2010 15:34:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?ISO-8859-1?Q?Micha=C5=82_Nazarewicz?= <m.nazarewicz@samsung.com>
cc: Josua Dietze <digidietze@draisberghof.de>, Daniel Mack <daniel@caiaq.de>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: USB gadget with drivers "on board"
In-Reply-To: <4BD5CF3C.9020406@draisberghof.de>
Message-ID: <Pine.LNX.4.44L0.1004261531480.1764-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010, Josua Dietze wrote:

> Michał Nazarewicz schrieb:
> 
> > On Mon, 26 Apr 2010 16:16:05 +0200, Daniel Mack <daniel@caiaq.de> wrote:
> >> Are you sure they don't do exactly that by running two interfaces in
> >> the same configuration?
> > 
> > Yes, I'm sure.  I've investigated an USB GSM modem which, when plugged
> > for the first time reports as mass storage (single configuration, single
> > interface) and when drivers are installed as a full blown composite
> > gadget.  I still haven't figured out how it does that.
> 
> 
> These are the notorious mode switching devices. In Windows, they 
> obviously install a special storage driver doing one specific action 
> on each following plugging.
> This action - some storage or control command - will "flip" the 
> device, making it "disconnect" and returning as a completely different 
> composite device.
> 
> Storage commands used for this procedure range from "SCSI rezero" over 
> "passthrough" to "SCSI eject", or involve vendor specific stuff.

I was going to say the same thing.  For ease of use, I recommend using
a "SCSI eject" to trigger the mode change.  That way, Linux users who
don't have the usb-modeswitch program installed can get the same effect
by running eject.

Alan Stern

