Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1CPOQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:16:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab1CPOQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:16:39 -0400
Date: Wed, 16 Mar 2011 11:16:15 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf probe: Clean up probe_point_lazy_walker()
	return value
Message-ID: <20110316141615.GA20706@ghostprotocols.net>
References: <new-submission> <tip-5e814dd597c42daeb8d2a276e64a6ec986ad0e2a@git.kernel.org> <1300262357.2250.58.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300262357.2250.58.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 16, 2011 at 08:59:17AM +0100, Peter Zijlstra escreveu:
> On Tue, 2011-03-15 at 23:18 +0000, tip-bot for Ingo Molnar wrote:
> 
> > perf probe: Clean up probe_point_lazy_walker() return value
> 
> > --- a/tools/perf/util/probe-finder.c
> > +++ b/tools/perf/util/probe-finder.c
> > @@ -1328,7 +1328,7 @@ static int probe_point_lazy_walker(const char *fname, int lineno,
> >  	 * Continue if no error, because the lazy pattern will match
> >  	 * to other lines
> >  	 */
> > -	return ret < 0 ?: 0;
> > +	return ret < 0 ? ret : 0;
> >  }
> 
> It is a slight change in semantics though, the return value will now be
> negative instead of 1. If its used as a boolean that's fine, but still.
> 
> I'd have changed it to:
> 
>   return ret < 0;
> 
> Which is identical to the previous statement.

Looks similar to the problem fixed in:

fbee632d0ca9f4073a3fefb9a843eac8af036b0f

for another function, I bet the intent in both cases was to return ret,
i.e. the negative value.

- Arnaldo
