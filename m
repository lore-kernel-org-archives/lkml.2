Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab0GRUGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 16:06:13 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39268 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757209Ab0GRUGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 16:06:13 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>, mingo@elte.hu,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/3] perf: Remove dead code in buildin-record.c
In-Reply-To: <87pqzd3jx5.fsf@linux-g6p1.site>
References: <4C241140.9090008@cn.fujitsu.com> <4C24119B.60200@cn.fujitsu.com>  <20100625131356.GB4078@ghostprotocols.net> <1277477285.32034.666.camel@twins> <87pqzd3jx5.fsf@linux-g6p1.site>
User-Agent: Notmuch/0.3.1-61-g3f63bb6 (http://notmuchmail.org) Emacs/23.1.90.2 (x86_64-unknown-linux-gnu)
Date: Sun, 18 Jul 2010 21:06:11 +0100
Message-ID: <87hbjwzhak.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jun 2010 16:14:46 +0100, Matt Fleming <matt@console-pimps.org> wrote:
> On Fri, 25 Jun 2010 16:48:05 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > Ah, yes, it would be nice for SH (which doesn't have a PMI) to couple a
> > software timer with their hardware counter to get samples.
> > 
> > Never got around to actually implementing that though, maybe Paul has a
> > minion interested in making that work?
> 
> I'll take a look at it.

How does the 'group_fd' parameter relate to the lack of PMI? Is the idea
to have one hrtimer that, when it fires, we sample all the counters? So
the first counter to be created is the group leader, which starts the
hrtimer, and all other counters are linked to this one? I had a go at
using a hrtimer per counter (minus any weighting of samples) and it
worked OK and seemed sensible given that we may want to sample counters
at different frequencies.

Is this what you had in mind with the 'group_fd' paramter, Peter? That
there'd be only one hrtimer?
