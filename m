Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab2HVUAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 16:00:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48531 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab2HVUAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 16:00:37 -0400
Date: Wed, 22 Aug 2012 13:00:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 05/13] block: Kill bi_destructor
Message-ID: <20120822200032.GH19212@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-6-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345655050-28199-6-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 22, 2012 at 10:04:02AM -0700, Kent Overstreet wrote:
> +#define BIO_KMALLOC_POOL NULL

I would much prefer just doing

	if (!bs) {
		/* do kmalloc/kfree thing */
	} else {
		/* do bioset thing */
	}

NULL @bs indicating no bioset is perfectly natural and so is using
generic memory allocation in the absense of bioset.  I don't see any
value in defining Bio_KMALLOC_POOL to be NULL.

Thanks.

-- 
tejun
