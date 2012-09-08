Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2IHTlY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 15:41:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53191 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2IHTlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 15:41:20 -0400
Date: Sat, 8 Sep 2012 12:41:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk
Subject: Re: [PATCH 0/9] Prep work for immutable bio vecs
Message-ID: <20120908194115.GC12773@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347058760-30794-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347058760-30794-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Fri, Sep 07, 2012 at 03:59:11PM -0700, Kent Overstreet wrote:
> Random assortment of refactoring and trivial cleanups.
> 
> Immutable bio vecs and efficient bio splitting require auditing and removing
> pretty much all bi_idx uses, among other things.
> 
> The reason is that with immutable bio vecs we can't use the bvec array
> directly; if we have a partially completed bvec, that'll be indicated with a
> field in struct bvec_iter (which gets embedded in struct bio) - bi_bvec_done.
> 
> bio_for_each_segments() will handle this transparently, so code needs to be
> converted to use it or some other generic accessor.
> 
> Also, bio splitting means that when a driver gets a bio, bi_idx and
> bi_bvec_done may both be nonzero. Again, just need to use generic accessors.

There are three pending patchsets and I don't know how they're
supposed to come together.  Please explain on which tree the patches
are based and how they stack and preferably provide a git branch.

Thanks.

-- 
tejun
