Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2IUAGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:06:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52435 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab2IUAGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:06:36 -0400
Date: Thu, 20 Sep 2012 17:06:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 15/26] block: Add bio_copy_data()
Message-ID: <20120921000632.GS7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-16-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347322957-25260-16-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 10, 2012 at 05:22:26PM -0700, Kent Overstreet wrote:
> +void bio_copy_data(struct bio *dst, struct bio *src)
> +{
...
> +		src_p = kmap_atomic(src_bv->bv_page);
> +		dst_p = kmap_atomic(dst_bv->bv_page);
> +
> +		memcpy(dst_p + dst_bv->bv_offset,
> +		       src_p + src_bv->bv_offset,
> +		       bytes);
> +
> +		kunmap_atomic(dst_p);
> +		kunmap_atomic(src_p);

Wrap these in preempt_disable/enable() to allow the function to be
called from any context?

Thanks.

-- 
tejun
