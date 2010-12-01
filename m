Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab0LAQTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:19:03 -0500
Received: from canuck.infradead.org ([134.117.69.58]:37947 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab0LAQTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:19:01 -0500
Subject: Re: [PATCH 3/4] perf-events: Add support for supplementary event
 registers v3
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1291213631.32004.1563.camel@laptop>
References: <1290077254-12165-1-git-send-email-andi@firstfloor.org>
	 <1290077254-12165-4-git-send-email-andi@firstfloor.org>
	 <1291213631.32004.1563.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Dec 2010 17:19:17 +0100
Message-ID: <1291220357.32004.1683.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 15:27 +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-18 at 11:47 +0100, Andi Kleen wrote:
> > @@ -876,6 +944,8 @@ static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
> >                                           u64 enable_mask)
> >  {
> >         wrmsrl(hwc->config_base + hwc->idx, hwc->config | enable_mask);
> > +       if (hwc->extra_reg)
> > +               wrmsrl(hwc->extra_reg, hwc->extra_config);
> >  } 
> 
> I thought we agreed it made more sense to program the extra msr before
> enabling the counter.

Ah sorry, I seem to have mixed up the various versions.

The latest does indeed do as we agreed. Sorry for the noise.
