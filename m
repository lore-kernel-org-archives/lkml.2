Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab2JHVoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:44:46 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56623 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2JHVon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:44:43 -0400
Date: Mon, 8 Oct 2012 14:44:39 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        fweisbec@gmail.com, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: Re: [PATCH 12/12] perf kvm: add live mode
Message-ID: <20121008214439.GM2631@ghostprotocols.net>
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
 <1349716656-48165-13-git-send-email-dsahern@gmail.com>
 <20121008203534.GF2631@ghostprotocols.net>
 <50733D72.9010100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50733D72.9010100@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 08, 2012 at 02:54:10PM -0600, David Ahern escreveu:
> On 10/8/12 2:35 PM, Arnaldo Carvalho de Melo wrote:
> >Em Mon, Oct 08, 2012 at 11:17:36AM -0600, David Ahern escreveu:
> >Overall it looks good, I like the fact you're not doing it the way perf
> >script does, i.e. that "pipe mode" thing, more or less like I'm doing on
> >'perf trace', but I think this is the time to get rid of 'perf_session'
> >too for this specific "live mode" tools.
 
> pipe mode would never work for this case. I'm looking at nested virt
> case now and it shows 360,000 events per second.

Right, 'pipe mode' is an interesting construct, but its too inneficient
for same machine record/report, and for networking one we need to have
splice/sendfile, i.e. feed a socket directly in the kernel with what we
stash in mmap.
 
> >I'm almost getting there for 'trace' and 'top', just need to move the
> >ordered_samples code to evlist, then session, top, trace, kvm live and
> >script will not need to use 'perf_session' at all.
> 
> ok. you going to have that soon?

I hope to have it by the end of this week, perhaps earlier.
 
> >Also that 'perf_kvm__open_counters' really is just a third copy of code
> >in 'record' and 'top', right? You could move it to
> >'perf_ev{list,open}__open' and solve this dup :-)
> 
> there's a TO-DO at the top of that function for that reason ;-) I
> copied a fair bit from perf-stat. Now that it's working I can look
> at code consolidation.

Ok, just scratching again an old itch :-)
 
> >I applied the cleanups/simple stuff, will try to do some of the prep
> >work on ordered_samples to use on top and trace and then I think you
> >could look there so that we get to something that is useful for all
> >these !perf.data tools.
> 
> On my Westmere based server I am not seeing problems with timestamps
> and ordering (prior testing was on a Nehalem based server). It just
> weathered a 5 minute or so barrage of > 100,000 events per second
> (peaking at around 360k events/sec) with no problem.

Interesting, but does this involves consuming samples from multiple
CPUs?

- Arnaldo
