Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab1KGO5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:57:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36579 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1KGO5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:57:13 -0500
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, robert.richter@amd.com, mingo@elte.hu,
        ming.m.lin@intel.com, ak@linux.intel.com
Date: Mon, 07 Nov 2011 15:56:10 +0100
In-Reply-To: <CABPqkBREaQJk2gK7_Q5zUQhvV=EoxE1__ADw5VsiF-YPQNzeKw@mail.gmail.com>
References: <20111107110149.GA5177@quad> <1320667833.18053.24.camel@twins>
	 <CABPqkBREaQJk2gK7_Q5zUQhvV=EoxE1__ADw5VsiF-YPQNzeKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320677770.18053.51.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 13:52 +0000, Stephane Eranian wrote:
> But given we limit the number of events to that of counters,
> we do have O(c^3). 

Right, but SNB without HT gives you 8 GP counters, yielding a rather big
number. Suppose you're trying to fill it with 9 cycle events (1 for the
fixed purpose thingy), that'll end up being: 9^3 = 729 = big number.

(arguably adding 9 cycle counters is a tad retarded, but hey ;-)

It would be good to try and get it down to somewhere near 81 again,
although my brain isn't currently providing any sane ideas on how.

> As for the map_idx, it's there to track the position of each event in the
> initial event list. We shuffle events between constrained and unconstrained.
> By stashing the map_idx in the hw_perf_event struct we avoid having to
> pass around yet another array.

Yeah, I saw why you needed it..
