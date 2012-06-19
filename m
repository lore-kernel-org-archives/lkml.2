Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab2FSS3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:29:34 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:35135 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2FSS3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:29:33 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiBRAJfE4E9V5qg+PGdsb2JhbABFihKrVxkBAQEBNzSCGAEBBAE6HBESBQsIAw44FCUKGogZCblkFJBUYAOVJIVkjHw
X-IronPort-AV: E=Sophos;i="4.77,438,1336341600"; 
   d="scan'208";a="138435647"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 19 Jun 2012 20:31:53 +0200
To: Jan Beulich <JBeulich@suse.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: hid-generic regression on existing distros
Message-ID: <20120619183153.GA2429@polaris.bitmath.org>
References: <4FE09A3A020000780008A9D0@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE09A3A020000780008A9D0@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

> commit 8215d557e5f3a70e50e07c857d35c250fee62a73 results
> in no keyboard or mouse during early boot on systems where
> those are USB-based and HID=m, since nothing there can
> possibly be aware that this new driver needs to be manually
> loaded for e.g. interactive startup mode to be useful, as it would
> have to make it into initrd, yet the mkinitrd machinery can't
> reasonably know of it.

This is obviously distro-specific, since there are ramdisk programs
which make use of udev (mkinitcpio, for one).  The mkinitrd machinery
cannot reasonably know about HID either, and some distributions use
HID=y, which creates its own set of problems. Either way, your
question really boils down to whether module name changes and the
like, which affect manual initrd setups, are considered user-space
breakage or not. I will leave that question to Jiri.

> Imo, with the functionality having been previously provided
> by usbhid.ko, that module should cause hid-generic to be
> pulled in automatically.

The split was made especially to avoid this. The "hid" module used to
contain both the bus driver and the generic hid driver. It is now only
a bus driver, and the rest of the hid drivers optionally (and
automatically, using udev) hook on to that bus. Saying that all hid
devices carried over usb must load a certain driver is the same as
saying that all pci-based devices must be handled be the same
driver. Convenient, perhaps, but not very practical.

> (Also, just as a side note, a Kconfig default of 'y' is pointless
> for a tristate option that depends on another tristate one,
> when that one was already set to 'm' - the default really
> should be the value of the depended upon symbol.)

Thanks, overall the Kconfig seems to need updating. I will look into it.

Henrik
