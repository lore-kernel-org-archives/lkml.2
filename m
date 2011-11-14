Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab1KNQAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 11:00:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:37120 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab1KNQAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 11:00:30 -0500
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Date: Mon, 14 Nov 2011 17:00:06 +0100
In-Reply-To: <CABPqkBSc-o+ysZEVx72acE7+AY8fLR8sqFDedKBwh8H60Z77cQ@mail.gmail.com>
References: <20111107110149.GA5177@quad>
	 <20111110180308.GD15738@erda.amd.com>
	 <CABPqkBSyYjM7V8cy--WRBHJ8o9TU9WUD9mGE1E5HntYdm2BHyw@mail.gmail.com>
	 <1321279937.1421.18.camel@twins>
	 <CABPqkBSc-o+ysZEVx72acE7+AY8fLR8sqFDedKBwh8H60Z77cQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321286406.1421.30.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 15:26 +0100, Stephane Eranian wrote:
> There is an edge from the source to all the events.
> There is an edge from all the counters to the sync.
> There is an edge between an event and a counter, if
> it can count the event.
> 
> The capacity of any edge is 1. 

Ah indeed.

So that gives: 

 E = e+e*c+c ~= O(c^2); since e<=c
 V = 2+e+c   ~= O(c)

Then going by:

http://en.wikipedia.org/wiki/Maximum_flow_problem

we have to stay away from Edmonds-Karp.

Ford-Fulkerson would end up being O(E * c) = O(c^3), since max |f| is c.
Which is pretty much identical to all these O(V^2 E) = O(c^3) as well.

Dinitz blocking flow with dynamic trees looks more interesting at O(c^2
log(c)). Push relabel with dynamic trees looks to be best at O(c^2),
since V^2/E ends up being c^2/c^2 = 1.

Creating the graph itself will be O(c^2) as well, due to E.


