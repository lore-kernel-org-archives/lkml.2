Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030464Ab2AFQCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 11:02:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52509 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030430Ab2AFQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 11:02:42 -0500
Date: Fri, 6 Jan 2012 08:02:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dsharp@google.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET RESEND] ioblame: statistical IO analyzer
Message-ID: <20120106160235.GH6276@google.com>
References: <1325806974-23486-1-git-send-email-tj@kernel.org>
 <4F06B814.2000006@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F06B814.2000006@lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Namhyung.

On Fri, Jan 06, 2012 at 06:00:04PM +0900, Namhyung Kim wrote:
> BTW, it seems the ioblame based on event tracing feature, so
> couldn't it be implemented in userspace with the help of the
> tracepoints and additional information (e.g. intent, ...) you add?
> The perf can deal with them and extend post-processing capability
> easily, and also might reduce some kernel jobs, I guess.

Yeah, it uses tracepoints to gather information it needs, but
producing relevant information (like the intent id) requires
nontrivial state tracking.  The point where it would make sense to
push to userland is the iolog, where all the relevant information has
been gathered for each IO.  Currently, the export interface there is
pretty dumb and slow.

Hmmm... originally, I had variable length data structure there but now
it's fixed so exposing them using tracepoint shouldn't be too
difficult and could actually be better (previously it didn't really
fit TP and ringbuffer should be used directly).  Yeah, that's a
thought.  Generating a TP event per IO shouldn't be taxing and it
would give much better visibility to userland and we can drop the
whole statics configuration and stuff.  Enticing.  I'll think more
about it.

Thanks.

-- 
tejun
