Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2A0KxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:53:03 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34561
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137Ab2A0KxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:53:01 -0500
Date: Fri, 27 Jan 2012 05:52:53 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>, Alex Elder <elder@kernel.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH] xfs: pass KM_SLEEP flag to kmem_realloc() in
 xlog_recover_add_to_cnt_trans()
Message-ID: <20120127105253.GA23335@infradead.org>
References: <20120127063726.16227.681.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127063726.16227.681.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 03:37:26PM +0900, Mitsuo Hayasaka wrote:
> The kmem_realloc() in xfs is given KM_* memory allocation flags. And it
> allocates memory using kmalloc() after they are converted to gfp_mask
> flags. In xlog_recover_add_to_cont_trans(), 0u is passed to kmem_realloc(),
> instead of them. I guess it is preferred to use them, and here memory must
> be allocated but don't have to be done with GFP_ATOMIC. So, this patch
> changes it to KM_SLEEP.

Looks good.  I actually just noticed it when changing the kmem_realloc
implementation, but let's put your patch in before that and send it off
to Linus ASAP.

Reviewed-by: Christoph Hellwig <hch@lst.de>
