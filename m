Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab2FDJgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 05:36:39 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34728 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2FDJgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 05:36:07 -0400
Message-ID: <4FCC817D.5060206@linux.vnet.ibm.com>
Date: Mon, 04 Jun 2012 15:05:57 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Yan, Zheng" <zheng.z.yan@intel.com>
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 0/10] perf: Intel uncore pmu counting support
References: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
In-Reply-To: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12060409-9574-0000-0000-000003096E77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aOn Wednesday 16 May 2012 10:29 AM, Yan, Zheng wrote:

> Hi, all
> 
> Here is the V4 patches to add uncore counting support for Nehalem,
> Sandy Bridge and Sandy Bridge-EP, applied on top of current tip.
> The code is based on Lin Ming's old patches.
> 
> For Nehalem and Sandy Bridge-EP, A few general events are exported
> under sysfs directory:
>   /sys/bus/event_source/devices/${uncore_dev}/events/
> 
> Each file in the events directory defines an event. The content is
> a string such as:
>   config=1,config1=2
> 
> You can use 'perf stat' to access to the uncore pmu. For example:
>   perf stat -a -C 0 -e 'Uncore_iMC_0/CAS_COUNT_RD/' sleep 1

Hello Yan, 

When I boot my Sandy bridge laptop with the patchset applied, I can see the following
directories in my sysfs interface here at /sys/bus/event_source/devices

-------------------------------------------------------
breakpoint  software    Uncore_C-Box_0  Uncore_C-Box_2
cpu         tracepoint  Uncore_C-Box_1  Uncore_C-Box_3
-------------------------------------------------------

So looks like I have 4 C-Box kind of uncore PMUs present on my system. But it does not
have "events" directory which is suppose to hold the events related to C-box pmu. This
is in line with you what you have mentioned above, generic events are only exported for
Nehalem and Sandy Bridge-EP type processors. I guess there are number of RAW events
associated with C-box type PMU. I am not able to figure out how to use those RAW events
directly in "perf stat". Could you please guide me how to use them in a sandy bridge setup
as I have explained above. Thank you.

Regards,
Anshuman Khandual

