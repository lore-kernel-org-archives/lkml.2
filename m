Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab2BOPbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:31:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:42292 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2BOPbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:31:00 -0500
Message-ID: <1329319837.2293.143.camel@twins>
Subject: Re: [PATCH] x86, AMD: Set sched_clock_stable
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Venki Pallipadi <venki@google.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Wed, 15 Feb 2012 16:30:37 +0100
In-Reply-To: <1328616532-13783-1-git-send-email-bp@alien8.de>
References: <20120207095000.GF15359@elte.hu>
	 <1328616532-13783-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 13:08 +0100, Borislav Petkov wrote:
> Stephane Eranian reported that doing a scheduler latency measurements
> with perf on AMD doesn't work out as expected due to the fact that the
> sched_clock() granularity is too coarse, i.e. done in jiffies due to the
> sched_clock_stable not set, which, if set, would mean that we get to use
> the TSC as sample source which would give us much higher precision.

FWIW that's not entirely accurate, the problem with !sched_clock_stable
is that the time between CPUs can drift a little. So while timestamps on
the same CPU are high-res, when comparing them across CPUs you can
observe funnies.


