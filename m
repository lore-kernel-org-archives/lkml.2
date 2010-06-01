Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0FAGnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 02:43:20 -0400
Received: from crca.org.au ([74.207.252.120]:44273 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab0FAGnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 02:43:19 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C04ABFB.9050301@crca.org.au>
Date: Tue, 01 Jun 2010 16:43:07 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: 2.6.35 Radeon KMS power management regression?
References: <4C04A767.8000209@crca.org.au> <AANLkTikTyYOGEEkFoV9NfbWE9Jxe9Q6Kk1mAJ4PDNL5r@mail.gmail.com>
In-Reply-To: <AANLkTikTyYOGEEkFoV9NfbWE9Jxe9Q6Kk1mAJ4PDNL5r@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 01/06/10 16:33, Dave Airlie wrote:
> On Tue, Jun 1, 2010 at 4:23 PM, Nigel Cunningham
> <ncunningham@crca.org.au>  wrote:
>> Hi all.
>>
>> Just wondering if anyone else has tried to hibernate while using Radeon KMS
>> and a tree with Dave's post 2.6.34 patches? My 32 bit P4 based system (with
>> an RV250 card) is hanging at the atomic copy, with the following backtrace
>>
>> hibernation_snapshot
>> dpm_suspend_start
>> async_synchronize_full
>> async_synchronize_cookie
>> async_synchronize_cookie_domain
>>
>> I've been trying to bisect, but this computer is being painfully slow, so I
>> haven't been making much progress. 2.6.34 with the same config is fine, and
>> my bisection progress so far seems to be pointing at the merge I mentioned
>> above.
>
> The only thing I can think off might be the output polling task, or
> the fix from Jerome for AGP suspend/resume
> 10b06122afcc78468bd1d009633cb71e528acdc5 is AGP one to test

Thanks for the quick reply. I've commented out the radeon_agp_suspend 
call and will try that shortly. By the way, saw your recent commit 
message talking about kids programs and lowering of IQs. I sympathise. I 
have the Wiggles in my head far too much at the moment :)

> disabling output polling is a messier revert, might be easier to just edit
> drivers/gpu/drm/drm_crtc_helper.c:drm_kms_helper_poll_init and remove
> the delayed_slow_work_enqueue call, also forcing repoll to false
> inside output_poll_execute which should in theory stop the polling
> from starting or being kicked off later.

Will try that next.

> I'll try and recreate if I get a chance, cc'ing dri-devel also for Alex/Jerome.

Ta.

Nigel
