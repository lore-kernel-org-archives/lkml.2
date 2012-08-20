Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2HTOPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:15:20 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37856
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765Ab2HTOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:15:17 -0400
Date: Mon, 20 Aug 2012 10:15:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Shaohua Li <shli@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        axboe@kernel.dk, linux-kernel@vger.kernel.org, neilb@suse.de,
        linux-scsi@vger.kernel.org
Subject: Re: [patch 1/2]block: handle merged discard request
Message-ID: <20120820141513.GA3418@infradead.org>
References: <yq18vitwejt.fsf@sermon.lab.mkp.net>
 <CANejiEX26=jqijgTwb0iLMw7WC7byF1o+whwp3K5CcY5_a8o8w@mail.gmail.com>
 <yq1zkb9uz1t.fsf@sermon.lab.mkp.net>
 <20120620085724.GA26295@infradead.org>
 <yq1fw9o3t5b.fsf@sermon.lab.mkp.net>
 <CAMM=eLcBMrOfhJZU2GsSnMXkmWZMemJcvTM6WPLiiXkysXHYiQ@mail.gmail.com>
 <yq1wr0weu9q.fsf@sermon.lab.mkp.net>
 <20120820135739.GB28570@redhat.com>
 <20120820135854.GA19254@infradead.org>
 <20120820141229.GC28570@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820141229.GC28570@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 10:12:29AM -0400, Mike Snitzer wrote:
> Thought we pushed that down?  Hence sd_setup_discard_cmnd's
> alloc_page + blk_add_request_payload hack.

Yeah, but we still need the bio_vec from early on, as it's allocated as
part of the bio.
