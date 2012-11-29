Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab2K2BMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:12:31 -0500
Received: from kanga.kvack.org ([205.233.56.17]:43914 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597Ab2K2BM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:12:29 -0500
X-Greylist: delayed 1557 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2012 20:12:29 EST
Date: Wed, 28 Nov 2012 19:46:31 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, jmoyer@redhat.com,
        axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 12/25] aio: Refcounting cleanup
Message-ID: <20121129004631.GE19042@kvack.org>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com> <1354121029-1376-13-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354121029-1376-13-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,

On Wed, Nov 28, 2012 at 08:43:36AM -0800, Kent Overstreet wrote:
> + * now it's safe to cancel any that need to be.
> + */
> +static void free_ioctx(struct kioctx *ctx)
...
> +	aio_nr -= ctx->max_reqs;
> +	spin_unlock(&aio_nr_lock);
> +
> +	synchronize_rcu();
> +
> +	pr_debug("freeing %p\n", ctx);
> +	kmem_cache_free(kioctx_cachep, ctx);
> +}

As mentioned on irc, we probably want to avoid the synchronize_rcu() 
overhead, since delays here will impact the time it takes for a task to 
exit.  Cheers,

		-ben
-- 
"Thought is the essence of where you are now."
