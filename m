Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab2A2TYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 14:24:53 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57601 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab2A2TYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 14:24:52 -0500
Date: Sun, 29 Jan 2012 11:24:47 -0800
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Message-ID: <20120129192447.GB17211@htj.dyndns.org>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 06:41:33PM +0900, Namhyung Kim wrote:
> The block_bio_complete() TP has been missed so long, so that bio-based
> drivers haven't been able to trace its IO behavior. Add it.
> 
> In some rare cases, such as loop_switch, @bio->bi_bdev can be NULL.
> Thus convert it to TRACE_EVENT_CONDITION() as Steven suggested.
> 
> From now on, request-based drivers will also get BLK_TA_COMPLETEs for
> all bio's in requests. This needs to be handled in userland properly.
> 
> Also remove external use of the TP in DM and unexport it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: dm-devel@redhat.com

I like the smiplicity change but do we know how we can filter this out
from userland?  Also, what's the reason not to do it from blktrace.c?
What would be the downside of doing that?

Thanks.

-- 
tejun
