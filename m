Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1IWVMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 17:12:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53096 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1IWVMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 17:12:33 -0400
Date: Fri, 23 Sep 2011 18:11:59 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Darren Hart <dvhart@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric B Munson <emunson@mgebm.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [GIT PULL 00/12] perf tools fixes
Message-ID: <20110923211158.GC27519@ghostprotocols.net>
References: <1316809586-28529-1-git-send-email-acme@infradead.org> <CA+55aFwVrvMa1z7P5q0kUN3QAwZzTdL1mhLaF7+etHYQm511vA@mail.gmail.com> <CA+55aFysPyDCjs3MTwHBRWVq5OTU=-aWCRiJP=VZL-EdCGNU0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFysPyDCjs3MTwHBRWVq5OTU=-aWCRiJP=VZL-EdCGNU0w@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 23, 2011 at 02:05:25PM -0700, Linus Torvalds escreveu:
> On Fri, Sep 23, 2011 at 2:03 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > But it obviously doesn't affect the kernel compile. It *does* affect
> > the perf tool compile, and util/python.c no longer compiles because
> > the byte-swap flag isn't passed to it.
> 
> This stupid patch makes it compile. But see the comment..

Yes, this is what I was going to push and will if you haven't already
done so, did you?
 
>                  Linus

>  tools/perf/util/python.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
> index cbc8f215d4b7..0d50277936f5 100644
> --- a/tools/perf/util/python.c
> +++ b/tools/perf/util/python.c
> @@ -803,7 +803,8 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
>  		first = list_entry(evlist->entries.next, struct perf_evsel, node);
>  		err = perf_event__parse_sample(event, first->attr.sample_type,
>  					       perf_evsel__sample_size(first),
> -					       sample_id_all, &pevent->sample);
> +					       sample_id_all, &pevent->sample,
> +					       0 /* really? */);
>  		if (err)
>  			return PyErr_Format(PyExc_OSError,
>  					    "perf: can't parse sample, err=%d", err);

