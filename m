Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2DXRgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:36:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886Ab2DXRgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:36:01 -0400
Date: Tue, 24 Apr 2012 14:35:55 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] perf tools: Fix include header files in
 util/parse-events.h
Message-ID: <20120424173555.GD28056@infradead.org>
References: <1333643188-26895-1-git-send-email-robert.richter@amd.com>
 <1333643188-26895-2-git-send-email-robert.richter@amd.com>
 <20120424165344.GH9747@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120424165344.GH9747@erda.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Apr 24, 2012 at 06:53:44PM +0200, Robert Richter escreveu:
> On 05.04.12 18:26:25, Robert Richter wrote:
> > Include header fixes for
> > 
> > ... bool:
> > 
> >  util/parse-events.h:31: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘have_tracepoints’
> > 
> > ... and types.h:
> > 
> >  util/parse-events.h:28: error: expected ‘)’ before ‘config’
> >  util/parse-events.h:34: error: expected declaration specifiers or ‘...’ before ‘u64’
> >  util/parse-events.h:45: error: expected ‘)’ before ‘type’
> > 
> > This happens if now other include files are included before
> > util/parse-events.h.
> > 
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> 
> Arnaldo,
> 
> is it your intention that you didn't apply this patch?

Is this on perf/urgent or perf/core? In what system does this happen?

- Arnaldo
 
> Thanks,
> 
> -Robert
> 
> > ---
> >  tools/perf/util/parse-events.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> > index 6d7c74b..ab6ebe0 100644
> > --- a/tools/perf/util/parse-events.h
> > +++ b/tools/perf/util/parse-events.h
> > @@ -4,7 +4,9 @@
> >   * Parse symbolic events/counts passed in as options:
> >   */
> >  
> > +#include <stdbool.h>
> >  #include "../../../include/linux/perf_event.h"
> > +#include "types.h"
> >  
> >  struct list_head;
> >  struct perf_evsel;
> > -- 
> > 1.7.8.4
> > 
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
