Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab2HGDTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:19:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182Ab2HGDTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:19:35 -0400
Date: Mon, 6 Aug 2012 23:19:21 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, mpatocka@redhat.com,
        vgoyal@redhat.com, yehuda@hq.newdream.net, tj@kernel.org,
        sage@newdream.net, agk@redhat.com, drbd-dev@lists.linbit.com
Subject: Re: [PATCH v5 05/12] block: Kill bi_destructor
Message-ID: <20120807031921.GA31977@redhat.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-6-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344290921-25154-6-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06 2012 at  6:08pm -0400,
Kent Overstreet <koverstreet@google.com> wrote:

> Now that we've got generic code for freeing bios allocated from bio
> pools, this isn't needed anymore.
> 
> This also changes the semantics of bio_free() a bit - it now also frees
> bios allocated by bio_kmalloc(). It's also no longer exported, as
> without bi_destructor there should be no need for it to be called
> anywhere else.

Seems you forgot to remove bio_free's EXPORT_SYMBOL
