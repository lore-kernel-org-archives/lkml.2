Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab1KNLmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 06:42:22 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:36164
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091Ab1KNLmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 06:42:21 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LUNF6G-01-2DW-02
X-M-MSG: 
Date: Mon, 14 Nov 2011 12:42:13 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: nommu warning message
Message-ID: <20111114114213.GC14704@amd.com>
References: <4EBD65F5.8090808@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EBD65F5.8090808@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 12:14:13PM -0600, Larry Finger wrote:
> For the driver rtl8192cu (a USB wireless device), the current
> version loads the 15KB firmware asynchronously one 32-bit quantity
> at a time. Although inefficient. this method works with USB 1.1 and
> USB 2.0 adapters; however, it fails on at least one USB 3.0 adapter
> with "xhci_hcd 0000:05:00.0: ERROR no room on ep ring" errors.
> 
> These errors are believed to arise from small, fixed-size ep rings.
> There is a vendor driver that works with that same hardware. The
> major difference is that it uses synchronous block writes of 254
> bytes. When I tried this with the in-kernel driver, each block write
> yields a warning as shown below:
> 
> nommu_map_single: overflow 41000340d020+254 of device mask ffffffff

Strange. This means that your system uses the nommu DMA driver. But for
your hardware the GART or SWIOTLB should be used.

Even more strange is the address used for the device. I don't believe is
is correct, otherwise your Laptop would have a very huge amount of RAM
:)

The I think there are two issues here: Why is your system using nommu
and not GART? Can you check that GART and SWIOTLB are enabled in your
kernel config? Second, why is your system using the wrong address? This
looks like some kind of driver bug to mee.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

