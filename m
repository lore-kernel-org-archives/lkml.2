Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808Ab1AMUmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:42:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46019 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618Ab1AMUl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:41:57 -0500
Date: Thu, 13 Jan 2011 21:41:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] perf-events: Add support for supplementary event registers v4
Message-ID: <20110113204155.GQ25713@one.firstfloor.org>
References: <1293464165.2695.102.camel@localhost> <AANLkTik9adcY_pH52c_Y0iRjitDKZOu5zyPusfjycuiH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik9adcY_pH52c_Y0iRjitDKZOu5zyPusfjycuiH@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 06:31:03PM +0100, Stephane Eranian wrote:
> Hi,
> 
> I'd like to suggest that the OFFCORE_RESPONSE extra MSR encoding
> be put into a dedicated field in the perf_event_attr instead of in the upper
> 32-bits of attr->config.


That's what the first revision of the patch did.
I can change it back to that.

Small drawback was that it needs more changes to the user tool,
but the patch was not very big.

> 
> There may not be enough space to encode for future processors.
> 
> In fact, given that the Sandy Bridge PMU spec is now available, we
> have a first example of this (see Vol3b figure 30.29). OFFCORE_RESPONSE
> needs 38 bits. So, instead of having NHM/WSM use attr->config and SNB


That makes sense.

> use another field, I think it would make sense to have that in a new u64 field
> for all processors. Despite the fact that OFFCORE_RESPONSE remains
> a model-specific feature, I think it would help user tools and libraries if we
> were to use a dedicated field.


-Andi
