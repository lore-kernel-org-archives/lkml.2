Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab2JBT5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 15:57:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab2JBT5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 15:57:37 -0400
Date: Tue, 2 Oct 2012 14:59:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk
Subject: Re: [dm-devel] [PATCH v3 04/26] block: Refactor blk_update_request()
Message-ID: <20121002185955.GD3283@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-5-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348526106-17074-5-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 03:34:44PM -0700, Kent Overstreet wrote:
> Converts it to use bio_advance(), simplifying it quite a bit in the
> process.
> 
> Note that req_bio_endio() now always calls bio_advance() - which means
> it always loops over the biovec, not just on partial completions. Don't
> expect it to affect performance, but worth noting.
> 
> Tested it by forcing partial updates, and dumping before and after on
> various bio/bvec fields when doing a partial update.

Kent,

In general, have you tested all these changes with FLUSH and DISCARD 
bios/requests. Some of the code paths tend to break down because of these
special bios don't have payload.

Thanks
Vivek
