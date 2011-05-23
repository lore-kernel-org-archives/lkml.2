Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1EWQWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:22:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:39129 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab1EWQV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:21:59 -0400
Subject: Re: [PATCH 3/3] perf_events: add Intel Sandy Bridge
 offcore_response low-level support (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
        ming.m.lin@intel.com
In-Reply-To: <20110523161256.GA11624@quad>
References: <20110523161256.GA11624@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 May 2011 18:21:27 +0200
Message-ID: <1306167687.18455.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 18:12 +0200, Stephane Eranian wrote:
> This patch adds Intel Sandy Bridge offcore_response support by
> providing the low-level constraint table for those events.
>     
> On Sandy Bridge, there are two offcore_response events. Each uses
> its own dedictated extra register. But those registers are NOT shared
> between sibling CPUs when HT is on unlike Nehalem/Westmere. They are
> always private to each CPU. But they still need to be controlled within
> an event group. All events within an event group must use the same
> value for the extra MSR. That's not controlled by the second patch in
> this series.
>     
> Furthermore on Sandy Bridge, the offcore_response events have NO
> counter constraints contrary to what the official documentation
> indicates, so drop the events from the contraint table.

You sending this suggests you actually have a SNB machine, do you also
happen to know how to use those SNB RSP MSRs? Lin Ming and I were
wondering how to fill out the extra-regs for
snb_hw_cache_events_jds[C(LL)].


