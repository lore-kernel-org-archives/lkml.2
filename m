Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1KHG0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 01:26:20 -0500
Received: from ozlabs.org ([203.10.76.45]:34704 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab1KHG0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 01:26:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: virtio-pci new configuration proposal
In-Reply-To: <20111107211413.GA11577@redhat.com>
References: <20111104114033.GA21308@redhat.com> <1320409939.3334.6.camel@lappy> <20111104135113.GA24452@redhat.com> <1320414804.3334.13.camel@lappy> <20111104142338.GB24452@redhat.com> <1320418385.3334.25.camel@lappy> <20111106073007.GA7146@redhat.com> <1320611097.3299.10.camel@lappy> <20111106213849.GA14292@redhat.com> <871utktsuw.fsf@rustcorp.com.au> <20111107211413.GA11577@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 08 Nov 2011 10:23:33 +1030
Message-ID: <87aa87sd4y.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011 23:14:14 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, Nov 07, 2011 at 03:46:23PM +1030, Rusty Russell wrote:
> > So far, the only three things make sense to have in a capability list:
> > MSI-X, the upper 32 feature bits, and the per-device config.
> 
> You mean the queue # to MSI-X vector mapping?

Yep.

> One thing to remember is that it must be in the same type of BAR as
> the queue selection, since by PCI rules MMIO writes aren't I think
> ordered with PIO writes (it doesn't matter with KVM but might
> with another hypervisor).

OK, I'm slowly getting up to speed.

Next dumb q: Sasha, why did you introduce the idea of a separate
virtio-pci capability list, rather than just using PCI capabilities
directly?  ie. instead of VIRTIO_PCI_C_LAYOUT, have VIRTIO_PCI_CORE,
VIRTIO_PCI_MSIX, VIRTIO_PCI_DEV_SPECIFIC?

Is it because we really want this stuff outside the PCI configuration
space?  Even so, should we just use the PCI cap list, and have each
cap entry just contain a BIR & offset?

Thanks,
Rusty.

