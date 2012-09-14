Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2INS2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:28:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758684Ab2INS2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:28:46 -0400
Date: Fri, 14 Sep 2012 19:28:28 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH v10 1/8] block: Generalized bio pool freeing
Message-ID: <20120914182828.GK15728@agk-dp.fab.redhat.com>
Mail-Followup-To: Kent Overstreet <koverstreet@google.com>,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Hannes Reinecke <hare@suse.de>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com> <1346970902-10931-2-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346970902-10931-2-git-send-email-koverstreet@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 03:34:55PM -0700, Kent Overstreet wrote:
> With the old code, when you allocate a bio from a bio pool you have to
> implement your own destructor that knows how to find the bio pool the
> bio was originally allocated from.
> 
> This adds a new field to struct bio (bi_pool) and changes
> bio_alloc_bioset() to use it. This makes various bio destructors
> unnecessary, so they're then deleted.
> 
> v6: Explain the temporary if statement in bio_put
 
This patch also silently reverts 
commit 4d7b38b7d944a79da3793b6c92d38682f3905ac9
"dm: clear bi_end_io on remapping failure"

Why?

If it's intentional, please explain it in your patch header and
copy Hannes to reconsider the matter.

If it wasn't intentional, please reinstate it.

Alasdair

