Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2A3RF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:05:57 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37485 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2A3RF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:05:56 -0500
Date: Mon, 30 Jan 2012 09:05:48 -0800
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Message-ID: <20120130170548.GA3355@google.com>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
 <4F263B01.4050103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F263B01.4050103@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 03:38:57PM +0900, Namhyung Kim wrote:
> 2012-01-29 6:41 PM, Namhyung Kim wrote:
> >The block_bio_complete() TP has been missed so long, so that bio-based
> >drivers haven't been able to trace its IO behavior. Add it.
> >
> >In some rare cases, such as loop_switch, @bio->bi_bdev can be NULL.
> >Thus convert it to TRACE_EVENT_CONDITION() as Steven suggested.
> >
> 
> Now I see that it seems TRACE_EVENT_CONDITION() can protect event
> tracing from such condition, but what about other users of the TP
> like blktrace? I think it'll still get NULL pointer dereference on
> bdev_get_queue() after the change, right? If so, convert to T_E_C()
> looks meaningless IMHO. Do I miss something?

Not really following, but the whole point of using
TRACE_EVENT_CONDITION() is avoiding the conditional jump when the TP
is disabled.  Whether the TP users need to test again / more isn't too
important.

Thanks.

-- 
tejun
