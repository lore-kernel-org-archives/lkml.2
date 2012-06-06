Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab2FFL5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 07:57:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34164 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2FFL5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 07:57:36 -0400
MIME-Version: 1.0
In-Reply-To: <1338980038.2749.97.camel@twins>
References: <20120605213527.GA5019@quad>
	<CABPqkBQkgSeRMtP9F61ckCaikFd_rUTQvF1NxB_DDQRugRRv3g@mail.gmail.com>
	<1338979012.2749.90.camel@twins>
	<1338980038.2749.97.camel@twins>
Date: Wed, 6 Jun 2012 13:57:35 +0200
Message-ID: <CABPqkBQKh9o_HqY_f4KBgafJi97vVcqX-JEpz2PY0bGqpWNmNQ@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Fix Intel shared extra MSR allocation
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, zheng.z.yan@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 12:53 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-06-06 at 12:36 +0200, Peter Zijlstra wrote:
>> On Wed, 2012-06-06 at 12:35 +0200, Stephane Eranian wrote:
>> > Ok, I found the problem. It was in intel_fixup_er().
>> > Unlike in the original code, this routine must update
>> > the event->extra_reg.idx to the idx parameter instead
>> > of trying to swap out from it.
>>
>> Ah indeed. Thanks!
>
>
> static void intel_fixup_er(struct perf_event *event, int idx)
> {
>        event->hw.extra_reg.idx = idx;
>
>        if (idx == EXTRA_REG_RSP_0) {
>                event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
>                event->hw.config |= 0x01b7;
>                event->hw.extra_reg.reg = MSR_OFFCORE_RSP_0;
>        } else if (idx == EXTRA_REG_RSP_1) {
>                event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
>                event->hw.config |= 0x01bb;
>                event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
>        }
> }
>
> Like that then?


Are you going to repost the update patch, or shall I?
