Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab2IEFue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:50:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446Ab2IEFrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:47:11 -0400
Date: Wed, 5 Sep 2012 08:48:30 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Asias He <asias@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-blk: Fix kconfig option
Message-ID: <20120905054830.GB7517@redhat.com>
References: <20120903044133.GA9980@moria.home.lan>
 <87wr0ae26e.fsf@rustcorp.com.au>
 <5046D3A2.3070108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5046D3A2.3070108@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 12:22:58PM +0800, Asias He wrote:
> On 09/04/2012 02:23 PM, Rusty Russell wrote:
> > Kent Overstreet <koverstreet@google.com> writes:
> > 
> >> CONFIG_VIRTIO isn't exposed, everything else is supposed to select it
> >> instead.
> > 
> > This is a slight mis-understanding.  It's supposed to be selected by
> > the particular driver, probably virtio_pci in your case.
> 
> virtio_mmio selects virtio as well.
> 
> drivers/virtio/Kconfig
> config VIRTIO_MMIO
>        select VIRTIO
> config VIRTIO_PCI
>        select VIRTIO
> 
> How about this:
> config VIRTIO_BLK
>        depends on EXPERIMENTAL && (VIRTIO_PCI || VIRTIO_MMIO)

Isn't this exactly what depends on VIRTIO achieves?

> -- 
> Asias
