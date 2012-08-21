Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab2HUMGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:06:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:42896 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163Ab2HUMGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:06:44 -0400
Message-ID: <1345550792.23018.105.camel@twins>
Subject: Re: [PATCH v2] perf/x86: fix SNB-EP CBOX and PCU uncore PMU filter
 management
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
        zheng.z.yan@intel.com
Date: Tue, 21 Aug 2012 14:06:32 +0200
In-Reply-To: <20120821115948.GA15170@quad>
References: <20120821115948.GA15170@quad>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 13:59 +0200, Stephane Eranian wrote:
> The existing code had a bug whereby it would refuse to
> measure two events in a group for either CBO or PCU PMUs,
> if one of the events was using a filter. This was due to
> the fact that the kernel assumed all CBO and PCU events
> were using filters, and thus would detect false positive
> conflicts between attr->config1 values.
>     
> This patch fixes the problem by introducing the extra_reg
> event mapping tables for both CBO and PCU PMUs. Those
> tables associate an event code+umask with extra (filter)
> register. We used the same approach for the offcore_response
> core PMU event.
>     
> With this patch applied, it is possible to measure, for
> instance, CBO unc_c_tor_inserts:opcode:pcirdcur with
> unc_c_clockticks in the same group.
>     
> The filter for both CBO and PCU are more complex than what the
> current code support. Each filter is sub-divided into event
> specific filters. For now, we consider the filter as one single
> MSR value. We lose a bit of flexibility and force multiplexing
> when this is not really necessary in HW. We could later create
> the notion of virtual filters that would be aggregated at the
> last step (wrmsrl). But I think this is good enough for now.


Thanks, added Zheng Yan's ACK as well since its essentially the same
patch.
