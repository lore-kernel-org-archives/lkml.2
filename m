Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab1KJSmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:42:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39713 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab1KJSmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:42:11 -0500
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Date: Thu, 10 Nov 2011 19:41:59 +0100
In-Reply-To: <20111110180308.GD15738@erda.amd.com>
References: <20111107110149.GA5177@quad>
	 <20111110180308.GD15738@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320950519.13800.41.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 19:03 +0100, Robert Richter wrote:
> But this algorithm does not work for all cases and does not solve the
> problem in general. 

Yeah, the problem in general is O(n!) no O(n^3) algorithm can compute
the optimal solution for n>3 or so.

I think the goal is to keep the 'normal' case O(n^2) but try and suck
less for the corner cases without degenerating into a full blown O(n!).

So I think we want an amortized O(n^2) with an upper bound well below
O(n!).
