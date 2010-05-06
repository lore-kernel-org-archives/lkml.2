Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab0EFVKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 17:10:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab0EFVKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 17:10:13 -0400
Date: Thu, 6 May 2010 17:10:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] fs: allow short direct-io reads to be completed
	via buffered IO V2
Message-ID: <20100506211012.GD2997@infradead.org>
References: <20100506190012.GB13974@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506190012.GB13974@dhcp231-156.rdu.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 03:00:13PM -0400, Josef Bacik wrote:
> V1->V2: Check to see if our current ppos is >= i_size after a short DIO read,
> just in case it was actually a short read and we need to just return.
> 
> This is similar to what already happens in the write case.  If we have a short
> read while doing O_DIRECT, instead of just returning, fallthrough and try to
> read the rest via buffered IO.  BTRFS needs this because if we encounter a
> compressed or inline extent during DIO, we need to fallback on buffered.  If the
> extent is compressed we need to read the entire thing into memory and
> de-compress it into the users pages.  I have tested this with fsx and everything
> works great.  Thanks,

This seems safe to me, but I'm a bit worried about potential breakages.
Did you test this with xfsqa on xfs and ext3/4 to make sure there are
no regressions?

