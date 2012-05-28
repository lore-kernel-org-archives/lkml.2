Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2E1BXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 21:23:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38810 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2E1BXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 21:23:23 -0400
Date: Mon, 28 May 2012 10:23:07 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v3 03/16] block: Add bio_reset()
Message-ID: <20120528012307.GC9891@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-4-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337977539-16977-4-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 01:25:26PM -0700, Kent Overstreet wrote:
> Reusing bios is something that's been highly frowned upon in the past,
> but driver code keeps doing it anyways. If it's going to happen anyways,
> we should provide a generic method.
> 
> This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
> was open coding it, by doing a bio_init() and resetting bi_destructor.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> Change-Id: Ib0a43dfcb3f6c22a54da513d4a86be544b5ffd95
> ---
>  fs/bio.c                  |    8 ++++++++
>  include/linux/bio.h       |    1 +
>  include/linux/blk_types.h |    6 ++++++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 3667cef..240da21 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -259,6 +259,14 @@ void bio_init(struct bio *bio)
>  }
>  EXPORT_SYMBOL(bio_init);
>  

Function comment please.

> +void bio_reset(struct bio *bio)
> +{
> +	memset(bio, 0, BIO_RESET_BYTES);
> +	bio->bi_flags = 1 << BIO_UPTODATE;
> +
> +}
> +EXPORT_SYMBOL(bio_reset);

-- 
tejun
