Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab2JTPEr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 11:04:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:34025 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab2JTPEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 11:04:46 -0400
Date: Sat, 20 Oct 2012 08:04:29 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/11] perf python: Link with libtraceevent
Message-ID: <20121020150429.GA27221@ghostprotocols.net>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
 <1350494387-10987-10-git-send-email-acme@infradead.org>
 <87y5j41rw5.fsf@sejong.aot.lge.com>
 <20121018140033.GC2057@infradead.org>
 <20121018143835.GE2057@infradead.org>
 <1350574827.1610.8.camel@leonhard>
 <20121020003556.GA15567@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121020003556.GA15567@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Oct 20, 2012 at 02:35:57AM +0200, Ingo Molnar escreveu:
> Even with that I'm getting:
> 
> util/python.c: In function ‘initperf’:
> util/python.c:1018:2: error: ‘page_size’ undeclared 
> (first use in this function)
> util/python.c:1018:2: note: each undeclared identifier is 
> reported only once for each function it appears in
> error: command 'gcc' failed with exit status 1

Yeah, there was another problem, a patch that makes sense only for
perf/core was added, I reverted it after Namhyung reported the same
problem:

commit 9cd938a4c3b908a3ff7ef65bdc432f1915361e87
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Thu Oct 18 10:51:08 2012 -0300

    Revert "perf python: Initialize 'page_size' variable"
    
    The commit that added the page_size variable is only in the perf/core
    branch, not needed for perf/urgent. Brown paper bag grade, sigh.
    
    This reverts commit 356712f6e296fdae1edae51b96b485ed830bdc0c.
    
    Reported-by: Namhyung Kim <namhyung@kernel.org>
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
