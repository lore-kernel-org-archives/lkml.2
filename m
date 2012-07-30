Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab2G3Quh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:50:37 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53174 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781Ab2G3Quf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:50:35 -0400
MIME-Version: 1.0
In-Reply-To: <1343607994-32415-2-git-send-email-jon.mason@intel.com>
References: <1343607994-32415-1-git-send-email-jon.mason@intel.com> <1343607994-32415-2-git-send-email-jon.mason@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 30 Jul 2012 10:50:13 -0600
Message-ID: <CAErSpo4p_hxvCeVGqiTXVq3itXepheQZerpqRHwLvG6A7R2Lcg@mail.gmail.com>
Subject: Re: [RFC v2 1/2] PCI-Express Non-Transparent Bridge Support
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 6:26 PM, Jon Mason <jon.mason@intel.com> wrote:
> A PCI-Express non-transparent bridge (NTB) is a point-to-point PCIe bus
> connecting 2 systems, providing electrical isolation between the two subsystems.
> A non-transparent bridge is functionally similar to a transparent bridge except
> that both sides of the bridge have their own independent address domains.  The
> host on one side of the bridge will not have the visibility of the complete
> memory or I/O space on the other side of the bridge.  To communicate across the
> non-transparent bridge, each NTB endpoint has one (or more) apertures exposed to
> the local system.  Writes to these apertures are mirrored to memory on the
> remote system.  Communications can also occur through the use of doorbell
> registers that initiate interrupts to the alternate domain, and scratch-pad
> registers accessible from both sides.
>
> The NTB device driver is needed to configure these memory windows, doorbell, and
> scratch-pad registers as well as use them in such a way as they can be turned
> into a viable communication channel to the remote system.  ntb_hw.[ch]
> determines the usage model (NTB to NTB or NTB to Root Port) and abstracts away
> the underlying hardware to provide access and a common interface to the doorbell
> registers, scratch pads, and memory windows.  These hardware interfaces are
> exported so that other, non-mainlined kernel drivers can access these.
> ntb_transport.[ch] also uses the exported interfaces in ntb_hw.[ch] to setup a
> communication channel(s) and provide a reliable way of transferring data from
> one side to the other, which it then exports so that "client" drivers can access
> them.  These client drivers are used to provide a standard kernel interface
> (i.e., Ethernet device) to NTB, such that Linux can transfer data from one
> system to the other in a standard way.
>
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> ---
>  MAINTAINERS                 |    6 +
>  drivers/Kconfig             |    2 +
>  drivers/Makefile            |    1 +
>  drivers/ntb/Kconfig         |   13 +
>  drivers/ntb/Makefile        |    3 +
>  drivers/ntb/ntb_hw.c        | 1178 ++++++++++++++++++++++++++++++++++++
>  drivers/ntb/ntb_hw.h        |  206 +++++++
>  drivers/ntb/ntb_regs.h      |  150 +++++
>  drivers/ntb/ntb_transport.c | 1387 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/ntb.h         |   92 +++

Where will drivers for non-Intel NTBs fit in this hierarchy?  It seems
a bit presumptuous to claim the generic "ntb" names just for Intel
devices.
