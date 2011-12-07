Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1LGOOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:14:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773Ab1LGOOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:14:36 -0500
Date: Wed, 7 Dec 2011 12:14:09 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] perf tool: Unify handling of features when
	writing feature section
Message-ID: <20111207141409.GA14415@infradead.org>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com> <1323167560-2282-9-git-send-email-robert.richter@amd.com> <20111206133630.GI7059@infradead.org> <20111206163358.GL15738@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206163358.GL15738@erda.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 06, 2011 at 05:33:58PM +0100, Robert Richter escreveu:
> On 06.12.11 11:36:30, Arnaldo Carvalho de Melo wrote:
> > If you fix that please add this warning as well when no build-ids are
> > found, which hopefully is the odd case these days as all distros I'm
> > aware of have build-ids in all DSOs.
> 
> What about the following change in addition? perf record then still
> stops with an error, but --no-buildid could be used to proceed anyway:
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 766fa0a..80e08ca 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -493,6 +493,13 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>                         return err;
>         }
>  
> +       if (!no_buildid
> +           && !perf_header__has_feat(&session->header, HEADER_BUILD_ID)) {
> +               pr_err("Couldn't collect buildids. "
                         "Your report results may be misleading if profiled "
                         "DSOs changed after the record session.\n"
> +                      "Use --no-buildid option if you know that "
                         "there where no changes in the profiled DSOs.\n");
> +               return -1;
> +       }
> +
>         rec->post_processing_offset = lseek(output, 0, SEEK_CUR);

I can do these changes if you agree with this wording,

- Arnaldo
