Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab2IUSOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:14:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51288 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab2IUSOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:14:50 -0400
Date: Fri, 21 Sep 2012 14:14:47 -0400 (EDT)
Message-Id: <20120921.141447.1146043198575242769.davem@davemloft.net>
To: jon.mason@intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, dave.jiang@intel.com,
        nab@risingtidesystems.com
Subject: Re: [RFC v3 1/2] PCI-Express Non-Transparent Bridge Support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348250989-6962-2-git-send-email-jon.mason@intel.com>
References: <1348250989-6962-1-git-send-email-jon.mason@intel.com>
	<1348250989-6962-2-git-send-email-jon.mason@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Mason <jon.mason@intel.com>
Date: Fri, 21 Sep 2012 11:09:48 -0700

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

I really don't see anything that requires the TX networking processing
to occur in a tasklet.  I see no sleeping, strange locking, or
anything like that.

And if that's the case, it's just pure overhead.
