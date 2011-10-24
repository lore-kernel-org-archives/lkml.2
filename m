Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1JXJPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:15:18 -0400
Received: from plane.gmane.org ([80.91.229.3]:45221 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab1JXJPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:15:16 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4EA52C9C.7080402@cam.ac.uk>
Date: Mon, 24 Oct 2011 10:15:08 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Maxin B John <maxin.john@gmail.com>
CC: Maxin B John 
	<public-maxin.john-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        Jonathan Cameron 
	<public-jic23-KWPb1pKIrIJaa/9Udqfwiw@plane.gmane.org>,
        Dan Carpenter 
	<public-error27-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        Bryan Freed 
	<public-bfreed-F7+t8E8rja9g9hUCZPvPmw@plane.gmane.org>,
        public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        Greg Kroah-Hartman <public-gregkh-l3A5Bk7waGM@plane.gmane.org>,
        public-linux-iio-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        Arnd Bergmann <public-arnd-r2nGTMty4D4@plane.gmane.org>,
        public-devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@plane.gmane.org,
        Amit Kucheria 
	<public-amit.kucheria-LY4KaoCqKrnby3iVrkZq2A@plane.gmane.org>
Subject: Re: [PATCH] staging: iio: light: Fix compiler warning in tsl2563.c
References: <20110902094107.GA2846@maxin> <4E60B63C.1030101@cam.ac.uk> <CAMhs6Yzw3-CARTULhy4s-Re4Q82Ek9gZGUQtABLLs0PSArHCuw@mail.gmail.com> <4EA52710.2060108@cam.ac.uk> <CAMhs6Yz6B_imMAthjjpymXj1garYzjFdzXfEArUwztmpgL4_hg@mail.gmail.com>
In-Reply-To: <CAMhs6Yz6B_imMAthjjpymXj1garYzjFdzXfEArUwztmpgL4_hg@mail.gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/24/11 10:03, Maxin B John wrote:
> Hi,
> 
> On Mon, Oct 24, 2011 at 11:51 AM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
>>
>>
>> On 10/22/11 06:15, Maxin B John wrote:
>>> Hi,
>>>
>>> On Fri, Sep 2, 2011 at 1:55 PM, Jonathan Cameron <jic23-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org> wrote:
>>>> On 09/02/11 10:41, Maxin B. John wrote:
>>>>>> Don't overwrite the error code.  For example, the lower layers can
>>>>>> return -EAGAIN and that's more useful than just returning -EIO every
>>>>>> time.
>>>>> Ahh.. Thanks a lot for explaining this.
>>>>>
>>>>>> Your fix works, but it's not very clean.  Just add a "*id = ret;"
>>>>>> line before the "return 0;" and that's it.  (It doesn't make sense
>>>>>> to pass a pointer to "id" and not use it).
>>>>> Dan, yes, I agree with you. This fix is much much better than what I
>>>>> had in my mind.
>>>>>
>>>>>> Yikes - I wonder why my various compilers don't throw that up.
>>>>> I guess, in "iio-blue.git" tree, the 'id = 0' suppresses this warning.
>>>> That'd do it. oops.
>>>>
>>>> Ideally keep the white space but doesn't really matter. Either send on
>>>> to Greg directly or I'll add it to iio-blue and send on with the next fixes
>>>> series - probably this afternoon.
>>>>>
>>>>> Signed-off-by: Maxin B. John <maxin.john-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>> Acked-by: Jonathan Cameron <jic23-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
>>>>
>>>
>>> Sorry for the delay in replying to this mail. I am curious about the
>>> status of this patch. I couldn't locate this patch at  iio-blue.git as
>>> it is not present in kernel.org now
>>> (http://git.kernel.org/?p=linux/kernel/git/jic23/iio-blue.git;a=summary)
>>> Please ignore this mail if you have already added this patch to your tree.
>> Ah, sorry I slipped up here and should have noticed it didn't go directly to
>> Greg. Just to check, with everyone I have author as Dan, reporter as Maxin
>> and have signed off myself (it's going through my tree anyway now).
>>
>> I think from looking back it was Dan's suggestion in response to Maxin's
>> patch.  Hence convention would be a sign off from Dan and perhaps an
>> Ack from Maxin?
> 
> Sounds good to me.
> 
> Acked-by: Maxin B. John <maxin.john@gmail.com>
> 
As Dan reckon's you are the author I'll switch that to a signed-off by.




