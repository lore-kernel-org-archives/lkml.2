Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab1KHFq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 00:46:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1KHFqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 00:46:25 -0500
Date: Tue, 8 Nov 2011 11:16:16 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] virtio-pci: fix use after free
Message-ID: <20111108054616.GC2068@amit-x200.redhat.com>
References: <20111107163703.GA10358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107163703.GA10358@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 07 Nov 2011 [18:37:05], Michael S. Tsirkin wrote:
> Commit 31a3ddda166cda86d2b5111e09ba4bda5239fae6 introduced
> a use after free in virtio-pci. The main issue is
> that the release method signals removal of the virtio device,
> while remove signals removal of the pci device.
> 
> For example, on driver removal or hot-unplug,
> virtio_pci_release_dev is called before virtio_pci_remove.
> We then might get a crash as virtio_pci_remove tries to use the
> device freed by virtio_pci_release_dev.
> 
> We allocate/free all resources together with the
> pci device, so we can leave the release method empty.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Amit Shah <amit.shah@redhat.com>

(note: Adding CC: stable@kernel.org to the commit log is the way
patches get automatically pulled from upstream when committed; CC'ing
stable on submissions won't help with that.)

		Amit
