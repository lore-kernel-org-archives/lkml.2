Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1DMRy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:54:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44458 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1DMRyY (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 13 Apr 2011 13:54:24 -0400
Date: Wed, 13 Apr 2011 13:54:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 3/4] xen: more debugging in the e820 parsing
Message-ID: <20110413175404.GA19390@dumpdata.com>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop>
 <1302607192-21355-3-git-send-email-stefano.stabellini@eu.citrix.com>
 <20110412163957.GA1067@dumpdata.com>
 <alpine.DEB.2.00.1104131118180.22672@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104131118180.22672@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DA5E341.0078:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have a machine here in which the e820 printed by Xen and the e820
> in dom0 *before* any modifications differs:
> 
> (XEN) Xen-e820 RAM map:
> (XEN)  0000000000000000 - 000000000009fc00 (usable)
> (XEN)  000000000009fc00 - 00000000000a0000 (reserved)
> (XEN)  00000000000e0000 - 0000000000100000 (reserved)
> (XEN)  0000000000100000 - 00000000beb96000 (usable)
> (XEN)  00000000beb96000 - 00000000bed97000 (ACPI NVS)
> (XEN)  00000000bed97000 - 00000000bf651000 (usable)
> (XEN)  00000000bf651000 - 00000000bf6e9000 (ACPI NVS)
> (XEN)  00000000bf6e9000 - 00000000bf6ec000 (usable)
> (XEN)  00000000bf6ec000 - 00000000bf6ff000 (ACPI data)
> (XEN)  00000000bf6ff000 - 00000000bf700000 (usable)
> 
> [    0.000000] e820_region: type=1 start=0000000000000000 end=000000000009fc00
> [    0.000000] e820_region: type=2 start=000000000009fc00 end=00000000000a0000
> [    0.000000] e820_region: type=2 start=00000000000e0000 end=0000000000100000
> [    0.000000] e820_region: type=1 start=0000000000100000 end=00000000beb96000
> [    0.000000] e820_region: type=4 start=00000000beb96000 end=00000000bed97000
> [    0.000000] e820_region: type=1 start=00000000bed97000 end=00000000bf651000
> [    0.000000] e820_region: type=4 start=00000000bf651000 end=00000000bf6e9000
> [    0.000000] e820_region: type=1 start=00000000bf6e9000 end=00000000bf6ec000
> [    0.000000] e820_region: type=3 start=00000000bf6ec000 end=00000000bf6ff000
> [    0.000000] e820_region: type=1 start=00000000bf6ff000 end=00000000bf700000


> [    0.000000] e820_region: type=2 start=00000000fec00000 end=00000000fec01000
> [    0.000000] e820_region: type=2 start=00000000fee00000 end=00000000fee01000

Ah, so the IOAPIC regions don't show up in the E820. Do they show up in the
E820 printed by the Linux kernel? If I use the Xen E820 output and what the
guest prints for its E820 I seem to get even this "hidden" area.
