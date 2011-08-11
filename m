Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab1HKPzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:55:07 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51657 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1HKPzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:55:04 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Eric Van Hensbergen <ericvh@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Alex Ray <alexjray.ncsu@gmail.com>, v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Ray <ajray@ncsu.edu>
Subject: Re: [PATCH] 9p: remove CONFIG_NET_9P_DEBUG option
In-Reply-To: <CAFkjPT=ePtKi0Z-AjBm_W38VPTV3HbT6hWSMHOHezytoqAbNvQ@mail.gmail.com>
References: <1312200884-20110-1-git-send-email-ajray@ncsu.edu> <877h6l7hoj.fsf@skywalker.in.ibm.com> <CAFkjPT=y4jJTNEFrJLr=i9UVHfixqqGmYbVZf0B4AHk-AmOJdA@mail.gmail.com> <87wrel5gp8.fsf@skywalker.in.ibm.com> <CAFkjPT=ePtKi0Z-AjBm_W38VPTV3HbT6hWSMHOHezytoqAbNvQ@mail.gmail.com>
User-Agent: Notmuch/0.5-318-g52e4ded (http://notmuchmail.org) Emacs/23.2.1 (x86_64-pc-linux-gnu)
Date: Thu, 11 Aug 2011 21:24:16 +0530
Message-ID: <87k4ak54gn.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 13:36:52 -0500, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> On Wed, Aug 10, 2011 at 12:17 PM, Aneesh Kumar K.V
> <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > On Wed, 10 Aug 2011 07:24:56 -0500, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> >> On Wed, Aug 10, 2011 at 4:13 AM, Aneesh Kumar K.V
> >> <aneesh.kumar@linux.vnet.ibm.com> wrote:
> >> > On Mon,  1 Aug 2011 07:14:44 -0500, Alex Ray <alexjray.ncsu@gmail.com> wrote:
> >> >> Remove the CONFIG_NET_9P_DEBUG option, used to completely remove logging
> >> >> functionality from v9fs.  Logging is (already) controlled with the
> >> >> run-time debug= option, this gets rid of the compile-time option (which
> >> >> was being misunderstood and misused).
> >> >>
> >> >> Signed-off-by: Alex Ray <ajray@ncsu.edu>
> >> >
> >> > I see this merged to for-next.  Do we know whether enabling debug always have a
> >> > performance impact ?.
> >> >
> >>
> >> No clue, but without any debug it makes it impossible for user's to
> >> generate reasonable bug reports.  If I understand the tracepoint
> >> collection facility correctly, it incurs exactly the same overhead as
> >> a DPRINT when the debug mount option is set to 0 (although tracepoints
> >> are much lower overhead when actually collecting).
> >
> > I was worried about overhead when we are not collecting any debug info.
> >
> 
> I understand that.  But the overhead when not collecting is the
> conditional branch.
> According to Documentation/trace/tracepoints.txt this is the same for the
> tracepoints:
> 
> "When a tracepoint is "off" it has no effect, except for adding a tiny
> time penalty
> (checking a condition for a branch) and space penalty (adding a few
> bytes for the function call at the end of the instrumented function
> and adds a data structure in a separate section)."
> 
> So, since DPRINT is essentially if(p9_debug_level & level) == level)
> it should roughly amount to the same overhead, no?  I suppose we could
> get fancy and and prefix it with an unlikely.
> 

Is that true with jump label ? May be we should update tracepoints.txt ?

Upstream commit:
bf5438fca2950b03c21ad868090cc1a8fcd49536
8f7b50c514206211cc282a4247f7b12f18dee674

-aneesh
