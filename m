Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab0KKXUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:20:30 -0500
Received: from claw.goop.org ([74.207.240.146]:38343 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab0KKXU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:20:29 -0500
Message-ID: <4CDC7A3C.8070206@goop.org>
Date: Thu, 11 Nov 2010 15:20:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "\"Xen-devel@lists.xensource.com\" li" 
	<Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Stodden <daniel.stodden@citrix.com>
Subject: [GIT PULL] xen blkfront barrier updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Here's the xen-blkfront barrier changes we discussed in Boston (its
identical to the last posted version).

The only comment was Christoph pointing out EOPNOTSUPP is not used in
the block interface, but blkfront is just using it as a local
placeholder and it never gets returned up to the block layer.

I still haven't sorted out what's going on with the backends; we
definitely need either a FLUSH operation or make empty WRITE_BARRIER
work to flush disk caches.

Thanks,
    J

The following changes since commit c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4:

  Linux 2.6.37-rc1 (2010-11-01 07:54:12 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/blkfront

Jeremy Fitzhardinge (4):
      xen/blkfront: map REQ_FLUSH into a full barrier
      xen/blkfront: change blk_shadow.request to proper pointer
      xen/blkfront: Implement FUA with BLKIF_OP_WRITE_BARRIER
      xen/blkfront: cope with backend that fail empty BLKIF_OP_WRITE_BARRIER requests

 drivers/block/xen-blkfront.c |   55 ++++++++++++++++++++++++-----------------
 1 files changed, 32 insertions(+), 23 deletions(-)


