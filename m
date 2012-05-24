Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965993Ab2EXT7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:59:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61055 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965326Ab2EXTzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:55:53 -0400
Date: Thu, 24 May 2012 12:55:49 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, bharrosh@panasas.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v2 07/14] pktcdvd: Switch to bio_kmalloc()
Message-ID: <20120524195549.GA18624@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-8-git-send-email-koverstreet@google.com>
 <20120524194252.GF27550@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524194252.GF27550@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 03:42:52PM -0400, Vivek Goyal wrote:
> On Wed, May 23, 2012 at 05:02:44PM -0700, Kent Overstreet wrote:
> 
> [..]
> > @@ -567,10 +569,13 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
> >  		goto no_pkt;
> >  
> >  	pkt->frames = frames;
> > -	pkt->w_bio = pkt_bio_alloc(frames);
> > +	pkt->w_bio = bio_kmalloc(GFP_KERNEL, frames);
> 
> So previously bios allocated were being kfreed by pkt_bio_destructor().
> Now where are we doing kfree() on bio being allocated by bio_kmalloc()?

bio_kmalloc() sets up bi_destructor, so there's no need to kfree() the
bio - bio_put() frees it just like normal.
