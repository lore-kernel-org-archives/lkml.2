Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab2KTNlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:41:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50332 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2KTNlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:41:08 -0500
Date: Tue, 20 Nov 2012 14:41:04 +0100
From: Stefan Hajnoczi <stefanha@gmail.com>
To: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] AER-KVM: Error containment of PCI pass-thru devices
 assigned to KVM guests
Message-ID: <20121120134104.GI27378@stefanha-thinkpad.redhat.com>
References: <F9E001219150CB45BEDC82A650F360C90146F4DA@G4W3208.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F9E001219150CB45BEDC82A650F360C90146F4DA@G4W3208.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 06:31:48AM +0000, Pandarathil, Vijaymohan R wrote:
> Add support for error containment when a PCI pass-thru device assigned to a KVM
> guest encounters an error. This is for PCIe devices/drivers that support AER
> functionality. When the OS is notified of an error in a device either
> through the firmware first approach or through an interrupt handled by the AER
> root port driver, concerned subsystems are notified by invoking callbacks
> registered by these subsystems. The device is also marked as tainted till the
> corresponding driver recovery routines are successful. 
> 
> KVM module registers for a notification of such errors. In the KVM callback
> routine, a global counter is incremented to keep track of the error
> notification. Before each CPU enters guest mode to execute guest code,
> appropriate checks are done to see if the impacted device belongs to the guest
> or not. If the device belongs to the guest, qemu hypervisor for the guest is
> informed and the guest is immediately brought down, thus preventing or
> minimizing chances of any bad data being written out by the guest driver
> after the device has encountered an error.

I'm surprised that the hypervisor would shut down the guest when PCIe
AER kicks in for a pass-through device.  Shouldn't we pass the AER event
into the guest and deal with it there?

The equivalent to this policy on physical hardware would be that the CPU
is reset or the machine is powered down on AER.  That doesn't sound
right.

Stefan
