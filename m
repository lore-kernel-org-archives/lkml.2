Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2H0WO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 18:14:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38191 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab2H0WO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 18:14:28 -0400
Date: Tue, 28 Aug 2012 00:14:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andrew Vagin <avagin@openvz.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/4] perf: teach perf inject to merge sched_stat_* and sched_switch events (v2)
Message-ID: <20120827221423.GE16230@one.firstfloor.org>
References: <1344344165-369636-1-git-send-email-avagin@openvz.org> <1344344165-369636-4-git-send-email-avagin@openvz.org> <m2ehms6ouh.fsf@firstfloor.org> <503BED07.9030404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503BED07.9030404@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 03:56:23PM -0600, David Ahern wrote:
> On 8/27/12 2:51 PM, Andi Kleen wrote:
> >Andrew Vagin <avagin@openvz.org> writes:
> >>
> >>My code saves sched_switch event for each process and when it meets
> >>stat_iowait, it reports the sched_switch event, because this event
> >>contains a correct callchain. By another words it replaces all
> >>stat_iowait events on proper sched_switch events.
> >
> >Is there any way to generalize this to arbitary events? I found myself
> >writing scripts to compute lengths between various events.  But I
> 
> You mean delta-time between events? I have toyed around with patches to 
> perf-script for this -- dt between same event on a cpu, dt between 
> consecutive events on a cpu, dt between events for a thread, etc.

I did the same. But I then realized perf script is the wrong approach. 
perf script is a deadend as far as perf is concerned.
You want a filter that generates another perf.data that you then can 
view in the browser. So perf inject is the better model.

-Andi
