Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0KLRdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:33:09 -0500
Received: from canuck.infradead.org ([134.117.69.58]:53996 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0KLRdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:33:08 -0500
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu, fweisbec@gmail.com,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <AANLkTimJ3nLwmRfmf+uTuUvg6HVrHBzrjgQXuTi5dxyp@mail.gmail.com>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
	 <AANLkTimJ3nLwmRfmf+uTuUvg6HVrHBzrjgQXuTi5dxyp@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 18:33:12 +0100
Message-ID: <1289583192.2084.339.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 18:17 +0100, Stephane Eranian wrote:
> I looked at this patch thinking how could this be reused for LBR_SELECT.
> 
> I am wondering if storing the extra MSR value in attr.config is really the way
> to go now as opposed to adding/overloading a field.
> 
> For OFFCORE_RESPONSE, it makes sense to use attr.config because this is
> a refinement of the event (a sub-sub event if you want).

Correct, it makes sense for offcore and load-latency, not so much for
lbr_config.

> For LBR_SELECT, you also need to pass a value, but there is no specific event
> associated with it. You can enable LBR with any event you want. Thus,
> storing the
> LBR_SELECT value independently would also make sense. And if we have this
> field for LBR_SELECT then we may as well use it for OFFCORE_REPONSE.

That would assume a single event doesn't contain offcore and lbr, no?
Currently the extra_reg thing assumes there's only one extra reg encoded
in the config word.

> The alternative would be to consider LBR_SELECT also as a refinement of
> the event being measured. Though by itself, it wouldn't do anything, it would
> have to be combine with a PERF_SAMPLE_BRANCH_STACK to attr.sample_type.

A separate field for the lbr_config seems to make most sense, we could
of course use the top 16 bits for lbr, the next 16 for offcore/ll and
the bottom 32 for eventsel, but that's mighty crowded.


