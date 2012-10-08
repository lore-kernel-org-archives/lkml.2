Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab2JHUyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:54:15 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:52286 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab2JHUyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:54:14 -0400
Message-ID: <50733D72.9010100@gmail.com>
Date: Mon, 08 Oct 2012 14:54:10 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        fweisbec@gmail.com, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: Re: [PATCH 12/12] perf kvm: add live mode
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com> <1349716656-48165-13-git-send-email-dsahern@gmail.com> <20121008203534.GF2631@ghostprotocols.net>
In-Reply-To: <20121008203534.GF2631@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/12 2:35 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Oct 08, 2012 at 11:17:36AM -0600, David Ahern escreveu:
> Overall it looks good, I like the fact you're not doing it the way perf
> script does, i.e. that "pipe mode" thing, more or less like I'm doing on
> 'perf trace', but I think this is the time to get rid of 'perf_session'
> too for this specific "live mode" tools.

pipe mode would never work for this case. I'm looking at nested virt 
case now and it shows 360,000 events per second.

> I'm almost getting there for 'trace' and 'top', just need to move the
> ordered_samples code to evlist, then session, top, trace, kvm live and
> script will not need to use 'perf_session' at all.

ok. you going to have that soon?

> Also that 'perf_kvm__open_counters' really is just a third copy of code
> in 'record' and 'top', right? You could move it to
> 'perf_ev{list,open}__open' and solve this dup :-)

there's a TO-DO at the top of that function for that reason ;-) I copied 
a fair bit from perf-stat. Now that it's working I can look at code 
consolidation.

> I applied the cleanups/simple stuff, will try to do some of the prep
> work on ordered_samples to use on top and trace and then I think you
> could look there so that we get to something that is useful for all
> these !perf.data tools.

On my Westmere based server I am not seeing problems with timestamps and 
ordering (prior testing was on a Nehalem based server). It just 
weathered a 5 minute or so barrage of > 100,000 events per second 
(peaking at around 360k events/sec) with no problem.

David
