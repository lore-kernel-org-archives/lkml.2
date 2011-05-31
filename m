Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1EaMtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:49:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab1EaMtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:49:23 -0400
Date: Tue, 31 May 2011 08:49:13 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, msb@chromium.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH 2/3] block: Move non-rotational flag to queue limits
Message-ID: <20110531124913.GB12679@redhat.com>
References: <4DDEA689.2090004@fusionio.com>
 <1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
 <1306464169-4291-3-git-send-email-martin.petersen@oracle.com>
 <20110527130248.GA17219@redhat.com>
 <yq1k4d7zk56.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1k4d7zk56.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30 2011 at 10:19pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> blk_queue_nonrot vs blk_queue_non_rotational lends itself to a
> Mike> small amount of confusion.
> 
> Yeah, I just didn't feel like mucking with the existing call. But it
> looks like there are only a handful of users.
> 
> 
> Mike> What about:
> Mike>  s/blk_queue_nonrot/blk_queue_non_rotational/
> Mike>  s/blk_queue_non_rotational/blk_queue_set_non_rotational/
> Mike> ?
> 
> Most of our other block layer calls take the form blk_queue_max_foo()
> for setting foo and {bdev,queue}_max_foo() for querying.
> 
> So I guess the most appropriate thing to do would be to do something
> like this?
> 
> 
> block: Move non-rotational flag to queue limits
> 
> To avoid special-casing the non-rotational flag when stacking it is
> moved from the queue flags to be part of the queue limits. This allows
> us to handle it like the remaining I/O topology information.
> 
> Also rename blk_queue_nonrot() to be consistent with block layer calling
> conventions.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
