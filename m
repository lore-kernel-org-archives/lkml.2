Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab2HTN54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:57:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365Ab2HTN5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:57:52 -0400
Date: Mon, 20 Aug 2012 09:57:39 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, neilb@suse.de,
        linux-scsi@vger.kernel.org
Subject: Re: [patch 1/2]block: handle merged discard request
Message-ID: <20120820135739.GB28570@redhat.com>
References: <20120320162157.GE17071@redhat.com>
 <CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
 <4F69C62C.7020604@kernel.org>
 <yq18vitwejt.fsf@sermon.lab.mkp.net>
 <CANejiEX26=jqijgTwb0iLMw7WC7byF1o+whwp3K5CcY5_a8o8w@mail.gmail.com>
 <yq1zkb9uz1t.fsf@sermon.lab.mkp.net>
 <20120620085724.GA26295@infradead.org>
 <yq1fw9o3t5b.fsf@sermon.lab.mkp.net>
 <CAMM=eLcBMrOfhJZU2GsSnMXkmWZMemJcvTM6WPLiiXkysXHYiQ@mail.gmail.com>
 <yq1wr0weu9q.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1wr0weu9q.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17 2012 at 11:47pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> Could be I've wasted a few hours by rebasing these patches...
> Mike> regardless, it would be great if you could share what your plans
> Mike> are.
> 
> Heh, I worked on syncing my patch queue up to Jens' and James' trees
> this afternoon. But I didn't quite finish the block stuff, mainly due to
> some conflicts with a few topology changes I also have pending.
> 
> I'll take a look at your series. Maybe I'll swap things around and put
> the topology changes on top instead of below. Leverage some of the work
> you did...

OK, just FYI, I had to change bio_has_data() to test bio->bi_vcnt
(rather than bio->bi_io_vec != NULL) because a discard bio has a
non-NULL bio->bi_io_vec (likely points to the bio->bi_inline_vecs but I
didn't check yet).

But I haven't put my finger on _why_ a discard bio has bio->bi_io_vec
(but given my use of DM, bio comes from bio_alloc_bioset, and DM passes
original bio->bi_max_vecs for nr_iovecs).

Anyway, this bio_has_data() change seemed reasonable considering
bio_data() checks bio->bi_vcnt.
