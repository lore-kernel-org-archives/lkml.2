Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab2GMFaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:30:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12642 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab2GMFaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:30:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 12 Jul 2012 22:30:20 -0700
Message-ID: <4FFFB2DC.3040605@nvidia.com>
Date: Fri, 13 Jul 2012 14:32:12 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH V2 3/3] tegra: add pwm backlight device tree nodes
References: <1341814105-20690-1-git-send-email-acourbot@nvidia.com> <1341814105-20690-4-git-send-email-acourbot@nvidia.com> <CAPnjgZ1QbjE+-tr0c01K2feUdEE2wMBfR=bKpTxnyDOJbY8+1Q@mail.gmail.com> <4FFEA2D4.9050308@nvidia.com> <CAPnjgZ2=Ga2P-40trA_=UABm=i7Uy4NTAM=ehea11mE22VfDew@mail.gmail.com>
In-Reply-To: <CAPnjgZ2=Ga2P-40trA_=UABm=i7Uy4NTAM=ehea11mE22VfDew@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 11:27 PM, Simon Glass wrote
>> I agree the type strings are a problem in the current form - if we could get
>> constants in the device tree, that would be much better. Your way of
>> representing the sequences is interesting though, if we can solve the type
>> issue (and also evaluate its cost in terms of memory footprint), it would be
>> interesting to consider it as well.
>
> At a guess:
>
>>>> +               power-on-sequence = "REGULATOR", "power", <1>,
>>>> +                                   "DELAY", <10>,
>>>> +                                   "PWM", "backlight", <1>,
>>>> +                                   "GPIO", "enable", <1>;
>
> About 106 bytes I think
>
>>>      step@0 { 16
>              type = "regulator"; 24
>>>         phandle = <&backlight_reg>; 16
>>>         enable = <1>; 16
>>>         post-delay = <10>; 16
>>>      }
>>>      step@1 { 16
>              type = "pwm"; 16
>>>         phandle = <&pwm 2 5000000>; 24
>>>      }
>>>      step@2 { 16
>              type = "gpio"; 20
>>>         phandle = <&gpio 28 0>; 24
>>>         enable = <1>; 16
>>>      }
>
> 220?

I compiled both versions to try it out. Your version was just 50 bytes 
larger than mine (I assumed that with yours, we would be able to remove 
the top-level pwm/regulator/gpio definitions that are referred by the 
sequence). The question here is do we want to have something more 
DT-ish, or are we trying to save every possible byte in the DT structure?

As Thierry also mentionned, we are trying to provide the same feature 
using the platform interface. I am not sure how we can elegantly support 
both ways through this.

>  From my understanding mixing strings and numbers in a property is
> frowned on though.

But doesn't it make sense in the current case? The power sequence is 
basically a program that is run by an interpreter. From this 
perspective, it makes more sense to me to have it as a binary field 
rather than a hierarchy of nodes and properties that will be harder to 
parse and will make error detection more complicated. I don't really see 
any practical benefit from turning the steps into sub-nodes, but then 
again I am not so familiar with the DT.

Alex.
