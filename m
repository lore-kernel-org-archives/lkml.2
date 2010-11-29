Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0K2RFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:05:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab0K2RE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:04:59 -0500
Date: Mon, 29 Nov 2010 19:04:31 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] tools/virtio: virtio_ring testing tool
Message-ID: <20101129170431.GA4027@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements a virtio simulator:
 - adds stubs for enough support functions to compile
   virtio ring in userspace.
 - Adds a stub vhost based module this can talk to.
 
This should help us decide things like which ring layout
works best.
 
Communication is currently done using an eventfd descriptor.
This means there's a shared spinlock there: what I would like to do
in the future, is run this under kvm and use interrupt injection and
io for communication, to make it more real-life and avoid lock
contention.

This patchset applies on top of vhost-net-next branch in my tree.
In particular you must have commits:
commit 64e1c80748afca3b4818ebb232a9668bf529886d
    vhost-net: batch use/unuse mm
commit 533a19b4b88fcf81da3106b94f0ac4ac8b33a248
    vhost: put mm after thread stop
 
I think it's probably best to keep this part of kernel tree,
to avoid version skew and so we don't need to commit to
any kind of API.

Since there's a dependency on vhost here it's easiest
to merge this through my vhost tree, so that's what
I intend to do unless someone complains, soon.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
