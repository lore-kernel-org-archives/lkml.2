Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab2F1BaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:30:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:43111 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab2F1BaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:30:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161554765"
Message-ID: <4FEBB3A9.6090906@intel.com>
Date: Thu, 28 Jun 2012 09:30:17 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: eranian@google.com, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] perf/x86: Uncore Filter support for SandyBridge-EP
References: <1340780953-21130-1-git-send-email-zheng.z.yan@intel.com>  <1340780953-21130-2-git-send-email-zheng.z.yan@intel.com> <1340791604.10063.10.camel@twins>
In-Reply-To: <1340791604.10063.10.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 06:06 PM, Peter Zijlstra wrote:
> On Wed, 2012-06-27 at 15:09 +0800, Yan, Zheng wrote:
>> > @@ -1048,10 +1190,9 @@ static int uncore_validate_group(struct intel_uncore_pmu *pmu,
>> >  {
>> >         struct perf_event *leader = event->group_leader;
>> >         struct intel_uncore_box *fake_box;
>> > -       int assign[UNCORE_PMC_IDX_MAX];
>> >         int ret = -EINVAL, n;
>> >  
>> > -       fake_box = uncore_alloc_box(smp_processor_id());
>> > +       fake_box = uncore_alloc_box(pmu->type, smp_processor_id());
>> >         if (!fake_box)
>> >                 return -ENOMEM;
>> >  
>> > @@ -1073,7 +1214,7 @@ static int uncore_validate_group(struct intel_uncore_pmu *pmu,
>> >  
>> >         fake_box->n_events = n;
>> >  
>> > -       ret = uncore_assign_events(fake_box, assign, n);
>> > +       ret = uncore_assign_events(fake_box, NULL, n);
>> >  out:
>> >         kfree(fake_box);
>> >         return ret; 
> Isn't the uncore now suffering the same problem you found for the
> regular extra stuff?

The snbep_uncore_get/put_constraint(...) has check for that. The uncore case is simpler,
because we don't need try swapping RSP_0/RSP_1.

Regards
Yan, Zheng

