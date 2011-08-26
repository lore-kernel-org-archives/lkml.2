Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab1HZMNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:13:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34582 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1HZMNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:13:18 -0400
Subject: Re: [BUG] perf_event: semantic of PERF_SAMPLE_READ unclear
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        Robert Richter <robert.richter@amd.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>
Date: Fri, 26 Aug 2011 14:13:01 +0200
In-Reply-To: <CABPqkBSaW3ShYbJoO6YdFpZ7Rt+OfszP8m-uLSoBjCWZYVQ0Bw@mail.gmail.com>
References: <CABPqkBS_Og3Vbe90xwyzA8S5ftfF08gMtJdtpqQTHFOwm+CAkg@mail.gmail.com>
	 <1314293560.27911.38.camel@twins>
	 <CABPqkBSaW3ShYbJoO6YdFpZ7Rt+OfszP8m-uLSoBjCWZYVQ0Bw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314360781.11049.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 14:02 +0200, Stephane Eranian wrote:
> On Thu, Aug 25, 2011 at 7:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2011-08-25 at 19:19 +0200, Stephane Eranian wrote:
> >> But the difficulty is that
> >> we cannot grab any locks, not sure we need one given the call path.
> >
> > Nah we should be able to simply iterate all siblings and update them
> > in-place, since its group members they should all be co-scheduled. The
> > only difficulty is cross pmu group members..
> >
> Are we allowing event from different PMU to be in the same event group?
> If so, is that useful?

We allow software events, which can always be scheduled, to be part of a
hardware group. We don't allow mixing of different hardware pmus.

Allowing a software event is useful if for example the hardware pmu
doesn't have a sampling interrupt.


