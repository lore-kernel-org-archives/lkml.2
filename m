Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab0IKSMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 14:12:42 -0400
Received: from t03.superonline.com ([92.45.6.173]:27315 "EHLO
	smtpout2.superonline.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751110Ab0IKSMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 14:12:41 -0400
Message-ID: <4C8BC68B.8050002@superonline.com>
Date: Sat, 11 Sep 2010 14:12:27 -0400
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100821 Icedove/3.1.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: PATCH: PM / Hibernate: Avoid hitting OOM during preallocationof memory
References: <201009062043.37819.rjw@sisk.pl> <201009072344.53905.rjw@sisk.pl> <4C878818.1070705@superonline.com> <201009082334.01255.rjw@sisk.pl>
In-Reply-To: <201009082334.01255.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 184 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: -26.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry for the late reply. I have been busy the past few days.

On 08/09/10 05:34 PM, Rafael J. Wysocki wrote:
> On Wednesday, September 08, 2010, M. Vefa Bicakci wrote:
>> [snip]
>>
>> I should note a few things though,
>>
>> 1) I don't think I ever changed /sys/power/image_size, so we can rule out the
>> possibility of that option changing the results.
> 
> Can you please check what value is there in this file?

It contains 524288000, so I think it is set to 500 MB. I believe that this is
the default value, but I am not sure.

>> 2) With the patch below, for the *first* hibernation operation, the computer
>> enters a "thoughtful" state without any disk activity for 6-8 (maybe 10)
>> seconds after printing "Preallocating image memory". It works properly after
>> the wait however.
> 
> That probably is a result of spending time in the memory allocator trying to
> reduce the size of the image as much as possible.

I am not sure if this is a new thing with the new patch, but the behavior
seems to continue with the later hibernation operations too, not just the
first one. I haven't confirmed if I really didn't realize the problem in
the previous version of the patch, but it is very possible that I didn't
realize it since I used to automate my tests. (I didn't automate my tests
this time.)

However, considering that the kernel needs to worry about compacting 1500 MB
of data when hibernating with my tmpfs-is-full system, I guess these wait
times are normal, even though a bit inconvenient.

>> [snip]
> 
>> 4) I made sure that I was not being impatient with the previous snapshot.c
>> patch, so I tested that on its own once again, and I confirmed that hibernation
>> hangs with the older version of the snapshot.c patch.
>>
>> I am very happy that we are getting closer to a solution. Please let me know
>> if there is anything I need to test further.
> 
> Below is the patch I'd like to apply.  It should work just like the previous
> one (there are a few fixes that shouldn't affect the functionality in it), but
> please test it if you can.

I am happy to report that it works properly by only itself when applied to
a clean 2.6.35.4 tree. I haven't had any problems (aside from the "thoughtful
state" issue I mentioned above) with my 6 consecutive hibernation attempts.

> I think the slowdown you saw in 2) may be eliminated by increasing the
> image_size value, so I'm going to prepare a patch that will compute the
> value automatically during boot so that it's approximately 50% of RAM.

I would be glad to test that patch as well, to see if it brings speed-ups.
Actually, I might test hibernation with a larger value written to
/sys/power/image_size when I have time.

> 
> Thanks,
> Rafael

I really appreciate your help. Thanks a lot!

M. Vefa Bicakci

> [patch snipped]
