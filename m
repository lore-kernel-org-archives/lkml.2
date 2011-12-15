Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab1LOC4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:56:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:4221 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab1LOC4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:56:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102375295"
Message-ID: <4EE961EC.3050706@linux.intel.com>
Date: Thu, 15 Dec 2011 10:56:44 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 5/6] x86, mce: handle "action required" errors
References: <cover.1323803130.git.tony.luck@intel.com> <80cbf65ae6e4bd610523cc8568b0c2dcb8c629b6.1323803130.git.tony.luck@intel.com> <4EE86C3A.2070304@linux.intel.com> <CA+8MBbLmeTb3808Xs4boH6KwDqfeSi69yzvHVpOMUzQg47bBZQ@mail.gmail.com>
In-Reply-To: <CA+8MBbLmeTb3808Xs4boH6KwDqfeSi69yzvHVpOMUzQg47bBZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/12/15 5:30, Tony Luck 写道:
> On Wed, Dec 14, 2011 at 1:28 AM, Chen Gong<gong.chen@linux.intel.com>  wrote:
>>> -       if (kill_it&&    tolerant<    3)
>>>
>>> +       if (worst != MCE_AR_SEVERITY&&    kill_it&&    tolerant<    3)
>>>                 force_sig(SIGBUS, current);
>>
>>
>> I think here it should add more comments to clarify why not killing *AR*
>> case.
>> Such as: "for SRAR errors, such as DCU/IFU error, on affected logical
>> processors, it is reasonable that RIPV is 0."
>
> I'll look at this - the reason to not kill for AR is that we want to
> try to recover
> first (e.g. page could be re-read from disk into a different physical page).
> In some cases we can recover transparently to the application.

Oh, yes, these reasons are very important why not killing *AR* events. But my
point is in a *AR* supported environment, "kill_it" should not be true like
below:
         if (!(m.mcgstatus & MCG_STATUS_RIPV))
                 kill_it = 1;

the reason is what I said before. But at that time the worst severity hasn't
been determined so we have to wati until it is out.

anyway, it is an interesting coincidence, isn't it? :-)
