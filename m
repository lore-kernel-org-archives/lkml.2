Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2EDFrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 01:47:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:46742 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab2EDFrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 01:47:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="136880442"
Message-ID: <4FA36D63.7030002@intel.com>
Date: Fri, 04 May 2012 13:47:15 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, andi@firstfloor.org, eranian@google.com, jolsa@redhat.com,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] perf: Add Nehalem and Sandy Bridge uncore support
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>  <1335924440-11242-6-git-send-email-zheng.z.yan@intel.com> <1336079060.6509.17.camel@twins>
In-Reply-To: <1336079060.6509.17.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 05:04 AM, Peter Zijlstra wrote:
> On Wed, 2012-05-02 at 10:07 +0800, Yan, Zheng wrote:
>>         switch (boot_cpu_data.x86_model) {
>> +       case 26: /* Nehalem */
>> +       case 30:
>> +       case 31:
>> +       case 37: /* Westmere */
>> +               msr_uncores = nhm_msr_uncores;
>> +               break;
>> +       case 42: /* Sandy Bridge */
>> +               msr_uncores = snb_msr_uncores;
>> +               break;
>>         default:
>>                 return 0;
>>         } 
> 
> I really hate we're duplicating all these things all over the place, but
> I don't really know what to do about it either.
> 
> Anyway, it looks like perf_event_intel.c is missing 31, that said I
> cannot seem to find model 31 on wikipedia either.
> 
Sorry. the number 31 is copied from Lin Ming's old uncore patch. Now both
Lin Ming and I can't find the model 31 processor. I will remove the 31 in
future patches. 

> What about 44, WSM-EP ?
> 
> I understand NHM-EX (46) and WSM-EX (47) have different uncores not
> implemented in this series, will those follow?
Yes, I just start reading the SDM.

Regards
Yan, Zheng

