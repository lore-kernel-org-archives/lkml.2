Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab1LGOgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:36:11 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:6400
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756241Ab1LGOgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:36:09 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz1432N98dK4015Lzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVU8K2-02-GQM-02
X-M-MSG: 
Date: Wed, 7 Dec 2011 15:35:46 +0100
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] perf tool: Unify handling of features when writing
 feature section
Message-ID: <20111207143546.GY15738@erda.amd.com>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
 <1323167560-2282-9-git-send-email-robert.richter@amd.com>
 <20111206133630.GI7059@infradead.org>
 <20111206163358.GL15738@erda.amd.com>
 <20111207141409.GA14415@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111207141409.GA14415@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.12.11 12:14:09, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 06, 2011 at 05:33:58PM +0100, Robert Richter escreveu:
> > On 06.12.11 11:36:30, Arnaldo Carvalho de Melo wrote:
> > > If you fix that please add this warning as well when no build-ids are
> > > found, which hopefully is the odd case these days as all distros I'm
> > > aware of have build-ids in all DSOs.
> > 
> > What about the following change in addition? perf record then still
> > stops with an error, but --no-buildid could be used to proceed anyway:
> > 
> > diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> > index 766fa0a..80e08ca 100644
> > --- a/tools/perf/builtin-record.c
> > +++ b/tools/perf/builtin-record.c
> > @@ -493,6 +493,13 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
> >                         return err;
> >         }
> >  
> > +       if (!no_buildid
> > +           && !perf_header__has_feat(&session->header, HEADER_BUILD_ID)) {
> > +               pr_err("Couldn't collect buildids. "
>                          "Your report results may be misleading if profiled "
>                          "DSOs changed after the record session.\n"
> > +                      "Use --no-buildid option if you know that "
>                          "there where no changes in the profiled DSOs.\n");
> > +               return -1;
> > +       }
> > +
> >         rec->post_processing_offset = lseek(output, 0, SEEK_CUR);
> 
> I can do these changes if you agree with this wording,

Yes, I am fine with it.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

