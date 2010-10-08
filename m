Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab0JHFYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:24:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:64238 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab0JHFYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:24:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,301,1283756400"; 
   d="scan'208";a="333629361"
Message-ID: <4CAEAB2D.1070501@linux.intel.com>
Date: Fri, 08 Oct 2010 13:25:01 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [1/2] hwmon: uniform the init style of pkgtemp
References: <1285480800-14558-2-git-send-email-gong.chen@linux.intel.com> <20101002032603.GA25998@ericsson.com> <4CAE930D.2040601@linux.intel.com> <20101008035248.GA23368@ericsson.com>
In-Reply-To: <20101008035248.GA23368@ericsson.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 10/8/2010 11:52 AM, Guenter Roeck 写道:
> On Thu, Oct 07, 2010 at 11:42:05PM -0400, Chen Gong wrote:
>> 于 10/2/2010 11:26 AM, Guenter Roeck 写道:
>>> On Sun, Sep 26, 2010 at 05:59:59AM -0000, Chen Gong wrote:
>>>> pkgtemp is derived from coretemp, so some reasonable
>>>> logics should be applied onto pkgtemp, too. Such as
>>>> the init logic here.
>>>>
>>>> Signed-off-by: Chen Gong<gong.chen@linux.intel.com>
>>>> Acked-by: Jan Beulich<jbeulich@novell.com>
>>>>
>>> Hi,
>>>
>>> this patch, when applied with CONFIG_HOTPLUG_CPU undefined, causes a compile failure
>>> because it tries to access pkgtemp_cpu_notifier which is not defined in this case.
>>>
>>> For that reason, I have removed the patch from the list of applied patches for -next.
>>> Please re-submit a version which compiles for all combinations of HOTPLUG_CPU and SMP
>>> defined/undefined.
>>>
>>> Thanks,
>>> Guenter
>>>
>> Sorry for late. I just come back from my holiday. If only this one patch
>> is applied, it is broken, but it will be OK after these 2 patches are
>> applied. I tested the patches when CONFIG_SMP is undefined, it does be
>
> Each patch by itself must be compilable, otherwise we break the ability
> to bisect. Not a good idea.

Yes, but in fact it is an existing issue, not new incoming. The 1st 
patch isn't used for this purpose.

>
>> broken again. My suggestion is adding a macro definiton in the pkgtemp.c
>> like "#include<asm/smp.h>". If it is doable, I will re-post a new patch
>> series
>
> I assume you mean to add the include directive. Yes, that should do it,
> but please make sure that it compiles.

Sure, of course

>
> Thanks,
> Guenter
>

