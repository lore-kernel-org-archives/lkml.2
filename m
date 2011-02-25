Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab1BYRbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:31:09 -0500
Received: from kroah.org ([198.145.64.141]:41452 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932665Ab1BYRbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:31:07 -0500
Date: Fri, 25 Feb 2011 09:29:38 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [GIT PATCH] USB fixes for .38
Message-ID: <20110225172938.GA12448@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes for your .38 tree.

These are almost all XHCI (usb 3.0) fixes, with one MUSB fix, making
this whole patchset just for host controller issues.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

All of these patches have been in the linux-next and mm trees for a
few days.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/hub.c       |   18 +++++++-----------
 drivers/usb/host/xhci-dbg.c  |    9 +++++----
 drivers/usb/host/xhci-mem.c  |   10 +++++-----
 drivers/usb/host/xhci-ring.c |   40 +++++++++++++++++++++++-----------------
 drivers/usb/host/xhci.c      |   14 +++++++-------
 drivers/usb/host/xhci.h      |    2 +-
 drivers/usb/musb/musb_core.c |    1 +
 7 files changed, 49 insertions(+), 45 deletions(-)

---------------

Dmitry Torokhov (3):
      USB: xhci: rework xhci_print_ir_set() to get ir set from xhci itself
      USB: xhci: fix couple sparse annotations
      USB: xhci: mark local functions as static

Felipe Balbi (1):
      usb: musb: core: set has_tt flag

Luben Tuikov (1):
      USB: Reset USB 3.0 devices on (re)discovery

Paul Zimmerman (4):
      xhci: Avoid BUG() in interrupt context
      xhci: Clarify some expressions in the TRB math
      xhci: Fix errors in the running total calculations in the TRB math
      xhci: Fix an error in count_sg_trbs_needed()

