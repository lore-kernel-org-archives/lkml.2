Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab2CYPaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 11:30:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:49132 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406Ab2CYPa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 11:30:29 -0400
Date: Sun, 25 Mar 2012 12:30:11 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, tool: Fix the array pointer to follow event data
 properly
Message-ID: <20120325153011.GF25820@infradead.org>
References: <1332598796-3586-1-git-send-email-jolsa@redhat.com>
 <4F6DEF86.7050303@gmail.com>
 <CABPqkBR+SOVzKjaP4oiapPbS2x+pheooVF=6qL15VVG=KuFYyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBR+SOVzKjaP4oiapPbS2x+pheooVF=6qL15VVG=KuFYyw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Mar 24, 2012 at 06:21:05PM +0100, Stephane Eranian escreveu:
> Yes, and I haven't heard back since then
> 
> On Sat, Mar 24, 2012 at 5:00 PM, David Ahern <dsahern@gmail.com> wrote:
> > Stephane submitted a similar patch a week ago:
> > https://lkml.org/lkml/2012/3/17/91


Gack, I updated one of my machines and the postfix setup had some issues
with SELinux.

Yeah, I noticed its the same fix Stephane submitted last week and that I
should have already sent Ingo's way.

Ingo, please apply the one from Stephane, next time I process it if you
haven't yet I'll make sure it gets pushed.

- Arnaldo

> > David
> >
> >
> > On 3/24/12 8:19 AM, Jiri Olsa wrote:
> >>
> >> Currently we dont update the 'array' pointer properly after
> >> processing the RAW data. This way perf might report wrong data
> >> for branch stack if it is used along with tracepoint sample.
> >>
> >> I'm not sure tracepoint could be connected with branch stack,
> >> but I think the array pointer should have correct value after
> >> each sample processing.
> >>
> >> Signed-off-by: Jiri Olsa<jolsa@redhat.com>
> >> ---
> >>  tools/perf/util/evsel.c |    1 +
> >>  1 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> >> index d9da62a..56a96896 100644
> >> --- a/tools/perf/util/evsel.c
> >> +++ b/tools/perf/util/evsel.c
> >> @@ -580,6 +580,7 @@ int perf_event__parse_sample(const union perf_event
> >> *event, u64 type,
> >>                        return -EFAULT;
> >>
> >>                data->raw_data = (void *) pdata;
> >> +               array = (u64 *)(((char *)array) + data->raw_size +
> >> sizeof(u32));
> >>        }
> >>
> >>        if (type&  PERF_SAMPLE_BRANCH_STACK) {
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
