Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab2HTOMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:12:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab2HTOMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:12:41 -0400
Date: Mon, 20 Aug 2012 10:12:29 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Shaohua Li <shli@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        axboe@kernel.dk, linux-kernel@vger.kernel.org, neilb@suse.de,
        linux-scsi@vger.kernel.org
Subject: Re: [patch 1/2]block: handle merged discard request
Message-ID: <20120820141229.GC28570@redhat.com>
References: <4F69C62C.7020604@kernel.org>
 <yq18vitwejt.fsf@sermon.lab.mkp.net>
 <CANejiEX26=jqijgTwb0iLMw7WC7byF1o+whwp3K5CcY5_a8o8w@mail.gmail.com>
 <yq1zkb9uz1t.fsf@sermon.lab.mkp.net>
 <20120620085724.GA26295@infradead.org>
 <yq1fw9o3t5b.fsf@sermon.lab.mkp.net>
 <CAMM=eLcBMrOfhJZU2GsSnMXkmWZMemJcvTM6WPLiiXkysXHYiQ@mail.gmail.com>
 <yq1wr0weu9q.fsf@sermon.lab.mkp.net>
 <20120820135739.GB28570@redhat.com>
 <20120820135854.GA19254@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820135854.GA19254@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20 2012 at  9:58am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Aug 20, 2012 at 09:57:39AM -0400, Mike Snitzer wrote:
> > But I haven't put my finger on _why_ a discard bio has bio->bi_io_vec
> > (but given my use of DM, bio comes from bio_alloc_bioset, and DM passes
> > original bio->bi_max_vecs for nr_iovecs).
> 
> TRIM has a payload and we cheay by preallocation a data page for it.

Thought we pushed that down?  Hence sd_setup_discard_cmnd's
alloc_page + blk_add_request_payload hack.
