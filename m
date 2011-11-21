Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab1KUPhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:37:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:46121 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1KUPhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:37:31 -0500
Message-ID: <1321889842.28118.9.camel@twins>
Subject: Re: [RFC][PATCH 6/6] perf, tools: X86 RDPMC, RDTSC test
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@elte.hu, William Cohen <wcohen@redhat.com>,
        linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>
Date: Mon, 21 Nov 2011 16:37:22 +0100
In-Reply-To: <CABPqkBTg69-EzvtGVxdAuf=EvM6Maag_tGc_a7jE5LdMwDqRgw@mail.gmail.com>
References: <20111121145114.049265181@chello.nl>
	 <20111121145337.912104693@chello.nl>
	 <CABPqkBTg69-EzvtGVxdAuf=EvM6Maag_tGc_a7jE5LdMwDqRgw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 16:29 +0100, Stephane Eranian wrote:
> Peter,
> 
> I don't see how this test and infrastructure handles the case where the event
> is multiplexed. I know there is time_enabled and time_running. But those are
> not sync'd to the moment of the rdpmc(). I think there needs to be some other
> timestamp in the mmap struct so the user can compute a delta to then add to
> time_enabled and time_running.

When the counter isn't actually on the PMU, ->index will be 0 and rdpmc
should not be attempted.

> Unless, we assume the two time metrics are there ONLY to compute a scaling
> ratio. In which case, I think, we don't need the delta because if we
> can do rdpmc()
> it means the event is currently scheduled and thus time_enabled and time_running
> are both ticking which means the scaling ratio does not change since the moment
> the event was scheduled in.

Right, you don't need delta to compute the scale, but its useful for
user-space time based measurements, Arun wanted to do something like
that.

