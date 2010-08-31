Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0HaVTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 17:19:54 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:59124 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755908Ab0HaVTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 17:19:53 -0400
Message-ID: <4C7D71B8.4020408@euromail.se>
Date: Tue, 31 Aug 2010 23:18:48 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100820 Thunderbird/3.1.2
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Jiri Kosina <jkosina@suse.cz>, Michael Poole <mdpoole@troilus.org>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6 v2] HID: magicmouse: remove axis data filtering
References: <1283280068-12285-1-git-send-email-chase.douglas@canonical.com>	 <1283280068-12285-4-git-send-email-chase.douglas@canonical.com>	 <4C7D6739.5000601@euromail.se> <1283288319.2255.103.camel@mini>	 <4C7D6ECB.2000308@euromail.se> <1283289360.2255.113.camel@mini>
In-Reply-To: <1283289360.2255.113.camel@mini>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OqYEx-00073x-6d.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OqYEx-00073x-6d b508d29a498eb7738a7896845efb5efc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2010 11:16 PM, Chase Douglas wrote:

> On Tue, 2010-08-31 at 23:06 +0200, Henrik Rydberg wrote:
>> On 08/31/2010 10:58 PM, Chase Douglas wrote:
>>
>>> On Tue, 2010-08-31 at 22:34 +0200, Henrik Rydberg wrote:
>>>> On 08/31/2010 08:41 PM, Chase Douglas wrote:
>>>>
>>>>> The Magic Mouse device is very precise. No driver filtering of input
>>>>> data needs to be performed.
>>>>>
>>>>> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
>>>>> Acked-by: Michael Poole <mdpoole@troilus.org>
>>>>> ---
>>>>
>>>>
>>>> I am still not sure this is a good idea. Bandwidth from MT devices is a big
>>>> deal. A statement roughly how much data comes out of mtdev (which does the
>>>> filtering for type A devices) before and after this change would be reassuring.
>>>
>>> As it is right now, hid-magicmouse doesn't support MT slots. I think all
>>> the fuzz code ends up comparing in the MT case is between one touch and
>>> another touch, not between one touch's current location and its previous
>>> location. If I'm correct, then it means a fuzz > 0 is incorrect for
>>> non-slotted MT devices.
>>>
>>> In fact, the code in drivers/input/input.c around line 194 looks like it
>>> discards defuzzing in this case, so one could say this patch is making
>>> things more correct :).
>>
>>
>> For type A devices, the filtering is performed in userspace, in mtdev, in the
>> same manner as it would have been performed in the kernel in the MT slot case.
>> Therefore, knowing the amount of messages coming out of mtdev is a direct
>> measurement of the effect of filtering.
> 
> Yes, but we're only interested in the kernel driver when reviewing this
> patch. Leaving the fuzz in as it is has no effect right now on ABS_MT_*
> axes. On the other axes, such as the touch orientation, it's probably
> more harmful than good.


"We" are interested in knowing if this patch makes any sense, given that
filtering is in actuality performed in userspace, and thus modifying this code
changes the stream rate into userspace applications, thank you.

Henrik
