Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab1HJRRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 13:17:52 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56965 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab1HJRRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 13:17:50 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Alex Ray <alexjray.ncsu@gmail.com>, v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Ray <ajray@ncsu.edu>
Subject: Re: [PATCH] 9p: remove CONFIG_NET_9P_DEBUG option
In-Reply-To: <CAFkjPT=y4jJTNEFrJLr=i9UVHfixqqGmYbVZf0B4AHk-AmOJdA@mail.gmail.com>
References: <1312200884-20110-1-git-send-email-ajray@ncsu.edu> <877h6l7hoj.fsf@skywalker.in.ibm.com> <CAFkjPT=y4jJTNEFrJLr=i9UVHfixqqGmYbVZf0B4AHk-AmOJdA@mail.gmail.com>
User-Agent: Notmuch/0.5-318-g52e4ded (http://notmuchmail.org) Emacs/23.2.1 (x86_64-pc-linux-gnu)
Date: Wed, 10 Aug 2011 22:47:39 +0530
Message-ID: <87wrel5gp8.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 07:24:56 -0500, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> On Wed, Aug 10, 2011 at 4:13 AM, Aneesh Kumar K.V
> <aneesh.kumar@linux.vnet.ibm.com> wrote:
> >
> > On Mon,  1 Aug 2011 07:14:44 -0500, Alex Ray <alexjray.ncsu@gmail.com> wrote:
> >> Remove the CONFIG_NET_9P_DEBUG option, used to completely remove logging
> >> functionality from v9fs.  Logging is (already) controlled with the
> >> run-time debug= option, this gets rid of the compile-time option (which
> >> was being misunderstood and misused).
> >>
> >> Signed-off-by: Alex Ray <ajray@ncsu.edu>
> >
> > I see this merged to for-next.  Do we know whether enabling debug always have a
> > performance impact ?.
> >
> 
> No clue, but without any debug it makes it impossible for user's to
> generate reasonable bug reports.  If I understand the tracepoint
> collection facility correctly, it incurs exactly the same overhead as
> a DPRINT when the debug mount option is set to 0 (although tracepoints
> are much lower overhead when actually collecting).

I was worried about overhead when we are not collecting any debug info.

>  Now, one could
> make a case that we have too many DPRINT and need to cut back, but if
> that's the case, let's just get around to it and cleanup a bit.
> 
> All that being said, I welcome anyone to send me performance with and
> without CONFIG_NET_9P_DEBUG turned on to convince me differently.

With tracepoints we should not have much performance impact when tracing is
disabled. So may be the right way to go forward is to convert enough P9_DPRINT
to tracepoint that will aid in better debugging of errors, and retain
CONFIG_NET_9P_DEBUG as it is. 

I actually converted protocol dump to tracepoints. Other advantages 
of switching to tracepoints is the ability to get stack trace, 
filtering debug output per mount points, integration with perf tool.

I guess if we can list out which set of P9_DPRINTK will aid better
reporting of bugs then we can look at converting them to
tracepoints. Protocol dump was the immediate one which I found useful.

-aneesh
