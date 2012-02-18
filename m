Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab2BRDcC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 22:32:02 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41906 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab2BRDcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 22:32:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of namhyung@gmail.com designates 10.68.219.130 as permitted sender) smtp.mail=namhyung@gmail.com; dkim=pass header.i=namhyung@gmail.com
Subject: Re: [PATCH for-3.3/core] block: add missing block_bio_complete()
 tracepoint
From: Namhyung Kim <namhyung@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: dm-devel@redhat.com, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120217211958.GG29414@google.com>
References: <20120217211958.GG29414@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Feb 2012 12:31:54 +0900
Message-ID: <1329535914.1630.4.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-02-17, 13:19 -0800, Tejun Heo:
> bio completion didn't kick block_bio_complete TP.  Only dm was
> explicitly triggering the TP on IO completion.  This makes
> block_bio_complete TP useless for tracers which want to know about
> bios, and all other bio based drivers skip generating blktrace
> completion events.
> 
> This patch makes all bio completions via bio_endio() generate
> block_bio_complete TP.
> 
> * Explicit trace_block_bio_complete() invocation removed from dm and
>   the trace point is unexported.
> 
> * @rq dropped from trace_block_bio_complete().  bios may fly around
>   w/o queue associated.  Verifying and accessing the assocaited queue
>   belongs to TP probes.
> 
> * blktrace now gets both request and bio completions.  Make it ignore
>   bio completions if request completion path is happening.
> 
> This makes all bio based drivers generate blktrace completion events
> properly and makes the block_bio_complete TP actually useful.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Original-patch-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: dm-devel@redhat.com

Looks better to me, thanks. :)


-- 
Regards,
Namhyung Kim


