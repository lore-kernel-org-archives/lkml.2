Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1ALPK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:10:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62424 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab1ALPK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:10:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IghxxZv1FuDrXajJhvMwyfspv6/xx9vdFNiaGrP/PfoUACLwkJZc1Lv3qYM4BbFPmT
         4I0d/qwshWKAuB1b15oKdrWhTnIqL+ZJFwgbaZKKqxSFhzCSdKETEiarK39ClM9dtsBd
         mdbyPuuIEtZSaKaqEpq/3YwvnNxOubbIjhScQ=
Date: Wed, 12 Jan 2011 16:10:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Smelkov <kirr@mns.spb.ru>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: Q: perf log mode?
Message-ID: <20110112151020.GB1755@nowhere>
References: <20110112140613.GA11698@tugrik.mns.mnsspb.ru>
 <1294841288.19601.49.camel@laptop>
 <20110112144240.GA1755@nowhere>
 <1294844021.19601.51.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294844021.19601.51.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 03:53:41PM +0100, Peter Zijlstra wrote:
> On Wed, 2011-01-12 at 15:42 +0100, Frederic Weisbecker wrote:
> > On Wed, Jan 12, 2011 at 03:08:08PM +0100, Peter Zijlstra wrote:
> > > On Wed, 2011-01-12 at 17:06 +0300, Kirill Smelkov wrote:
> > > > I'm trying to use perf together with e.g. kprobes as a tool to show what
> > > > is happening with my system in "live-log" mode. The problem is, for
> > > > seldom events, actual info output is largely delayed because perf reads
> > > > sample data in whole pages. Could something be done with it or am I'm
> > > > missing something? Here is detailed description: 
> > > 
> > > perf_event_attr = {
> > > 	.watermark = 0,
> > > 	.wakeup_events = 1,
> > > };
> > 
> > 
> > Which is perhaps something we want as a default when perf record -c 1
> > and the output is the pipe mode.
> 
> No, definitely not, esp for -c1 you want large buffers because the event
> can come at very high freq.

Right this should not be a default actually if we have high freq events
we don't want wake up at each of them.

> Nor does pipe mode have anything to do with it, the whole script set-up
> plain stinks 

Oh? What's wrong with the scripts infrastructure?

> and should not be using pipe mode, pipe mode should only be
> used to pipe data over the network and other remote profiling like
> things. 

But the scripts are just an endpoint over many other possibilities,
regardless of what is in the middle: perf.data or pipe streaming.

Where is a limitation on using scripts here?
