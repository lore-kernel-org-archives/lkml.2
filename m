Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab0FSEZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 00:25:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab0FSEZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 00:25:57 -0400
Date: Sat, 19 Jun 2010 00:25:34 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [PATCH, RFC] block: don't allocate a payload for discard request
Message-ID: <20100619042534.GA16217@redhat.com>
References: <20100618145942.GA1148@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618145942.GA1148@lst.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18 2010 at 10:59am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> 
> Allocating a fixed payload for discard requests always was a horrible hack,
> and it's not coming to byte us when adding support for discard in DM/MD.
> 
> So change the code to leave the allocation of a payload to the lowlevel
> driver.  Unfortunately that means we'll need another hack, which allows
> us to update the various block layer length fields indicating that we
> have a payload.  Instead of hiding this in sd.c, which we already partially
> do for UNMAP support add a documented helper in the core block layer for it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mike Snitzer <snitzer@redhat.com>

I've built on your patch to successfully implement discard support for
DM (this includes splitting discards that span targets; only the linear
and striped DM targets are supported so far).

The patchset is still a work in progress but is available here (against
2.6.34 at the moment):
http://people.redhat.com/msnitzer/patches/dm-discard/latest/
