Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab0JWQsB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 12:48:01 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48851 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab0JWQsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 12:48:01 -0400
Message-ID: <4CC311D5.9040904@fusionio.com>
Date: Sat, 23 Oct 2010 18:48:21 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] convert DRBD to REQ_FLUSH/FUA
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <201008241745.35242.philipp.reisner@linbit.com> <20101022083511.GA7853@lst.de> <201010231318.33517.philipp.reisner@linbit.com>
In-Reply-To: <201010231318.33517.philipp.reisner@linbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-23 13:18, Philipp Reisner wrote:
> Hi Jens,
> 
> Christoph Hellwig pointed out that drbd is the only driver
> that still uses/supports barriers instead of FUE in linux-next.
> 
> I revitalized three patches that remove the barrier bits from DRBD...
> 
> The following changes since commit 8825f7c3e5c7b251b49fc594658a96f59417ee16:
> 
>   drbd: Silenced an assert (2010-10-22 15:55:22 +0200)
> 
> are available in the git repository at:
>   git://git.drbd.org/linux-2.6-drbd.git for-jens
> 
> Philipp Reisner (3):
>       drbd: Removed the BIO_RW_BARRIER support form the receiver/epoch code
>       drbd: REQ_HARDBARRIER -> REQ_FUA transition for meta data accesses
>       drbd: Removed checks for REQ_HARDBARRIER on incomming BIOs
> 
>  drivers/block/drbd/drbd_actlog.c   |   16 +---
>  drivers/block/drbd/drbd_int.h      |   20 +---
>  drivers/block/drbd/drbd_main.c     |    7 +-
>  drivers/block/drbd/drbd_nl.c       |    8 +-
>  drivers/block/drbd/drbd_proc.c     |    1 -
>  drivers/block/drbd/drbd_receiver.c |  212 +++++-------------------------------
>  drivers/block/drbd/drbd_req.c      |   14 ---
>  drivers/block/drbd/drbd_worker.c   |   21 ----
>  8 files changed, 40 insertions(+), 259 deletions(-)

Thanks, pulled!

-- 
Jens Axboe

