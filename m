Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab0GBHel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:34:41 -0400
Received: from sh.osrg.net ([192.16.179.4]:41489 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab0GBHeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:34:18 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: James.Bottomley@suse.de, axboe@kernel.dk
Cc: hch@lst.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/2] use q->prep_rq_fn for flush requests instead of q->prepare_flush_fn()
Date: Fri,  2 Jul 2010 16:33:23 +0900
Message-Id: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 02 Jul 2010 16:34:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scsi-ml builds flush requests via q->prepare_flush_fn(), however,
builds discard requests via q->prep_rq_fn.

Using two different mechnisms for the similar requests (building
commands in SCSI ULD) doesn't make sense.

Handing both via q->prep_rq_fn makes the code simpler.

We could kill q->prepare_flush_fn(). Except for ide, all the users
just mark flush requests. They can use REQ_FLUSH flag instead. Ide can
do like SCSI.

==
 block/blk-barrier.c |   12 ++++--------
 drivers/scsi/sd.c   |   26 ++++++++++++++++----------
 include/linux/bio.h |    2 ++
 3 files changed, 22 insertions(+), 18 deletions(-)
