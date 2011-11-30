Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab1K3Ovk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:51:40 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44499 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab1K3Ovi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:51:38 -0500
Subject: Re: [Xen-devel] [ANNOUNCE] Xen port to Cortex-A15 / ARMv7 with
 virt extensions
From: Pawel Moll <pawel.moll@arm.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "android-virt@lists.cs.columbia.edu" 
	<android-virt@lists.cs.columbia.edu>,
        "embeddedxen-devel@lists.sourceforge.net" 
	<embeddedxen-devel@lists.sourceforge.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <201111301432.54463.arnd@arndb.de>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop>
	 <201111301303.23851.arnd@arndb.de>
	 <1322659535.31810.97.camel@zakaz.uk.xensource.com>
	 <201111301432.54463.arnd@arndb.de>
Date: Wed, 30 Nov 2011 14:51:28 +0000
Message-ID: <1322664688.3180.6.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 30 Nov 2011 14:51:28.0933 (UTC) FILETIME=[8AA6F550:01CCAF6F]
X-MC-Unique: 111113014513206201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 14:32 +0000, Arnd Bergmann wrote:
> I don't care much either way, but I think it would be good to
> use similar solutions across all hypervisors. The two options
> that I've seen discussed for KVM were to use either a virtual PCI
> bus with individual virtio-pci devices as on the PC, or to
> use the new virtio-mmio driver and individually put virtio devices
> into the device tree.

Let me just add that the virtio-mmio devices can already be instantiated
from DT (see Documentation/devicetree/bindings/virtio/mmio.txt).

For A9-based VE I'd suggest placing them around 0x1001e000, eg.:

        virtio_block@1001e000 {
                compatible = "virtio,mmio";
                reg = <0x1001e000 0x100>;
                interrupts = <41>;
        }

Cheers!

Paweł


