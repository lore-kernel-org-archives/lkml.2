Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab2I1PVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:21:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:34566 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758388Ab2I1PVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:21:45 -0400
Message-ID: <1348845667.3292.86.camel@twins>
Subject: Re: [PATCH 02/31] perf, x86: Basic Haswell PMU support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, acme@redhat.com, x86@kernel.org
Date: Fri, 28 Sep 2012 17:21:07 +0200
In-Reply-To: <CABPqkBQ90Crh+EpRQq0Y+xUvrj5vzrX_=SpJQyR4p8uFR_Hr=Q@mail.gmail.com>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	 <1348806696-31170-3-git-send-email-andi@firstfloor.org>
	 <1348823145.3292.62.camel@twins>
	 <20120928145842.GS16230@one.firstfloor.org>
	 <CABPqkBQ90Crh+EpRQq0Y+xUvrj5vzrX_=SpJQyR4p8uFR_Hr=Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 17:14 +0200, Stephane Eranian wrote:
> But then what happens if I pass a raw value that sets those bits on a
> processor without TSX?

We could filter those bits depending on cpu_has_rtm && cpu_has_hle on
event creation.

But fixed event constraints could include superfluous bits just fine,
they'll never appear.
