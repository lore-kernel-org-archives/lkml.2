Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab2ACWfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:35:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51133 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab2ACWfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:35:10 -0500
Date: Tue, 3 Jan 2012 14:35:05 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Hugh Dickins <hughd@google.com>, Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH block/for-3.3/core] block: an exiting task should be
 allowed to create io_context
Message-ID: <20120103223505.GI31746@google.com>
References: <alpine.LSU.2.00.1112280010550.1398@eggly.anvils>
 <20111228164836.GP17712@google.com>
 <alpine.LSU.2.00.1112280939390.3320@eggly.anvils>
 <CAOS58YOzUcZz41+H+7dk5FteHy+Ufrtpk9dvdPqX6eie-GHi0Q@mail.gmail.com>
 <20111228211918.GA3516@google.com>
 <20120103173500.GB31746@google.com>
 <20120103175922.GC31746@google.com>
 <20120103200906.GG31746@google.com>
 <4F03631C.8080501@kernel.dk>
 <20120103221301.GH31746@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103221301.GH31746@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 02:13:01PM -0800, Tejun Heo wrote:
> > That's pretty odd. Given Hughs report as well, it sure does sound like
> > we now have some life time issues with cfqq's.
> 
> Hmmm... I disabled cfqq merge logic (commented out
> cfq_close_cooperator() and the following cfq_setup_merge() calls) in
> cfq_select_queue() and neither is triggering for quite a while now.
> Maybe cfqq refcnt is getting borked over cfqq merging / splitting?  It
> would also explain the low frequency of the issue too.  I'll try to
> further isolate it but It would be awesome if someone more familiar
> with the logic can go over that part.

Scrap that.  It triggered and yeah cfq_get_next_queue() is retrieving
empty cfqq from the service tree.

Thanks.

-- 
tejun
