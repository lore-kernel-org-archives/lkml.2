Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab2ILS6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:58:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2ILS63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:58:29 -0400
Date: Wed, 12 Sep 2012 11:58:24 -0700
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>, Kent Overstreet <koverstreet@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Vivek Goyal <vgoyal@redhat.com>, drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] FLUSH/FUA documentation & code discrepancy
Message-ID: <20120912185824.GS7677@google.com>
References: <3029802.oqG0dEY71l@fat-tyre>
 <20120905084915.GF3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120905100724.GA27527@soda.linbit>
 <20120906212952.GP29092@google.com>
 <20120907084221.GD7028@soda.linbit>
 <20120910225442.GE7677@google.com>
 <20120910230654.GF7677@google.com>
 <20120910233159.GE19739@google.com>
 <20120911155820.74f1f918@notabene.brown>
 <20120911082501.GH7028@soda.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911082501.GH7028@soda.linbit>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 11, 2012 at 10:25:01AM +0200, Lars Ellenberg wrote:
> Or do we have a better place to document write ordering requirements?
> 
> "To enforce write-after-write dependencies, you *have* to drain the
> queue (do we have a generic interface available for that?),
> or at least wait for the completion of all the requests you
> (potentially) depend upon, before even submitting the dependent request.
> 
> Additionally, to avoid integrity issues due to volatile caches,
> you need to use FLUSH/FUA as appropriate."

I think it would be best to note the lack of any ordering guarantee in
the comment of bio_submit()?  Any one interested in submitting a
patch?

Thanks.

-- 
tejun
