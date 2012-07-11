Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab2GKGLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:11:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab2GKGLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:11:18 -0400
Date: Wed, 11 Jul 2012 08:11:14 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: Frederik Himpe <fhimpe@telenet.be>, USB list <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Logitech HD Webcam C525 does not work when connected to USB 2
 port, works on USB 3
Message-ID: <20120711061114.GA1596@fancy-poultry.org>
References: <1341516932.4164.10.camel@piranha.localdomain>
 <Pine.LNX.4.44L0.1207051712170.13212-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1207051712170.13212-100000@netrider.rowland.org>
Organization: private site
OpenPGP: id=898F89DE; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+59 (8fabaffc2c00) (2011-07-01)
X-Provags-ID: V02:K0:pwvaNYRb3eTAG9xnBz3Uh65UxPRTGAOfDL0k/+vQLMs
 fhd8louN6nz88WteSufMVLQJ+cTyrYmn6AlUoWyo3FcYbMga6l
 rm4L39nLN4dw/Xqv3NxZDj7qc7SezSezZUu1xb8egCFnReDAVz
 CqCoSI4nfPrxE1ImsFA0wmai//FHmhBcl2tT9x6CiqdNNH6wig
 /iz5DYBfNAhzg0jdNXinXFt7eKz5xVGKLYL75PmZkWWtU8Qd60
 wetsxdVNFN976r2Tbe3FNJoM+8hkJ7ISUK2TMkVoNIKRJ6s6hv
 5wUUireP+zg+KwhElh+OjrkBBjw36XvGyF+tWyuEUpIvCpbaWc
 r5zhaPb0Jwb5FX0JbiuaP3ScFhdlFuGKmbq3fhGC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have exactly the same webcam, lsusb says "Bus 002 Device 004: ID
046d:0826 Logitech, Inc."...

On 06.07.2012, Alan Stern wrote: 

> On Thu, 5 Jul 2012, Frederik Himpe wrote:

> > I tried setting to on again, and then this appears in the logs:
> > Jul  5 21:21:59 piranha kernel: [ 9788.223118] usb 1-1.2: USB disconnect, device number 6
> > Jul  5 21:22:00 piranha kernel: [ 9788.330415] usb 1-1.2: new full-speed USB device number 7 using ehci_hcd
> > Jul  5 21:22:00 piranha kernel: [ 9788.402207] usb 1-1.2: device descriptor read/64, error -32
> > Jul  5 21:22:00 piranha kernel: [ 9788.577706] usb 1-1.2: device descriptor read/64, error -32
> > Jul  5 21:22:00 piranha kernel: [ 9788.753203] usb 1-1.2: new full-speed USB device number 8 using ehci_hcd
> > Jul  5 21:22:00 piranha kernel: [ 9788.824996] usb 1-1.2: device descriptor read/64, error -32
> > Jul  5 21:22:00 piranha kernel: [ 9789.000493] usb 1-1.2: device descriptor read/64, error -32
[....]

...and I do not have these messages at all, with or without
autosuspend enabled...
 
> In the long run, it may be necessary to add a quirk entry to always
> use a reset-resume with this device.  You can find similar entries in 
> drivers/usb/core/quirks.c for other Logitech webcams, which makes it 
> seem very likely that one is needed for yours.  If you want you 
> can try adding the appropriate entry and submit it as a patch.

...and it runs fine with or without the quirk, which I added for
testing purposes. 

> None of this explains why there isn't any problem when the webcam is 
> plugged into a USB-3 port, unfortunately.

All this is purely on USB-2, my machine doesn't have any USB-3 port,
with vanilla 3.4.4 kernel. If nobody did, should I submit a patch 
containing the quirk anyway?

If I can help testing, feel free to contact me.



