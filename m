Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab2I0VbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:31:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37760 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab2I0VbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:31:09 -0400
Date: Thu, 27 Sep 2012 23:31:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCHv2 00/14] perf diff: Factor diff command
Message-ID: <20120927213102.GO16230@one.firstfloor.org>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 01:09:21PM +0200, Jiri Olsa wrote:
> hi,
> this is v2 of diff command changes proposed in here:
> https://lkml.org/lkml/2012/9/6/344
> 
> It's now rebased on new hists hpp* interface plus few
> more additional changes.

FWIW I've been playing around with it a bit. It seems useful
both for scaling problems and likely for performance regression tracking too.

Some minor issues I ran into (but no show stoppers):
- The error messages for bad -c expressions could be better
- I found the requirement for no space after -c unintuitive.
- It would be nice to have support for doing the bucketizing per line
instead of per function. With a large function and/or inlining 
it's sometimes hard to identify the actual problem
Acme recently added this for perf report.

I agree it would be good to merge.

-Andi
