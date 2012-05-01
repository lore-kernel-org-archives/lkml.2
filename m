Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2EAT1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:27:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37749 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2EAT1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:27:39 -0400
Date: Tue, 1 May 2012 20:27:36 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-bluetooth@vger.kernel.org
Subject: Re: [now bisected] Weird bluetooth keyboard regression - just me?
Message-ID: <20120501192736.GA29770@srcf.ucam.org>
References: <20120501073711.028d31d6@lwn.net>
 <20120501110156.2b6e0561@lwn.net>
 <20120501171901.GA26006@srcf.ucam.org>
 <20120501120145.21f65ae2@lwn.net>
 <20120501183149.GA28536@srcf.ucam.org>
 <20120501123923.01ac1138@lwn.net>
 <20120501185455.GA29060@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20120501185455.GA29060@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

What does removable in the parent device say? In either case, does the 
attached file help if dropped into /lib/udev/rules.d ?

-- 
Matthew Garrett | mjg59@srcf.ucam.org

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="42-usb-hid-pm.rules"

#
# Enable autosuspend for qemu emulated usb hid devices.
#
# Note that there are buggy qemu versions which advertise remote
# wakeup support but don't actually implement it correctly.  This
# is the reason why we need a match for the serial number here.
# The serial number "42" is used to tag the implementations where
# remote wakeup is working.
#

ACTION=="add", SUBSYSTEM=="usb", ATTR{product}=="QEMU USB Mouse", ATTR{serial}=="42", TEST=="power/control", ATTR{power/control}="auto"
ACTION=="add", SUBSYSTEM=="usb", ATTR{product}=="QEMU USB Tablet", ATTR{serial}=="42", TEST=="power/control", ATTR{power/control}="auto"
ACTION=="add", SUBSYSTEM=="usb", ATTR{product}=="QEMU USB Keyboard", ATTR{serial}=="42", TEST=="power/control", ATTR{power/control}="auto"

#
# Enable autosuspend for KVM and iLO usb hid devices. These are
# effectively self-powered (despite what some claim in their USB
# profiles) and so it's safe to do so.
#

# AMI 046b:ff10
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046b", ATTR{idProduct}=="ff10", TEST=="power/control", ATTR{power/control}="auto"

#
# Catch-all for Avocent HID devices. Keyed off interface in order to only
# trigger on HID class devices.
#
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0624", ATTR{bInterfaceClass}=="03", TEST=="../power/control", ATTR{../power/control}="auto"

# Dell DRAC 4
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="413c", ATTR{idProduct}=="2500", TEST=="power/control", ATTR{power/control}="auto"

# Dell DRAC 5
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="413c", ATTR{idProduct}=="0000", TEST=="power/control", ATTR{power/control}="auto"

# Hewlett Packard iLO
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="03f0", ATTR{idProduct}=="7029", TEST=="power/control", ATTR{power/control}="auto"
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="03f0", ATTR{idProduct}=="1027", TEST=="power/control", ATTR{power/control}="auto"

# IBM remote access
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04b3", ATTR{idProduct}=="4001", TEST=="power/control", ATTR{power/control}="auto"
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04b3", ATTR{idProduct}=="4002", TEST=="power/control", ATTR{power/control}="auto"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="04b3", ATTR{idProduct}=="4012", TEST=="power/control", ATTR{power/control}="auto"

# Raritan Computer, Inc KVM.
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="14dd", ATTR{idProduct}="0002", TEST=="power/control", ATTR{power/control}="auto"

# USB HID devices that are internal to the machine should also be safe to autosuspend

ACTION=="add", SUBSYSTEM=="usb", SUBSYSTEMS=="usb", ATTRS{removable}=="removable", GOTO "usb_hid_pm_end"
ACTION=="add", SUBSYSTEM=="usb", SUBSYSTEMS=="usb", ATTRS{removable}=="unknown", GOTO "usb_hid_pm_end"

ACTION=="add", SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="03", ATTRS{removable}=="fixed", TEST=="../power/control", ATTR{../power/control}="auto"

LABEL="usb_hid_pm_end"

--gKMricLos+KVdGMg--
