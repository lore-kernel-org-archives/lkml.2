Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0LWNi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 08:38:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32788 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0LWNi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 08:38:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t1UjTQWXJvQkeTd/ZTA7O+xKcH0edoJKxcSu8Z5NU13acd0/MQXld4afMhEo+pNAj9
         DHjn47eX7m3oGubmU6ytg5uIEDDfy1qcTjVLX6NAM56QY9OeKHIy8AnB5fQq7YcEBThu
         SsW2geRG6f79n9LViEBS0abpqvAjBbUvJk4IU=
Date: Thu, 23 Dec 2010 14:35:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: buggy perf callgraph output
Message-ID: <20101223133525.GC1769@nowhere>
References: <20101208164015.GA5444@amd>
 <20101208214809.GG1709@nowhere>
 <20101215130245.GA10004@amd>
 <20101216114755.GA1687@nowhere>
 <20101217053258.GC3282@amd>
 <20101223125535.GA1769@nowhere>
 <20101223130820.GA7680@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101223130820.GA7680@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 02:08:20PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Fri, Dec 17, 2010 at 04:32:58PM +1100, Nick Piggin wrote:
> > > That would be great, thanks! It's a really awesome tool, I appreciate
> > > your effort on it.
> > 
> > Thanks :)
> > 
> > So the below patch should fix the issue. Tell me if you encounter it
> > again, or anything else.
> > 
> > diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> > index d503670..c749ba6 100644
> > --- a/tools/perf/util/hist.c
> > +++ b/tools/perf/util/hist.c
> > @@ -356,7 +356,7 @@ static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask,
> >  
> >  static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
> >  				     int depth, int depth_mask, int period,
> > -				     u64 total_samples, int hits,
> > +				     u64 total_samples, u64 hits,
> >  				     int left_margin)
> 
> Hmm ... nice fix but why didnt GCC warn about the loss of half of the 'cumul' bits 
> in this call:
> 
>                         ret += ipchain__fprintf_graph(fp, chain, depth,
>                                                       new_depth_mask, i++,
>                                                       new_total,
>                                                       cumul,
>                                                       left_margin);
> 
> We really, really want GCC to warn about this - it's such a common mistake. What 
> disabled that warning? Very weird.

No idea. I thought perf had that in its warning arsenal :)

> 
> Thanks,
> 
> 	Ingo
