Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030292Ab2CVNEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 09:04:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60973 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2CVNEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 09:04:08 -0400
MIME-Version: 1.0
Date: Thu, 22 Mar 2012 17:04:07 +0400
Message-ID: <CANaxB-zpcuxeJ7TSi+3DbaFE=-FUH31c=sUg72bdBCdBnRANaQ@mail.gmail.com>
Subject: The question about blkdev_issue_discard and discard_granularity
From: Andrew Wagin <avagin@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jens,

I'm developing a virtual disk (aka ploop). Now I'm adding support of
discard requests. A block size of ploop may be customized, so I want
that a discard request contains only whole blocks. I found a queue's
parameter discard_granularity and set it correctly, but nothing's
changed. A kernel continues sending bio with size smaller than
discard_granularity and with unaligned borders.

I found that max_discard_sectors is aligned according with discard_granularity.

Why are bi->bi_size and bi->bi_sector not aligned according with
discard_granularity?

If it's just because nobody did this, I can do.

Thanks,
Andrey
