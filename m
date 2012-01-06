Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab2AFQdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 11:33:42 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:33124 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022Ab2AFQdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 11:33:41 -0500
Date: Fri, 6 Jan 2012 08:33:33 -0800
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET RESEND] ioblame: statistical IO analyzer
Message-ID: <20120106163333.GI6276@google.com>
References: <1325806974-23486-1-git-send-email-tj@kernel.org>
 <4F06B814.2000006@lge.com>
 <20120106160235.GH6276@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106160235.GH6276@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Fri, Jan 06, 2012 at 08:02:35AM -0800, Tejun Heo wrote:
> Hmmm... originally, I had variable length data structure there but now
> it's fixed so exposing them using tracepoint shouldn't be too
> difficult and could actually be better (previously it didn't really
> fit TP and ringbuffer should be used directly).  Yeah, that's a
> thought.  Generating a TP event per IO shouldn't be taxing and it
> would give much better visibility to userland and we can drop the
> whole statics configuration and stuff.  Enticing.  I'll think more
> about it.

The more I think about it, the better it seems.  I ended up putting
the statistics gathering inside the kernel mostly because the
information I had at IO completion wasn't too fit to export to
userland verbatim, but while iterating the implementation those parts
got chopped (it was necessary for statistics too anyway) and now it
seems I can just replace the whole thing with a single tracepoint and
drop the whole configurable statistics stuff along with act and its
reclaiming, and silly _bin interface.  That's just sweeet.  Someohw I
completely missed the transition of the information available at IO
completion.

I might be missing something important but will give it a shot and, if
it goes as expected, post updated series soon.

Thanks a lot for bringing it up. :)

-- 
tejun
