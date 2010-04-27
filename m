Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab0D0TVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:21:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57791 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756640Ab0D0TVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:21:23 -0400
Date: Tue, 27 Apr 2010 15:21:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-pm@lists.linux-foundation.org, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] [RFC] ehci: Disable wake on overcurrent (WKOC_E) and
 disconnect (WKDISC_E)
In-Reply-To: <201004271825.21771.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.1004271509450.1850-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010, Ondrej Zary wrote:

> The previous patch was not enough as it worked only when there were no USB
> devices connected. With a bus-powered device connected, power loss causes
> disconnect which wakes up the machine immediately again.

You said earlier that the host controller was disabled for remote
wakeup ("/sys/devices/pci0000:00/0000:00:1d.7/power/wakeup is disabled
by default").  So even though the root hub might issue a wakeup
request, the controller hardware should not forward that request to the
PCI bus and it should not cause the system to wake up.

> Does anyone know why is this enabled by default?

Why _what_ is enabled?  Detection of disconnects?  Because otherwise 
your computer wouldn't realize anything had happened when a suspended 
USB device was unplugged from a suspended root hub.

> No other USB host driver
> (except oxu210hp-hcd which is based on EHCI) does that.

Look again -- they all do.  (All the HCDs that support suspend/resume, 
anyway.)

> This also means that
> suspended laptop wakes up when disconnecting a mouse?

No, for the reason I described above.  The controller is aware of the 
wakeup request but doesn't generate a PME# event.  Likewise for desktop 
systems.

> I don't have any to test
> right now. Wakeup on USB connect makes a bit more sense but I'd say that it's
> still not a good idea to enable it by default.
> 
> If we don't need that, perhaps the following patch should be applied.
> 
> 
> Disable wake on overcurrent and disconnect in EHCI.
> This fixes immediate resume from standby on boards where port power is lost
> in standby which triggers overcurrent detection and disconnect if a
> bus-powered device is connected. At least Asus P4P800 boards are affected when
> any of the USBPWxx (e.g. USBPW12) jumpers is set to 5V.

Why would you want to change the jumper settings?  Host controllers are 
_supposed_ to supply 5V power during system suspend.

Alan Stern

