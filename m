Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab1FSK11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 06:27:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab1FSK1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 06:27:25 -0400
Date: Sun, 19 Jun 2011 13:27:00 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Krishna Kumar2 <krkumar2@in.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Carsten Otte <cotte@de.ibm.com>, habanero@linux.vnet.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux390@de.ibm.com,
        netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, steved@us.ibm.com,
        Tom Lendacky <tahm@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org, Shirley Ma <xma@us.ibm.com>,
        roprabhu@cisco.com
Subject: RFT: virtio_net: limit xmit polling
Message-ID: <20110619102700.GA11198@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, different people seem to test different trees.  In the hope to get
everyone on the same page, I created several variants of this patch so
they can be compared. Whoever's interested, please check out the
following, and tell me how these compare:

kernel:

git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git

virtio-net-limit-xmit-polling/base - this is net-next baseline to test against
virtio-net-limit-xmit-polling/v0 - fixes checks on out of capacity
virtio-net-limit-xmit-polling/v1 - previous revision of the patch
		this does xmit,free,xmit,2*free,free
virtio-net-limit-xmit-polling/v2 - new revision of the patch
		this does free,xmit,2*free,free

There's also this on top:
virtio-net-limit-xmit-polling/v3 -> don't delay avail index update
I don't think it's important to test this one, yet

Userspace to use: event index work is not yet merged upstream
so the revision to use is still this:
git://git.kernel.org/pub/scm/linux/kernel/git/mst/qemu-kvm.git
virtio-net-event-idx-v3

-- 
MST
