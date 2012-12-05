Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2LEIEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 03:04:45 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:42491 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2LEIEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 03:04:41 -0500
X-Greylist: delayed 1399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2012 03:04:41 EST
MIME-Version: 1.0
In-Reply-To: <CAEk7JKakQRPKEoi+vkF2KexB1d_G+BN-PZQT-QDNEeOrkVm0Vg@mail.gmail.com>
References: <1354620448-14317-1-git-send-email-dinggnu@gmail.com>
	<50BDE224.8000301@ti.com>
	<CACxGe6viwuyfYm2RBfcj233U6-xmJJTQgu=DUu_11iPAckUzqg@mail.gmail.com>
	<50BE0CC3.7060800@ti.com>
	<CAEk7JKakQRPKEoi+vkF2KexB1d_G+BN-PZQT-QDNEeOrkVm0Vg@mail.gmail.com>
Date: Wed, 5 Dec 2012 15:41:21 +0800
Message-ID: <CAEk7JKZkEDs0OJ9BQA04LH-Hn1e9DSaZKCv=YOm=_pQZhgNJsg@mail.gmail.com>
Subject: Re: [PATCH] memory: of_memory.c: remove unnecessary initialization
From: "Li, Zhen-Hua" <lizhenhua.dev@gmail.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Cong Ding <dinggnu@gmail.com>,
        Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And if you use -O2 as gcc option, you may find it does nothing. They
are using the same assemble language.

On Wed, Dec 5, 2012 at 3:26 PM, Li, Zhen-Hua <lizhenhua.dev@gmail.com> wrote:
> Infact, your patch does remove an orl operation, but add a new "move" operation.
>
> You can test such two functions:
> int func1(int rm1, int rm2){
>         int i = 0;
>         i |= rm1;
>         i |= rm2;
> }
>
> and
>
> int func(int rm1, int rm2){
>         int i;
>         i = rm1;
>         i |= rm2;
> }
>
> Use gcc to compile them to assemble with "-S" operation, and you will find it.
>
> On Tue, Dec 4, 2012 at 10:46 PM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>> On Tuesday 04 December 2012 07:25 PM, Grant Likely wrote:
>>>
>>> On Tue, Dec 4, 2012 at 11:44 AM, Santosh Shilimkar
>>> <santosh.shilimkar@ti.com> wrote:
>>>>
>>>> On Tuesday 04 December 2012 04:56 PM, Cong Ding wrote:
>>>>>
>>>>>
>>>>> the initialization of variable ret is unnecessary, we can remove it
>>>>> while
>>>>> save
>>>>> one time "or" operation.
>>>>>
>>>>> Signed-off-by: Cong Ding <dinggnu@gmail.com>
>>>>> ---
>>>>
>>>>
>>>> Looks ok.
>>>> Acked-by: Santosh Shilimkar<santosh.shilimkar@ti.com>
>>>>
>>>
>>> Thanks for the patch, but I don't think it matters enough to apply it.
>>> The existing code isn't wrong.
>>>
>> The patch was removing an additional operation and hence i didn't
>> contest it. I agree with your comment though.
>>
>> Regards
>> Santosh
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
