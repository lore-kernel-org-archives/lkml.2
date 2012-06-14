Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2FNCcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:32:10 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50779 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2FNCcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:32:08 -0400
Date: Thu, 14 Jun 2012 11:31:56 +0900
From: Tejun Heo <tj@kernel.org>
To: Asias He <asias@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH RFC 1/2] block: Add blk_bio_map_sg() helper
Message-ID: <20120614023156.GB3766@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1339573307-11537-1-git-send-email-asias@redhat.com>
 <1339573307-11537-2-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339573307-11537-2-git-send-email-asias@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 03:41:46PM +0800, Asias He wrote:
> Add a helper to map a bio to a scatterlist, modelled after
> blk_rq_map_sg.
> 
> This helper is useful for any driver that wants to create
> a scatterlist from its ->make_request_fn method.

This may not be possible but I really wanna avoid having two copies of
that complex logic.  Any chance blk_rq_map_bio() can be implemented in
a way that allows blk_rq_map_sg() can be built on top of it?  Also,
please include proper docbook style function comment on new public API
functions.

Thanks.

-- 
tejun
