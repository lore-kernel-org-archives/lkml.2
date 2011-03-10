Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab1CJJDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:03:00 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:19887 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1CJJC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:02:58 -0500
X-IronPort-AV: E=Sophos;i="4.62,295,1297036800"; 
   d="scan'208";a="4714013"
Subject: Re: [Xen-devel] [PATCH 13/14] xen: events: do not workaround
 too-small nr_irqs
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110310054045.GF10574@dumpdata.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
	 <1299692486-28634-13-git-send-email-ian.campbell@citrix.com>
	 <20110310054045.GF10574@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 10 Mar 2011 09:02:56 +0000
Message-ID: <1299747776.17339.740.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 05:40 +0000, Konrad Rzeszutek Wilk wrote:
> On Wed, Mar 09, 2011 at 05:41:25PM +0000, Ian Campbell wrote:
> > This workaround was somewhat useful prior to the introduction of the
> > core irq allocator and 026c9d2d0d75 "xen: events: allocate GSIs and
> > dynamic IRQs from separate IRQ ranges." but should be unnecessary now.
> 
> OK, so you tested this under QEMU with Xen + Dom0? A simple one CPU
> config was what we had trouble with.

Yes, I tested with:
qemu-system-x86_64 -m 256 -vnc 0.0.0.0:1 -k en-gb -serial stdio -boot nc \
	-usb -usbdevice tablet \
	-net nic,vlan=0,macaddr=00:16:3e:3f:73:b6,model=e1000 \
	-net tap,vlan=0,ifname=tapQEMU.0 \
	-hda /dev/VG/debian-HVM-1

Booting a recent Xen hypervisor + this kernel.

The comment should really have been updated to reflect the importance of
e7bcecb7b1d2 rather than 026c9d2d0d75. I'll update to:

        With the introduction of e7bcecb7b1d2 "genirq: Make nr_irqs
        runtime expandable" nr_irqs can grow as necessary to accommodate
        our allocation requests.

Ian.

> > 
> > If nr_irqs turns out to be too small under Xen then we should increase
> > nr_irqs rather than working around the core allocator in this way.
> > 
> > In my configuration NR_IRQS ends up being 2304 with nr_irq_gsi 272
> > which is sufficient.


