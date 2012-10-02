Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab2JBUJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 16:09:51 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50197 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2JBUJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 16:09:50 -0400
Date: Tue, 2 Oct 2012 13:09:46 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk
Subject: Re: [dm-devel] [PATCH v3 04/26] block: Refactor blk_update_request()
Message-ID: <20121002200946.GJ26488@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-5-git-send-email-koverstreet@google.com>
 <20121002185955.GD3283@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002185955.GD3283@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 02:59:55PM -0400, Vivek Goyal wrote:
> On Mon, Sep 24, 2012 at 03:34:44PM -0700, Kent Overstreet wrote:
> > Converts it to use bio_advance(), simplifying it quite a bit in the
> > process.
> > 
> > Note that req_bio_endio() now always calls bio_advance() - which means
> > it always loops over the biovec, not just on partial completions. Don't
> > expect it to affect performance, but worth noting.
> > 
> > Tested it by forcing partial updates, and dumping before and after on
> > various bio/bvec fields when doing a partial update.
> 
> Kent,
> 
> In general, have you tested all these changes with FLUSH and DISCARD 
> bios/requests. Some of the code paths tend to break down because of these
> special bios don't have payload.

Believe so, I should double check - also, I changed the bio_advance()
patch since the one I posted to make it handle DISCARD and WRITE_SAME
requests more explicitly.

(At this level, discards do (sometimes) have payloads, it's just always
a single page)
