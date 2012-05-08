Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab2EHAFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 20:05:11 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61505 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab2EHAFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 20:05:09 -0400
X-AuditID: 9c930197-b7badae000000cfd-4c-4fa86333bbf1
Message-ID: <4FA86332.6080601@kernel.org>
Date: Tue, 08 May 2012 09:05:06 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Richard Davies <richard.davies@elastichosts.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC][PATCH] avoid swapping out with swappiness==0
References: <65795E11DBF1E645A09CEC7EAEE94B9CB951A45F@USINDEVS02.corp.hds.com> <20120424082019.GA18395@alpha.arachsys.com> <65795E11DBF1E645A09CEC7EAEE94B9C014649EC4D@USINDEVS02.corp.hds.com> <20120426142643.GA18863@alpha.arachsys.com> <CAHGf_=pcmFrWjfW3eQi_AiemQEm_e=gBZ24s+Hiythmd=J9EUQ@mail.gmail.com> <4FA82C11.2030805@redhat.com>
In-Reply-To: <4FA82C11.2030805@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 05:09 AM, Rik van Riel wrote:

> On 04/26/2012 11:41 AM, KOSAKI Motohiro wrote:
>> On Thu, Apr 26, 2012 at 10:26 AM, Richard Davies
>> <richard.davies@elastichosts.com>  wrote:
>>> Satoru Moriya wrote:
>>>>> I have run into problems with heavy swapping with swappiness==0 and
>>>>> was pointed to this thread (
>>>>> http://marc.info/?l=linux-mm&m=133522782307215 )
>>>>
>>>> Did you test this patch with your workload?
>>>
>>> I haven't yet tested this patch. It takes a long time since these are
>>> production machines, and the bug itself takes several weeks of
>>> production
>>> use to really show up.
>>>
>>> Rik van Riel has pointed out a lot of VM tweaks that he put into 3.4:
>>> http://marc.info/?l=linux-mm&m=133536506926326
>>>
>>> My intention is to reboot half of our machines into plain 3.4 once it is
>>> out, and half onto 3.4 + your patch.
>>>
>>> Then we can compare behaviour.
>>>
>>> Will your patch apply cleanly on 3.4?
>>
>> Note. This patch doesn't solve your issue. This patch mean,
>> when occuring very few swap io, it change to 0. But you said
>> you are seeing eager swap io. As Dave already pointed out, your
>> machine have buffer head issue.
>>
>> So, this thread is pointless.
> 
> Running KVM guests directly off block devices results in a lot
> of buffer cache.
> 
> I suspect that this patch will in fact fix Richard's issue.
> 
> The patch is small, fairly simple and looks like it will fix
> people's problems.  It also makes swappiness=0 behave the way
> most people seem to imagine it would work.
> 
> If it works for a few people (test results), I believe we
> might as well merge it.
> 
> Yes, for cgroups we may need additional logic, but we can
> sort that out as we go along.
> 


I agree Rik's opinion absolutely.

-- 
Kind regards,
Minchan Kim
