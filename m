Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab1JMAuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:50:24 -0400
Received: from ozlabs.org ([203.10.76.45]:33543 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1JMAuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:50:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Kardashevskiy <aik@ozlabs.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-pci: Use PCI MMIO instead of PIO when available
In-Reply-To: <4E950BDA.2040408@ozlabs.ru>
References: <4E950BDA.2040408@ozlabs.ru>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 13 Oct 2011 10:22:36 +1030
Message-ID: <87r52hepiz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011 14:39:06 +1100, Alexey Kardashevskiy <aik@ozlabs.ru> wrote:
> Currently virtio-pci is specced so that configuration of the device is
> done through a PCI IO space (via BAR 0 of the virtual PCI device).
> However, use of PCI IO space (aka PIO) is long deprecated, and can be
> awkward to use on some systems (for example IBM pSeries machines
> typically have many PCI domains, and not all firmware/hypervisor
> versions necessarily support PCI PIO access on all domains).
> 
> Therefore, it would be preferable for the virtio virtual PCI device to
> advertise a PCI memory space (aka MMIO) BAR and have configuration
> done through this interface instead.  This can be done backwards
> compatibly by advertising the MMIO BAR in addition to the existing PIO
> BAR so that the guest driver can choose whichever interface.
> 
> In anticipation of adding such an MMIO BAR to virtio host-side
> implementations (e.g. qemu), this patch updates the Linux virtio-pci
> driver to attempt to use BAR 2 (which will be MMIO) in preference to
> the existing PIO BAR 0.

Applied.  Had to convert spaces to tabs though...

Thanks,
Rusty.
