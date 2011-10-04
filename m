Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1JDBSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 21:18:33 -0400
Received: from ozlabs.org ([203.10.76.45]:41205 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab1JDBSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 21:18:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] virtio: Support for hibernation (S4)
In-Reply-To: <20111002094920.GF29706@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com> <20111002094920.GF29706@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 04 Oct 2011 10:36:05 +1030
Message-ID: <8739f9ipsi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Oct 2011 11:49:21 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Sep 29, 2011 at 08:55:56PM +0530, Amit Shah wrote:
> > Hello,
> > 
> > These patches add support for S4 to virtio (pci) and all drivers.  The
> > patches are based on the virtio-console patch series in Rusty's queue.
> > 
> > For each driver, all vqs are removed before hibernation, and then
> > re-created after restore.
> > 
> > All the drivers in testing work fine:
> > 
> > * virtio-blk is used for the only disk in the VM, IO works fine before
> >   and after.

I'm not familiar with the suspend code, but:

1) Does it already ensure there are no outstanding I/O requests?  If
   not, we want to restore them when we unfreeze.

2) Does it stop more I/O from reaching do_virtblk_request during freeze?
   If not, we need to.

If we need to save and restore requests, I don't think we should do this
on a per-driver basis, but try to do it in the core.

Thanks,
Rusty.
