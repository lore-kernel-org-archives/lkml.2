Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928Ab2EXTnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:43:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933546Ab2EXTnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:43:12 -0400
Date: Thu, 24 May 2012 15:42:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, bharrosh@panasas.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v2 07/14] pktcdvd: Switch to bio_kmalloc()
Message-ID: <20120524194252.GF27550@redhat.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-8-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337817771-25038-8-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 05:02:44PM -0700, Kent Overstreet wrote:

[..]
> @@ -567,10 +569,13 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
>  		goto no_pkt;
>  
>  	pkt->frames = frames;
> -	pkt->w_bio = pkt_bio_alloc(frames);
> +	pkt->w_bio = bio_kmalloc(GFP_KERNEL, frames);

So previously bios allocated were being kfreed by pkt_bio_destructor().
Now where are we doing kfree() on bio being allocated by bio_kmalloc()?

Thanks
Vivek
