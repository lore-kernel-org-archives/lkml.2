Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab0EKPN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:13:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:41028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab0EKPNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:13:24 -0400
Subject: Re: [RFC] perf: perf record sets inherit by default
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, perfmon2-devel@lists.sf.net
In-Reply-To: <20100511150052.GE19192@ghostprotocols.net>
References: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
	 <20100511150052.GE19192@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 17:13:20 +0200
Message-ID: <1273590800.1810.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 12:00 -0300, Arnaldo Carvalho de Melo wrote:
> 
> Humm, since for -C and -a using -i doesn't make sense, I guess it should
> be off by default and only be auto-activated if we don't specify any
> option, i.e. when using it like:
> 
> perf record ./hackbench
> 
> What do you think? 

-ENOPARSE

-a/-C usage creates per-cpu counters and will thus ignore any and all
perf_event_attr::inherit state.

Your above suggestion would still have inherit enabled by default, and
would thus not change anything.

The thing is that perf-record defaults to inherited per-task-per-cpu
counters, which, I think, is a reasonable default, just sub-optimal for
single threaded/!forking subjects.

So what would make sense is for -i to mean --no-inherit, and for !
inherit create a per-task counter instead of a per-task-per-cpu counter.

