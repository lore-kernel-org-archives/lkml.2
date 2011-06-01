Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab1FAJuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:50:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab1FAJuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 05:50:07 -0400
Date: Wed, 1 Jun 2011 12:49:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: [PATCH RFC 0/3] virtio and vhost-net capacity handling
Message-ID: <cover.1306921434.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, here's a new attempt to use the new capacity api.  I also added more
comments to clarify the logic.  Hope this is more readable.  Let me know
pls.

This is on top of the patches applied by Rusty.

Note: there are now actually 2 calls to fee_old_xmit_skbs on
data path so instead of passing flag '2' to the
second one I thought we can just make each call free up
at least 1 skb. This will work and even might be a bit faster (less
branches), but in the end I discarded this idea as too fragile (relies
on two calls on data path to function properly).

Warning: untested. Posting now to give people chance to
comment on the API.

Michael S. Tsirkin (3):
  virtio_ring: add capacity check API
  virtio_net: fix tx capacity checks using new API
  virtio_net: limit xmit polling

 drivers/net/virtio_net.c     |   65 +++++++++++++++++++++++------------------
 drivers/virtio/virtio_ring.c |    8 +++++
 include/linux/virtio.h       |    5 +++
 3 files changed, 49 insertions(+), 29 deletions(-)

-- 
1.7.5.53.gc233e
