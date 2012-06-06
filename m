Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2FFKyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:54:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:33404 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab2FFKyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:54:05 -0400
Message-ID: <1338980038.2749.97.camel@twins>
Subject: Re: [PATCH] perf, x86: Fix Intel shared extra MSR allocation
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, zheng.z.yan@linux.intel.com
Date: Wed, 06 Jun 2012 12:53:58 +0200
In-Reply-To: <1338979012.2749.90.camel@twins>
References: <20120605213527.GA5019@quad>
	 <CABPqkBQkgSeRMtP9F61ckCaikFd_rUTQvF1NxB_DDQRugRRv3g@mail.gmail.com>
	 <1338979012.2749.90.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 12:36 +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-06 at 12:35 +0200, Stephane Eranian wrote:
> > Ok, I found the problem. It was in intel_fixup_er().
> > Unlike in the original code, this routine must update
> > the event->extra_reg.idx to the idx parameter instead
> > of trying to swap out from it. 
> 
> Ah indeed. Thanks!


static void intel_fixup_er(struct perf_event *event, int idx)
{
        event->hw.extra_reg.idx = idx;

        if (idx == EXTRA_REG_RSP_0) {
                event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
                event->hw.config |= 0x01b7;
                event->hw.extra_reg.reg = MSR_OFFCORE_RSP_0;
        } else if (idx == EXTRA_REG_RSP_1) {
                event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
                event->hw.config |= 0x01bb;
                event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
        }
}

Like that then?
