Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2ITXiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:38:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44336 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2ITXiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:38:23 -0400
Date: Thu, 20 Sep 2012 16:38:20 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 02/26] block: Add bio_advance()
Message-ID: <20120920233820.GD5519@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-3-git-send-email-koverstreet@google.com>
 <20120920215827.GF7264@google.com>
 <20120920231308.GB5519@google.com>
 <20120920232506.GI7264@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920232506.GI7264@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 04:25:06PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Sep 20, 2012 at 04:13:08PM -0700, Kent Overstreet wrote:
> > I just cut and pasted that from blk_update_request(), which is what the
> > next patch refactors...
> 
> Yeah, well, that was written when we didn't have WARNs.
> 
> > But yes it would be a bug. It gets converted to a BUG_ON() in a later
> > patch (not in this series), as this gets further abstracted into a
> > wrapper around bvec_advance_iter() which doesn't know about struct bio
> > (as bio integrity gets its own iterator).
> 
> WARN() generally preferable unless there's no way at all to continue.
> Storage layer could be a bit different if immediate danger for data
> corruption exists but the general consensus seems that we're too
> trigger happy with BUG_ON()s.

Yeah. Changed it to a WARN_ONCE().
