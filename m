Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab2AFDEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 22:04:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41363 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570Ab2AFDEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 22:04:11 -0500
Date: Thu, 5 Jan 2012 19:04:06 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH block:for-3.3/core] cfq: merged request shouldn't jump
 to a different cfqq
Message-ID: <20120106030406.GD6276@google.com>
References: <20120103200906.GG31746@google.com>
 <4F03631C.8080501@kernel.dk>
 <20120103221301.GH31746@google.com>
 <20120103223505.GI31746@google.com>
 <20120105012445.GP31746@google.com>
 <alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
 <20120105183842.GF18486@google.com>
 <20120106021707.GA6276@google.com>
 <20120106023638.GC6276@google.com>
 <1325819655.22361.513.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325819655.22361.513.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 06, 2012 at 11:14:15AM +0800, Shaohua Li wrote:
> > So, yeah, the right fix would be using elv_former/latter_request()
> > instead.  Maybe we should strip out rqhash altogether and change
> > elevator handle everything?  I don't know.  I'll prepare a different
> > fix patch soon.
>
> So not allow merge from two cfq queues strictly? This will impact
> performance. I don't know how important the strict isolation is. we even
> allow two cfq queues merge to improve performance.

That's how cfq has behaved before this recent plug merge breakage and
IIRC why the cooperating queue thing is there.  If you want to change
the behavior, that should be an explicit separate patch.

Thanks.

-- 
tejun
