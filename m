Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2FSA7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 20:59:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:5249 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab2FSA7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 20:59:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113542432"
Message-ID: <4FDFCED7.90109@intel.com>
Date: Tue, 19 Jun 2012 08:59:03 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 08/13] perf: Add Sandy Bridge-EP uncore support
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com> <1339741902-8449-9-git-send-email-zheng.z.yan@intel.com> <CABPqkBScO2DBL=tQ+RNfNfS4X3bvbHsp9CBrYQOP_uQu0bGhnw@mail.gmail.com>
In-Reply-To: <CABPqkBScO2DBL=tQ+RNfNfS4X3bvbHsp9CBrYQOP_uQu0bGhnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 11:28 PM, Stephane Eranian wrote:
> On Fri, Jun 15, 2012 at 8:31 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>> > From: "Yan, Zheng" <zheng.z.yan@intel.com>
>> >
>> > Add Intel Nehalem and Sandy Bridge uncore pmu support. The uncore
>> > subsystem in Sandy Bridge-EP consists of 8 components (Ubox,
>> > Cacheing Agent, Home Agent, Memory controller, Power Control,
>> > QPI Link Layer, R2PCIe, R3QPI).
>> >
> I did not find in this patch the support for the C-Box Filter register
> (SNBEP_C0_MSR_PMON_BOX_FILTER). Based on the description
> in the manual, looks like a valuable filter to support, especially for
> the core/thread filtering capability.
> 
> There is only one such filter per box, and it can be used by any events.
> So looks like we have another offcore_resp style register to manage
> here. Need to ensure the value of that filter is shared by all 4 counters.
> If you were to support that, you'd have to enable the tid filter on the
> CBox config regs and export that via sysfs. Also I assume you'd
> pass the value of that filter either in config1 or in the upper 32 bits
> of the config reg.
> 
> What's your take on that?
> 

I'm working on uncore support for Nehalem-EX which has extensive use of
shared extra registers. Once that work done, adding C-Box filter support
should be easy.

Regards
Yan, Zheng
 


