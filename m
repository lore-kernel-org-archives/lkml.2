Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386Ab2FHOix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:38:53 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58773 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760066Ab2FHOiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:38:50 -0400
Date: Fri, 8 Jun 2012 11:38:43 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, ak@linux.intel.com,
        Stephane Eranian <eranian@google.com>
Subject: Re: Does perf inject preserve call chain data?
Message-ID: <20120608143843.GA9954@infradead.org>
References: <1337712585.3796.186.camel@schen9-DESK>
 <4FBC0C10.8010801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBC0C10.8010801@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 22, 2012 at 03:58:40PM -0600, David Ahern escreveu:
> On 5/22/12 12:49 PM, Tim Chen wrote:
> >Arnaldo,
> >
> >Wonder if perf inject munged the call chain data from perf record?
> >
> >When I do
> >perf record -a -g -o - sleep 5 |perf inject -v -b  | perf report  -g -i -
> >I get a complain from perf report
> >
> >Warning:
> >Selected -g but no callchain data. Did you call 'perf record' without -g?
> >
> 
> I believe the root cause is that the event list is not written to
> the pipe. Using Arnaldo's git repo as of today (has fixes from
> Stephane) this hack shows the info is there and can be processed.

How things stand here? Tim, did this fix things for you? If so, David,
please resend with a proper subject line and a Tested-by: Tim, ok?

Thanks,

- Arnaldo
 
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index d58e414..60f3f17 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -256,7 +257,7 @@ static int perf_report__setup_sample_type(struct
> perf_report *rep)
>                     "'perf record' without -g?\n");
>             return -EINVAL;
>         }
> -       if (symbol_conf.use_callchain) {
> +       if (!self->fd_pipe && symbol_conf.use_callchain) {
>             ui__warning("Selected -g but no callchain data. Did "
>                     "you call 'perf record' without -g?\n");
>             return -1;
> 
> A proper solution is needed.
> 
> David
