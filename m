Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab1DMKYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:24:04 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:27731 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab1DMKYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:24:03 -0400
X-IronPort-AV: E=Sophos;i="4.64,203,1301875200"; 
   d="scan'208";a="5280547"
Date: Wed, 13 Apr 2011 11:24:23 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 3/4] xen: more debugging in the e820 parsing
In-Reply-To: <20110412163957.GA1067@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1104131118180.22672@kaball-desktop>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop> <1302607192-21355-3-git-send-email-stefano.stabellini@eu.citrix.com> <20110412163957.GA1067@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 12, 2011 at 12:19:51PM +0100, stefano.stabellini@eu.citrix.com wrote:
> > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> I am not entirely sure if we need these. You get all of this data by looking
> at the Xen E820 and the guest E820 (to see the xen_extra_mem):
> 
> (XEN) Xen-e820 RAM map:
> (XEN)  0000000000000000 - 000000000009f800 (usable)
> (XEN)  000000000009f800 - 00000000000a0000 (reserved)
> (XEN)  00000000000f0000 - 0000000000100000 (reserved)
> (XEN)  0000000000100000 - 00000000cf5e0000 (usable)
> (XEN)  00000000cf5e0000 - 00000000cf5e3000 (ACPI NVS)
> (XEN)  00000000cf5e3000 - 00000000cf5f0000 (ACPI data)
> (XEN)  00000000cf5f0000 - 00000000cf600000 (reserved)
> (XEN)  00000000e0000000 - 00000000f0000000 (reserved)
> (XEN)  00000000fec00000 - 0000000100000000 (reserved)
> (XEN)  0000000100000000 - 0000000130000000 (usable)
> ..
> 
> [    0.000000] BIOS-provided physical RAM map:
> .. snip..
> [    0.000000]  Xen: 0000000100000000 - 00000001a19e0000 (usable)
> 
> And your patch adds this:
> 
> [    0.000000] e820_region: type=1 start=0000000000000000 end=000000000009f800
> [    0.000000] e820_region: type=2 start=000000000009f800 end=00000000000a0000
> [    0.000000] e820_region: type=2 start=00000000000f0000 end=0000000000100000
> [    0.000000] e820_region: type=1 start=0000000000100000 end=00000000cf5e0000
> [    0.000000] e820_region: type=4 start=00000000cf5e0000 end=00000000cf5e3000
> [    0.000000] e820_region: type=3 start=00000000cf5e3000 end=00000000cf5f0000
> [    0.000000] e820_region: type=2 start=00000000cf5f0000 end=00000000cf600000
> [    0.000000] e820_region: type=2 start=00000000e0000000 end=00000000f0000000
> [    0.000000] e820_region: type=2 start=00000000fec00000 end=0000000100000000
> [    0.000000] e820_region: type=1 start=0000000100000000 end=0000000130000000
> [    0.000000] released 0 pages of unused memory
> [    0.000000] extra e820 region: start=0000000100000000 end=00000001a19e0000

I have a machine here in which the e820 printed by Xen and the e820
in dom0 *before* any modifications differs:

(XEN) Xen-e820 RAM map:
(XEN)  0000000000000000 - 000000000009fc00 (usable)
(XEN)  000000000009fc00 - 00000000000a0000 (reserved)
(XEN)  00000000000e0000 - 0000000000100000 (reserved)
(XEN)  0000000000100000 - 00000000beb96000 (usable)
(XEN)  00000000beb96000 - 00000000bed97000 (ACPI NVS)
(XEN)  00000000bed97000 - 00000000bf651000 (usable)
(XEN)  00000000bf651000 - 00000000bf6e9000 (ACPI NVS)
(XEN)  00000000bf6e9000 - 00000000bf6ec000 (usable)
(XEN)  00000000bf6ec000 - 00000000bf6ff000 (ACPI data)
(XEN)  00000000bf6ff000 - 00000000bf700000 (usable)

[    0.000000] e820_region: type=1 start=0000000000000000 end=000000000009fc00
[    0.000000] e820_region: type=2 start=000000000009fc00 end=00000000000a0000
[    0.000000] e820_region: type=2 start=00000000000e0000 end=0000000000100000
[    0.000000] e820_region: type=1 start=0000000000100000 end=00000000beb96000
[    0.000000] e820_region: type=4 start=00000000beb96000 end=00000000bed97000
[    0.000000] e820_region: type=1 start=00000000bed97000 end=00000000bf651000
[    0.000000] e820_region: type=4 start=00000000bf651000 end=00000000bf6e9000
[    0.000000] e820_region: type=1 start=00000000bf6e9000 end=00000000bf6ec000
[    0.000000] e820_region: type=3 start=00000000bf6ec000 end=00000000bf6ff000
[    0.000000] e820_region: type=1 start=00000000bf6ff000 end=00000000bf700000
[    0.000000] e820_region: type=2 start=00000000fec00000 end=00000000fec01000
[    0.000000] e820_region: type=2 start=00000000fee00000 end=00000000fee01000
