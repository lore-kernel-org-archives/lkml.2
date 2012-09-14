Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953Ab2INTFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 15:05:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759934Ab2INTFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 15:05:48 -0400
Date: Fri, 14 Sep 2012 20:05:38 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v10 3/8] dm: Use bioset's front_pad for
	dm_rq_clone_bio_info
Message-ID: <20120914190538.GN15728@agk-dp.fab.redhat.com>
Mail-Followup-To: Kent Overstreet <koverstreet@google.com>,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com, axboe@kernel.dk,
	Alasdair Kergon <agk@redhat.com>
References: <1347050642-7080-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347050642-7080-1-git-send-email-koverstreet@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 01:44:01PM -0700, Kent Overstreet wrote:
> Previously, dm_rq_clone_bio_info needed to be freed by the bio's
> destructor to avoid a memory leak in the blk_rq_prep_clone() error path.
> This gets rid of a memory allocation and means we can kill
> dm_rq_bio_destructor.
> 
> The _rq_bio_info_cache kmem cache is unused now and needs to be deleted,
> but due to the way io_pool is used and overloaded this looks not quite
> trivial so I'm leaving it for a later patch.
 
Acked-by: Alasdair Kergon <agk@redhat.com>

> +/*
> + * Unused now, and needs to be deleted. But since io_pool is overloaded and it's
> + * still used for _io_cache, I'm leaving this for a later cleanup
> + */

Please avoid "I" in a source file unless you are the author of the file or
put your name after your comments.

An unattributed "FIXME" style of comment here would be fine.

Alasdair

