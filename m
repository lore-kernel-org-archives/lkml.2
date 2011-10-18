Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab1JRS2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:28:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38483 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab1JRS2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:28:44 -0400
Subject: Re: perf tools: interface for improved PEBS ABI can accept wrong
 parameter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Xu, Anhua" <anhua.xu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 18 Oct 2011 20:28:21 +0200
In-Reply-To: <20111018181943.GC21666@elte.hu>
References: <1A42CE6F5F474C41B63392A5F80372B212DC93638A@shsmsx501.ccr.corp.intel.com>
	 <20111018181943.GC21666@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318962501.14880.6.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 20:19 +0200, Ingo Molnar wrote:
> > +#define SAMPLE_IP_MAX        3 
> >                               precise_ip     :  2, /* skid constraint       */
> >                               mmap_data      :  1, /* non-exec mmap data    */
> >                               sample_id_all  :  1, /* sample_type all events */
> > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> > index 928918b..a2068cc 100644
> > --- a/tools/perf/util/parse-events.c
> > +++ b/tools/perf/util/parse-events.c
> > @@ -775,7 +775,10 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
> >       attr->exclude_user   = eu;
> >       attr->exclude_kernel = ek;
> >       attr->exclude_hv     = eh;
> > -     attr->precise_ip     = precise;
> > +     if ( precise < SAMPLE_IP_MAX )
> > +             attr->precise_ip = precise;
> > +     else
> > +             return -1; 

That name is horrid, how about PRECISE_IP_MAX? Also, I suspect acme will
want a better error return than -1, but I'll leave that up to him.
