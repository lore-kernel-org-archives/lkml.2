Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab1D0OFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:05:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858Ab1D0OFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:05:47 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/2] blkdev: Simple cleanup in blkdev_issue_zeroout()
References: <1303303172-22404-1-git-send-email-lczerner@redhat.com>
	<1303303172-22404-2-git-send-email-lczerner@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 27 Apr 2011 10:05:42 -0400
Message-ID: <x4962pz4wnd.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Czerner <lczerner@redhat.com> writes:

> In blkdev_issue_zeroout() we are submitting regular WRITE bios, so we do
> not need to check for -EOPNOTSUPP specifically in case of error. Also
> there is no need to have label submit: because there is no way to jump
> out from the while cycle without an error and we really want to exit,
> rather than try again.

Looks good.  While we're at it:

	while (nr_sects != 0) {
		sz = min((sector_t) PAGE_SIZE >> 9 , nr_sects);
		if (sz == 0)
			/* bio has maximum size possible */
			break;

how could sz be equal to zero there?

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Cheers,
Jeff
