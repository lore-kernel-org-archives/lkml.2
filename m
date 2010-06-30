Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0F3MS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 08:18:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab0F3MS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 08:18:57 -0400
Date: Wed, 30 Jun 2010 08:18:20 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>,
       axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com, akpm@linux-foundation.org,
       linux-scsi@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
Message-ID: <20100630121820.GB22798@redhat.com>
References: <20100622180029.GA15950@redhat.com>
 <1277582211-10725-1-git-send-email-snitzer@redhat.com>
 <1277652576.4366.19.camel@mulgrave.site>
 <4C2B012B.2000407@panasas.com>
 <20100630084204.GA27609@lst.de>
 <4C2B1B7D.2090607@panasas.com>
 <20100630104155.GA1370@lst.de>
 <4C2B2318.1030107@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2B2318.1030107@panasas.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30 2010 at  6:57am -0400,
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 06/30/2010 01:41 PM, Christoph Hellwig wrote:
> > On Wed, Jun 30, 2010 at 01:25:01PM +0300, Boaz Harrosh wrote:
> >> OK, Thanks, I see. Is it one of these operations, (like we have in OSD) where
> >> the CDB information spills into the payload? like the scatter-gather and extent
> >> lists and such.
> > 
> > For UNMAP the payload is a list of block number / length pairs, while
> > the CDB itself doesn't contain any information like that.  It's a rather
> > awkward command.
> > 
> 
> How big can that be? could we, maybe, use the sense_buffer, properly allocated
> already?
> 
> >> Do we actually use a WRITE_SAME which is not zero? for what use?
> > 
> > The kernel doesn't issue any WRITE SAME without the unmap bit set.
> 
> So if the unmap bit is set then the page can just be zero, right?
> 
> I still think a static zero-page is a worth while optimization. And
> block-drivers can take care with special needs with a private mem_pool
> or something. For the discard-type user and generic block layer the
> page is just an implementation specific residue, No?

Why should the block layer have any role in managing this page?  Block
layer doesn't care about it, SCSI does.

Mike
