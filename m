Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2HaQ5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:57:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab2HaQ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:56:59 -0400
Message-ID: <5040ECD5.8010305@canonical.com>
Date: Fri, 31 Aug 2012 09:56:53 -0700
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120820 Thunderbird/15.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Konrad Rezeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86/mm: Limit 2/4M size calculation to x86_32
References: <5017AE48.5090108@redhat.com> <1346430699-19894-1-git-send-email-stefan.bader@canonical.com> <a6b71e0f-d2d3-44b5-a939-f909ea3fdccc@email.android.com>
In-Reply-To: <a6b71e0f-d2d3-44b5-a939-f909ea3fdccc@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2012 09:41 AM, H. Peter Anvin wrote:
> I'm not saying we shouldn't patch the regression, but this house of cards
> *needs* to be replaced with something robust and correct by construction.

Then I did misunderstand/-interpret you about the former part and we actually 
are agreeing on the whole topic. Sorry about that. So the re-post just should 
serve as a reminder as the last comment here was quite a while ago.

>
> Stefan Bader <stefan.bader@canonical.com> wrote:
>
>> Avi wrote:
>>> The fact that the check is only done on i386 and not on x86_64 may come
>>> from one of
>>>
>>> - an oversight - by the time x86_64 processors came along, the problem
>>> with conflicting sizes was resolved - the whole thing is bogus
>>>
>>> Copying hpa who may be in a position to find out which.
>>
>> Talking to hpa it is more of the last. For more than just this reason.
>> Since the whole area of initial page tables seems to be rather sensitive
>> and easy to break there have been discussions and plans to come up with a
>> rewrite to improve on all those shortcomings.
>>
>> The detail I am not agreeing with hpa is the fixup for the immediate
>> breakage at head. IMO right now the code just has regressed and that should
>> be fixed as soon as possible. Plus doing a specific and small fix allows
>> that to be applicable to stable (which again still depends on things being
>> upstream).
>>
>> Hence the re-send in the hope that on the larger scale the may be agreement
>> on the immediate fix. I am not doubting the usefulness or need of a better
>> solution, but I think that having a remedy of the current situation just
>> until then has enough benefit to be considered.
>>
>> -Stefan

