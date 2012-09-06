Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2IFXms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 19:42:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab2IFXmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 19:42:47 -0400
Date: Thu, 6 Sep 2012 16:42:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v10 6/8] block: Kill bi_destructor
Message-ID: <20120906234242.GA9426@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
 <1346970902-10931-7-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346970902-10931-7-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 03:35:00PM -0700, Kent Overstreet wrote:
> Now that we've got generic code for freeing bios allocated from bio
> pools, this isn't needed anymore.
> 
> This patch also makes bio_free() static, since without bi_destructor
> there should be no need for it to be called anywhere else.
> 
> bio_free() is now only called from bio_put, so we can refactor those a
> bit - move some code from bio_put() to bio_free() and kill the redundant
> bio->bi_next = NULL.
> 
> v5: Switch to BIO_KMALLOC_POOL ((void *)~0), per Boaz
> v6: BIO_KMALLOC_POOL now NULL, drop bio_free's EXPORT_SYMBOL
> v7: No #define BIO_KMALLOC_POOL anymore
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
