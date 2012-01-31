Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2AaRu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 12:50:58 -0500
Received: from relay3.sgi.com ([192.48.152.1]:53590 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753372Ab2AaRu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 12:50:57 -0500
Date: Tue, 31 Jan 2012 11:50:53 -0600
From: Ben Myers <bpm@sgi.com>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>,
        Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH] xfs: pass KM_SLEEP flag to kmem_realloc() in
	xlog_recover_add_to_cnt_trans()
Message-ID: <20120131175053.GG7762@sgi.com>
References: <20120127063726.16227.681.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127063726.16227.681.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>

Looks good.  Consistent with other kmem_*alloc in log recovery.

Reviewed-by: Ben Myers <bpm@sgi.com>
