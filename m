Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0IVQo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:44:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:34117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab0IVQoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:44:25 -0400
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jean Pihet <jean.pihet@newoldbits.com>, Thomas Renninger <trenn@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
In-Reply-To: <4C9A2FB3.105@linux.intel.com>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
	 <201009171736.14170.trenn@suse.de>	<20100917162412.GB3341@elte.hu>
	 <201009180026.59482.trenn@suse.de>
	 <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>
	 <4C9A21AD.1000800@linux.intel.com>
	 <AANLkTim6B+Je=LykgJb9=0vK5Br1rkft619BRJkBcHdP@mail.gmail.com>
	 <4C9A2FB3.105@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Sep 2010 18:43:55 +0200
Message-ID: <1285173835.2275.1026.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 09:32 -0700, Arjan van de Ven wrote:
> > What are the apps that are using it? I know about builtin-timechart,
> > pytimechart. Is powertop using this as well?
> 
> powertop 2.x codebase is as well.
> 
> and a bunch of tools we have internal here at Intel.
> 
> the thing with ABIs is that you don't know how many users you have.. at 
> least here you know the lower bound is 3 different tools that are open 
> source.
> .... and likely many local tools that aren't.

These tools should be smart enough to look up the tracepoint name, fail
it its not available, read the tracepoint format, again fail if not
compatible.

I really object to treating tracepoints as ABI and being tied to any
implementation details due to that.

Tools really should be flexible and allow for change.
