Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0IAR3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:29:47 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51455 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab0IAR3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:29:46 -0400
Date: Wed, 1 Sep 2010 13:16:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Neil Brown <neilb@suse.de>,
        "ksummit-2010-discuss@lists.linux-foundation.org" 
	<ksummit-2010-discuss@lists.linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] ring-buffer: Place duplicate expression into a
 single function
Message-ID: <20100901171622.GE2486@tuxdriver.com>
References: <AANLkTinCaKNXadoTtOvBhO3K5mOyzHi=ZJw4guWWB1W6@mail.gmail.com>
 <20100826210328.4ccd5aaf@notabene>
 <1283220647.1377.69.camel@gandalf.stny.rr.com>
 <20100831132708.GA2484@tuxdriver.com>
 <1283263428.2945.83.camel@powerslave>
 <20100901080715.5834450d@notabene>
 <1283295699.1377.732.camel@gandalf.stny.rr.com>
 <20100901133653.GB2486@tuxdriver.com>
 <1283351527.2356.22.camel@gandalf.stny.rr.com>
 <1283359792.2356.39.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283359792.2356.39.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 12:49:52PM -0400, Steven Rostedt wrote:
> 
> Ingo,
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Steven Rostedt (1):
>       ring-buffer: Place duplicate expression into a single function
> 
> ----
>  kernel/trace/ring_buffer.c |   21 +++++++++++++++------
>  1 files changed, 15 insertions(+), 6 deletions(-)
> ---------------------------
> commit f6195aa09e618d712f52bf4fa33b5293820eb93d
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Wed Sep 1 12:23:12 2010 -0400
> 
>     ring-buffer: Place duplicate expression into a single function
>     
>     While discussing the strictness of the 80 character limit on the
>     Kernel Summit Discussion mailing list, I showed examples that I
>     broke that limit slightly with some algorithms. In discussing with
>     John Linville, what looked better, I realized that two of the
>     80 char breaking culprits were an identical expression.
>     
>     As a clean up, this patch moves the identical expression into its
>     own helper function and that is used instead. As a side effect,
>     the offending code is now under the 80 character limit. :-)
>     
>     This clean up code also changes the expression from
>     
>     	(A - B) - C  to  A - (B + C)
>     
>     This makes the code look a little nicer too.
>     
>     Cc: John W. Linville <linville@tuxdriver.com>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

ACK :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
