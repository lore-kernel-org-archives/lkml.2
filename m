Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab2JIFP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 01:15:57 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46196 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab2JIFPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 01:15:55 -0400
Message-id: <5073B325.6060905@samsung.com>
Date: Tue, 09 Oct 2012 07:16:21 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907
 Thunderbird/15.0.1
MIME-version: 1.0
To: Minchan Kim <minchan@kernel.org>
Cc: Rabin Vincent <rabin@rab.in>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: CMA and zone watermarks
References: <CAH+eYFCJTtF+FeqKs_ho5yyX0tkUBoaa-yfsd1rVshcQ5Xxp=A@mail.gmail.com>
 <20121009031023.GF13817@bbox> <50739615.9080205@samsung.com>
 <20121009044317.GG13817@bbox> <5073ADC9.7030201@samsung.com>
 <20121009050748.GH13817@bbox>
In-reply-to: <20121009050748.GH13817@bbox>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/9/2012 7:07 AM, Minchan Kim wrote:
> On Tue, Oct 09, 2012 at 06:53:29AM +0200, Marek Szyprowski wrote:
>> Hello,
>>
>> On 10/9/2012 6:43 AM, Minchan Kim wrote:
>>> On Tue, Oct 09, 2012 at 05:12:21AM +0200, Marek Szyprowski wrote:
>>>> On 10/9/2012 5:10 AM, Minchan Kim wrote:
>>>>> On Mon, Oct 08, 2012 at 05:41:14PM +0200, Rabin Vincent wrote:
>>
>>>>> Fortunately, recently, Bart sent a patch about that.
>>>>> http://marc.info/?l=linux-mm&m=134763299016693&w=2
>>>>>
>>>>> Could you test above patches in your kernel?
>>>>> You have to apply [2/4], [3/4], [4/4] and don't need [1/4].
>>>>
>>>> AFAIR without patch [1/4], free cma page counter will go below zero
>>>> and weird thing will happen, so better apply the complete patchset.
>>>
>>> I can't understand your point. [1/4] is just fix for correcting trace
>>> No?
>>
>> I just remember we ran into such strange negative number of free cma
>> pages issue without that patch, but maybe the final patchset will
>> simply fail to apply without the first patch.
>
> I have no objection to apply them all, of course.
> But note that if you suffer from such strange bug without [1/4],
> it should be dug in without buring into just "fixing of the trace"
> comment. As I saw the code without [1/4], I can't find any fault.
> Could you elaborate it more if you have any guessing in mind?

I remember that in one version of the Bartek's patches, 
page_private(page) has been used directly for getting the migratetype 
after a call to __free_one_page() (the same way as 
trace_mm_page_pcpu_drain() used it), what resulted in incorrect counting 
of free pages. The issue has been fixed then by the patch [1/4].

Now I've check that the next patches use mt variable instead of 
page_private(page), so they will simply not apply without [1/4]. No 
other issues should be expected. I'm sorry for confusion.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center
