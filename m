Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab0JWLSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:18:37 -0400
Received: from mail09.linbit.com ([212.69.161.110]:54950 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab0JWLSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:18:36 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Jens Axboe <jaxboe@fusionio.com>
Subject: [GIT PULL] convert DRBD to REQ_FLUSH/FUA
Date: Sat, 23 Oct 2010 13:18:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; i686; ; )
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <201008241745.35242.philipp.reisner@linbit.com> <20101022083511.GA7853@lst.de>
In-Reply-To: <20101022083511.GA7853@lst.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010231318.33517.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Christoph Hellwig pointed out that drbd is the only driver
that still uses/supports barriers instead of FUE in linux-next.

I revitalized three patches that remove the barrier bits from DRBD...

The following changes since commit 8825f7c3e5c7b251b49fc594658a96f59417ee16:

  drbd: Silenced an assert (2010-10-22 15:55:22 +0200)

are available in the git repository at:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

Philipp Reisner (3):
      drbd: Removed the BIO_RW_BARRIER support form the receiver/epoch code
      drbd: REQ_HARDBARRIER -> REQ_FUA transition for meta data accesses
      drbd: Removed checks for REQ_HARDBARRIER on incomming BIOs

 drivers/block/drbd/drbd_actlog.c   |   16 +---
 drivers/block/drbd/drbd_int.h      |   20 +---
 drivers/block/drbd/drbd_main.c     |    7 +-
 drivers/block/drbd/drbd_nl.c       |    8 +-
 drivers/block/drbd/drbd_proc.c     |    1 -
 drivers/block/drbd/drbd_receiver.c |  212 +++++-------------------------------
 drivers/block/drbd/drbd_req.c      |   14 ---
 drivers/block/drbd/drbd_worker.c   |   21 ----
 8 files changed, 40 insertions(+), 259 deletions(-)
