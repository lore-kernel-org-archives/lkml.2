Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab1LVAfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:35:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48053 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab1LVAfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:35:12 -0500
Date: Wed, 21 Dec 2011 16:35:07 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 1/2] mempool: drop unnecessary and incorrect BUG_ON()
 from mempool_destroy()
Message-ID: <20111222003316.GN9213@google.com>
References: <20111222001800.GL9213@google.com>
 <20111221162519.b7fc3a79.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221162519.b7fc3a79.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 21, 2011 at 04:25:19PM -0800, Andrew Morton wrote:
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: stable@kernel.org
> 
> (that's stable@vger.kernel.org)

(cc'ing Greg)

It has been stable@kernel.org for quite a while and Greg scans for
that Cc.  Even MAINTAINERS has that as the official mail address.  I
heard that the mailing alias is broken at the moment but wouldn't it
be better to fix that?

> > ---
> > These patches are on top of "mempool: fix and document synchronization
> > and memory barrier usage" patch[1].  Both are fixes and it probably is
> > a good idea to forward to -stable.
> 
> I'm not sure that either of these are suitable for -stable.  There's no
> demonstrated problem, nor even a likely theoretical one, is there?
> 
> If we do decide to backport, I don't think the -stable guys will want
> the large-but-nice comment-adding patch so both these patches would need to
> be reworked for -stable usage.  The first patch does apply successfully
> to mainline.  The second does not.

Hmmm... I think it should be possible to trip the BUG_ON() removed by
the first patch with targeted enough attack but AFAICS that would
require root priv so it might not be too bad.  The second one, while
not optimal, shouldn't be critical.  BTW, I missed sth in the second
patch, will soon post an updated one.

Thanks.

-- 
tejun
