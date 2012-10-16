Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab2JPEhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:37:37 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56759 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab2JPEhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:37:36 -0400
Date: Tue, 16 Oct 2012 10:09:16 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hyeoncheol Lee <hyc.lee@gmail.com>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] perf probe: convert_name_to_addr() allocated the wrong
 size buffer for a function name
Message-ID: <20121016043916.GB28828@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1350351452-9737-1-git-send-email-hyc.lee@gmail.com>
 <507CE06D.8050806@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <507CE06D.8050806@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101604-5930-0000-0000-00000D1B6368
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> [2012-10-16 13:19:57]:

> (2012/10/16 10:37), Hyeoncheol Lee wrote:
> > convert_name_to_addr() allocated sizeof(char *) * MAX_PROBE_ARGS
> > bytes for a function name
> 
> Yeah, that one was from my laziness...
> 

Guess not your fault, but mine.

> > 
> > Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
> > ---
> >  tools/perf/util/probe-event.c |    5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> > index 49a256e..bb40ed4 100644
> > --- a/tools/perf/util/probe-event.c
> > +++ b/tools/perf/util/probe-event.c
> > @@ -2352,13 +2352,14 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
> >  		free(exec_copy);
> >  	}
> >  	free(pp->function);
> > -	pp->function = zalloc(sizeof(char *) * MAX_PROBE_ARGS);
> > +	pp->function = zalloc(sizeof(char) *
> > +			      (3 + sizeof(unsigned long long) * 2));
> 
> Could you comment that this is enough long here?

Also can we move the arith into a macro?

> 
> >  	if (!pp->function) {
> >  		ret = -ENOMEM;
> >  		pr_warning("Failed to allocate memory by zalloc.\n");
> >  		goto out;
> >  	}
> > -	e_snprintf(pp->function, MAX_PROBE_ARGS, "0x%llx", vaddr);
> > +	sprintf(pp->function, "0x%llx", vaddr);
> 
> And at least we should use snprintf instead of sprintf...
> (I think ret = e_snprintf(...) is better)
> 

Agree.

> >  	ret = 0;
> >  
> >  out:
> > 
> 

-- 
Thanks and Regards
Srikar

