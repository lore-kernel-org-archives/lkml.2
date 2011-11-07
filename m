Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab1KHG0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 01:26:18 -0500
Received: from ozlabs.org ([203.10.76.45]:37918 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1KHG0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 01:26:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: Re: [PATCH] virtio-pci: fix use after free
In-Reply-To: <20111107163703.GA10358@redhat.com>
References: <20111107163703.GA10358@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 08 Nov 2011 09:42:01 +1030
Message-ID: <87fwhzsf26.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011 18:37:05 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
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

Applied, thanks.  Will push once it's spent a day in linux-next.

Thanks,
Rusty.
