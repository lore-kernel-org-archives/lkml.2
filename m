Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab2JXVNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:13:35 -0400
Received: from condef004-v.nifty.com ([210.131.4.241]:49456 "EHLO
	condef004-v.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2JXVNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:13:34 -0400
X-Nifty-SrcIP: [124.34.79.27]
Message-Id: <201210242111.q9OLBL28027212@msag502.nifty.com>
MIME-Version: 1.0
Date: Thu, 25 Oct 2012 06:11:17 +0900
X-Mailer: Denshin 8 Go V32.1.6.0 070
From: MITSUNARI Shigeo <herumi@nifty.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
In-Reply-To: (Your message of "Wed, 24 Oct 2012 09:44:23 -0400")
  <x491ugo6l3c.fsf@segfault.boston.devel.redhat.com>
References: <x491ugo6l3c.fsf@segfault.boston.devel.redhat.com>
Subject: Re: fs: page cache wrongly left invalidated after revalidate_disk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

> rescan_partitions (called in the bdev open path) should reset
> bd_invalidated.  I think you need to dig into why that isn't happening.

rescan_partitions() and invalidate_partitions() reset bd_invalidated
after calling check_disk_size_change(). But revalidate_disk() does not it.

So, I think bdev->bd_invalidated = 0 is necessary for revalidate_disk(),
or check_disk_size_change() should be it more simply.

Yours,
 Shigeo
