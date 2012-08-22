Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab2HVVHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:07:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63805 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933209Ab2HVVHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:07:45 -0400
Date: Wed, 22 Aug 2012 14:07:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v6 12/13] block: Add bio_clone_bioset(),
 bio_clone_kmalloc()
Message-ID: <20120822210740.GM19212@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-13-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345655050-28199-13-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 10:04:09AM -0700, Kent Overstreet wrote:
> Previously, there was bio_clone() but it only allocated from the fs bio
> set; as a result various users were open coding it and using
> __bio_clone().
> 
> This changes bio_clone() to become bio_clone_bioset(), and then we add
> bio_clone() and bio_clone_kmalloc() as wrappers around it, making use of
> the functionality the last patch adedd.
> 
> This will also help in a later patch changing how bio cloning works.

I'd prefer simply adding @bioset to bio_clone() so that the caller
always has to make the choice consciously.  We're updating all the
callers anyway.

Thanks.

-- 
tejun
