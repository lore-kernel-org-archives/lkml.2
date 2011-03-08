Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab1CHXk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 18:40:57 -0500
Received: from smtp2.Stanford.EDU ([171.67.219.82]:37939 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756078Ab1CHXk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 18:40:56 -0500
Message-ID: <4D76BE85.9070406@localhost>
Date: Tue, 08 Mar 2011 15:40:53 -0800
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] RT for v2.6.34.8 now available.
References: <4D71668F.9050201@windriver.com> <4D748070.1030502@localhost> <4D753970.4030607@localhost> <4D7542E9.4000008@localhost> <4D754591.1090602@windriver.com> <4D7545F5.6080706@localhost> <4D757DE8.30602@windriver.com>
In-Reply-To: <4D757DE8.30602@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2011 04:52 PM, Paul Gortmaker wrote:
> On 11-03-07 03:54 PM, Fernando Lopez-Lezcano wrote:
>> On 03/07/2011 12:52 PM, Paul Gortmaker wrote:
>>> On 11-03-07 03:41 PM, Fernando Lopez-Lezcano wrote:
>
> [...]
>
>>>> ...
>>>>> - EeePC netbook, Fedora 13, Intel Mobile 945GME graphics: X does not start
>>>>> - Lenovo laptop, fedora 14, Intel 9xx graphics (at home): X does not start
>>>>> These last two share Intel graphics and the problem seems to be the
>>>>> same, something to do with dri.
>>>>
>>>> This is what I'm getting (dmesg|grep i915):
>>>>
>>>> i915 0000:00:02.0 PCI INT A ->   GSI 16 (level, low) ->   IRQ 16
>>>> i915 0000:00:02.0 setting latency timer to 64
>>>> i915 0000:00:02.0 PCI INT A disabled
>>>> i915: probe of 0000:00:02.0 failed with error -5
>>>>
>>>> Same kernel w/o rt...:
>>>>
>>>> i915 0000:00:02.0 PCI INT A ->   GSI 16 (level, low) ->   IRQ 16
>>>> i915 0000:00:02.0 setting latency timer to 64
>>>> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
>>>>
>>>> So, some problem with irq processing?
>>>> Where should I go look?
>>>
>>> Try v2.6.33-rt -- see if it is a new regression, or was a problem that
>>> already existed and has just been carried forward.
>>
>> 2.6.33.x-rt30 works on all of the above so it seems this is new... (yuck :-)
>> (just in case, this is not pristine 2.6.34.8 + rt git)
>
> I'm pretty sure I know what this is.  If you cherry pick the two
> commits from tip, namely:
>
> 	e89fab2bf44afccaa48ffb8ae33c03f4f3dcd208 and
> 	cd4ac9b7a1c80cfcd9b8e76a1f6855a0329d982f
>
> then I'll bet your i915 gets detected OK.

It does, thank you very much! I tested on the EeePc only but I suspect 
the Lenovo will be happy as well (it is at home right now). I have not 
hit any other problems so far with 2.6.34.8 + rtx (0?)...

-- Fernando
