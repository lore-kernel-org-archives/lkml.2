Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab0ERK1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:27:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab0ERK1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:27:43 -0400
Message-ID: <4BF26B87.3080902@redhat.com>
Date: Tue, 18 May 2010 12:27:19 +0200
From: Jes Sorensen <Jes.Sorensen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Jiri Pirko <jpirko@redhat.com>,
       Shirley Ma <xma@us.ibm.com>, Amit Shah <amit.shah@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, quintela@redhat.com,
       alex.williamson@redhat.com
Subject: Re: [PATCH] virtio: put last seen used index into ring itself
References: <20100518004744.GA21359@redhat.com>
In-Reply-To: <20100518004744.GA21359@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/10 02:47, Michael S. Tsirkin wrote:
> Generally, the Host end of the virtio ring doesn't need to see where
> Guest is up to in consuming the ring.  However, to completely understand
> what's going on from the outside, this information must be exposed.
> For example, host can reduce the number of interrupts by detecting
> that the guest is currently handling previous buffers.
> 
> Fortunately, we have room to expand: the ring is always a whole number
> of pages and there's hundreds of bytes of padding after the avail ring
> and the used ring, whatever the number of descriptors (which must be a
> power of 2).

Hi Michael,

Small build fix for this against Linus upstream.

Jes


Fix build of virtio_net.c

Signed-off-by: Jes.Sorensen@redhat.com
---
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d37e5be..679e2df 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/virtio.h>
 #include <linux/virtio_net.h>
+#include <linux/virtio_ring.h>
 #include <linux/scatterlist.h>
 #include <linux/if_vlan.h>
 #include <linux/slab.h>


