Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593Ab0HLL4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 07:56:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:50142 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759898Ab0HLL4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 07:56:00 -0400
Date: Thu, 12 Aug 2010 13:55:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Heinz Diehl <htd@fritha.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Alan Ott <alan@signal11.us>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being
 called
In-Reply-To: <20100812113624.GB1591@arch.tripp.de>
Message-ID: <alpine.LNX.2.00.1008121354180.2702@pobox.suse.cz>
References: <20100810210941.GA7938@fritha.org> <20100810223215.GA1609@arch.tripp.de> <alpine.LNX.2.00.1008121108540.2702@pobox.suse.cz> <20100812091659.GA1591@arch.tripp.de> <alpine.LNX.2.00.1008121148100.2702@pobox.suse.cz>
 <20100812113624.GB1591@arch.tripp.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010, Markus Trippelsdorf wrote:

> > > > Guys, could you please send me your .config with which you are 
> > > > experiencing the problem, so that I can try to reproduce it with it?
> > > 
> > > Attached.
> > 
> > So I had to add support for HW of mine (SATA_VIA, PATA_VIA, disabled the 
> > radeon firmware stuff, and, most importantly, enabled UHCI, which is what 
> > is on machine I am using now for testing), and disconnect-connect cycle 
> > works nicely:
> > 
> > usb 3-2: USB disconnect, address 3
> > usb 3-2: new low speed USB device using uhci_hcd and address 4
> > input: mouse USB mouse with wheel as /devices/pci0000:00/0000:00:10.1/usb3/3-2/3-2:1.0/input/input6
> > generic-usb 0003:05B8:3091.0004: input,hidraw0: USB HID v1.10 Mouse [mouse USB mouse with wheel] on usb-0000:00:10.1-2/input0
> > input: mouse USB mouse with wheel as /devices/pci0000:00/0000:00:10.1/usb3/3-2/3-2:1.1/input/input7
> > generic-usb 0003:05B8:3091.0005: input,hidraw1: USB HID v1.10 Keyboard [mouse USB mouse with wheel] on usb-0000:00:10.1-2/input1
> > 
> > so still no BUG from kobject refcounting, and the hidraw numbers are the 
> > same. The major difference seems to be that I am using UHCI and you have 
> > your HID devices connected through OHCI, is that correct?
> 
> Correct. And I should add that it very easy to reproduce here; just
> disconnecting the usb receiver triggers the WARNING.

Hmm ... there is a certain interface of the device which doesn't get 
connected to input, right? (0003:046D:C52B.0008).

What happens if you compile without CONFIG_HIDRAW and/or 
CONFIG_USB_HIDDEV?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
