Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2E3HrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:47:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37962 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2E3HrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:47:21 -0400
Date: Wed, 30 May 2012 16:47:08 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 11/16] bcache: Core btree code
Message-ID: <20120530074708.GA32121@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <7f1de39b6d7040b3fe271500776f4b985b21ea82.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f1de39b6d7040b3fe271500776f4b985b21ea82.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple more comments from this round of reading.

On Wed, May 09, 2012 at 11:10:48PM -0400, Kent Overstreet wrote:
> +#define btree_prio		USHRT_MAX
> +#define initial_prio		32768

Why are these in lower case?

> +#define PTR_BUCKET(c, k, n)						\
> +	(PTR_CACHE(c, k, n)->buckets + PTR_BUCKET_NR(c, k, n))

PTR_BUCKET(c, k, n)

Awesome.  I don't know what type it takes or what each single
character argument stands for.

> +static inline bool cached_dev_get(struct cached_dev *d)
> +{
> +	if (!atomic_inc_not_zero(&d->count))
> +		return false;
> +
> +	smp_mb__after_atomic_inc();

What is this mb() paired with?  Whenever using a mb, please specify
what the mb is paired with.

> +	return true;
> +}

Thanks.

-- 
tejun
