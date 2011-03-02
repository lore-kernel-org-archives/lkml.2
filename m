Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab1CBEvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 23:51:43 -0500
Received: from mail4.comsite.net ([205.238.176.238]:15421 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959Ab1CBEvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 23:51:42 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=127.0.0.1;
From: "miltonm" <miltonm@bga.com>
Reply-to: miltonm@bga.com
To: Ben Hutchings <ben@decadent.org.uk>, Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Milton Miller <miltonm@bga.com>,
        "David S. Miller" <davem@davemloft.net>,
        Anton Blanchard <anton@samba.org>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [Stable-review] [22/68] ixgbe: prevent speculative processing of descriptors before ready
X-Mailer: Quality Web Email v3.1t
X-Originating-IP: 71.22.127.106
Date: Tue, 01 Mar 2011 22:51:17 -0600
Message-id: <4d6dccc5.3c4.4db0.1082106294@bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
X-Authenticated-User: miltonm@bga.com 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message Follows -----
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Don
Skidmore <donald.c.skidmore@intel.com>, Milton Miller
<miltonm@bga.com>, "David S. Miller" <davem@davemloft.net>,
Anton Blanchard <anton@samba.org>,
akpm@linux-foundation.org,  torvalds@linux-foundation.org,
stable-review@kernel.org,  alan@lxorguk.ukuu.org.uk, Jeff
Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [Stable-review] [22/68] ixgbe: prevent
speculative processing of descriptors before ready
Date: Tue, 01 Mar 2011 02:14:33 +0000

> On Mon, 2011-02-28 at 08:22 -0800, Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any
> > objections, please let us know. 
> > ------------------
> > 
> > From: Milton Miller <miltonm@bga.com>
> > 
> > commit 3c945e5b3719bcc18c6ddd31bbcae8ef94f3d19a
> > upstream. 
> > The PowerPC architecture does not require loads to
> > independent bytes to be ordered without adding an
> > explicit barrier. 
> > In ixgbe_clean_rx_irq we load the status bit then load
> > the packet data. With packet split disabled if these
> > loads go out of order we get a stale packet, but we will
> > notice the bad sequence numbers and drop it. 
> > The problem occurs with packet split enabled where the
> > TCP/IP header and data are in different descriptors. If
> > the reads go out of order we may have data that doesn't
> match the TCP/IP header. Since we use hardware
> > checksumming this bad data is never verified and it
> makes it all the way to the application. [...]
> 
> Packet splitting should be completely disabled on the
> 82599, anyway. Greg, what happened to this patch:

This was initially observed on 82598 and is still needed
there.

milton
