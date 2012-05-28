Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab2E1Bab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 21:30:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48329 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab2E1Ba2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 21:30:28 -0400
Date: Mon, 28 May 2012 10:30:12 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v3 04/16] pktcdvd: Switch to bio_kmalloc()
Message-ID: <20120528013012.GD9891@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-5-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337977539-16977-5-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 01:25:27PM -0700, Kent Overstreet wrote:
> This is prep work for killing bi_destructor - previously, pktcdvd had
> its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
> necessitating its own bi_destructor implementation.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> Change-Id: I5604293e07f695c8f0106ae819e306f1def89a67
> ---
>  drivers/block/pktcdvd.c |  115 ++++++++++++++++-------------------------------
>  1 file changed, 39 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index ba66e44..6fe693a 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -522,36 +522,38 @@ static void pkt_bio_finished(struct pktcdvd_device *pd)
>  	}
>  }
>  
> -static void pkt_bio_destructor(struct bio *bio)
> +static void pkt_end_io_read(struct bio *bio, int err)

* Why isn't pktcdvd maintainer cc'd?

* How is it tested or why do you think this change is correct?

* Didn't Boaz point out that mixing function relocations and
  functional changes makes the patch difficult to review and verify
  already?  Why doesn't the patch description mention function
  relocations?  And why are they mixed with functional changes?

-- 
tejun
