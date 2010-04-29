Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab0D3RXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:23:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933117Ab0D3RXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:23:14 -0400
Date: Thu, 29 Apr 2010 17:26:31 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit.shah@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, Tejun Heo <tj@kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>, Shirley Ma <xma@us.ibm.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] virtio: add gfp_t parameter to add_buf
Message-ID: <cover.1272549641.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to allocate memory to post indirect buffers,
and sometimes drivers do this from a thread context,
so it helps to pass in a gfp_t parameter.

To avoid churn changing all drivers, add a new API
with a _gfp prefix, and make the old call lacking
gfp_t an inline wrapper.


-- 
MST


Michael S. Tsirkin (2):
  virtio: add_buf_gfp
  virtio-net: pass gfp to add_buf

 drivers/net/virtio_net.c     |    8 ++++----
 drivers/virtio/virtio_ring.c |   20 +++++++++++---------
 include/linux/virtio.h       |   22 +++++++++++++++++-----
 3 files changed, 32 insertions(+), 18 deletions(-)
