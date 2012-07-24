Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab2GXWue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 18:50:34 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56353
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755860Ab2GXWuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 18:50:32 -0400
Date: Tue, 24 Jul 2012 18:50:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Ankit Jain <jankit@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
        bcrl@kvack.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Make io_submit non-blocking
Message-ID: <20120724225026.GA21691@infradead.org>
References: <500E89D1.9010303@suse.de>
 <20120724223110.GQ23387@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120724223110.GQ23387@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 08:31:10AM +1000, Dave Chinner wrote:
> FWIW, if you are going to change generic code, you need to present
> results for other filesystems as well (xfs, btrfs are typical), as
> they may not have the same problems as ext4 or react the same way to
> your change. The result might simply be "it is 20% slower"....

And most importantly block devices, as they are one of the biggest
use cases of AIO.  With an almost no-op get_blocks callback I can't
see how this change would provide any gain there.

