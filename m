Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1KNWRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 17:17:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37448 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab1KNWRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 17:17:13 -0500
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Date: Mon, 14 Nov 2011 23:16:48 +0100
References: <20111107110149.GA5177@quad>
	 <20111110180308.GD15738@erda.amd.com>
	 <CABPqkBSyYjM7V8cy--WRBHJ8o9TU9WUD9mGE1E5HntYdm2BHyw@mail.gmail.com>
	 <1321279937.1421.18.camel@twins>
	 <CABPqkBSc-o+ysZEVx72acE7+AY8fLR8sqFDedKBwh8H60Z77cQ@mail.gmail.com>
	 <1321286406.1421.30.camel@twins>
	 <CABPqkBTJU5PWpLq3en3sECiAK2AvgLoR+AVqRoZmfNpp_bM_Ug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321309008.1421.50.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 22:43 +0100, Peter Zijlstra wrote:
> 
> Also, we don't need an exhaustive max flow solution, any flow that's
> high enough to fit the required capacity will do, this too could
> possibly be used to lower the (average) complexity bound.

I think that for the typically very dense graphs this in particular
could be very helpful in keeping the actual runtime low. For a fully
connected e*c it really doesn't matter how you program things, all flows
will have the same max and iterating them all is just wasting time.

We just need to figure out which of the many different algorithms are
best on average for our particular constraint sets.
