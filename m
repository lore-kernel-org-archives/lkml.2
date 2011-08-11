Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1HKLoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:44:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59038 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab1HKLoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 07:44:25 -0400
Subject: Re: [PATCH] perf: provide PMU when initing events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Thu, 11 Aug 2011 13:43:57 +0200
In-Reply-To: <1313062280-19123-1-git-send-email-mark.rutland@arm.com>
References: <1313062280-19123-1-git-send-email-mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313063037.4709.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 12:31 +0100, Mark Rutland wrote:
> Currently, an event's 'pmu' field is set after pmu::event_init() is
> called. This means that pmu::event_init() must figure out which struct
> pmu the event was initialised from. This makes it difficult to
> consolidate common event initialisation code for similar PMUs, and
> very difficult to implement drivers for PMUs which can have multiple
> instances (e.g. a USB controller PMU, a GPU PMU, etc).
> 
> This patch sets the 'pmu' field before initialising the event, allowing
> event init code to identify the struct pmu instance easily. In the
> event of failure to initialise an event, the event is destroyed via
> kfree() without calling perf_event::destroy(), so this shouldn't
> result in bad behaviour even if the destroy field was set before
> failure to initialise was noted.

I thought there was a reason for things being the way they are, but
since I can't seem to recollect and your argument does make sense to me
I've merged it.

Thanks!
