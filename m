Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1FGRJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:09:55 -0400
Received: from mail.candelatech.com ([208.74.158.172]:56361 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab1FGRJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:09:53 -0400
Message-ID: <4DEE5B5F.6030606@candelatech.com>
Date: Tue, 07 Jun 2011 10:09:51 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Keith Packard <keithp@keithp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.0.0-rc2 fails to boot on Atom appliance (bisected, drm/i915)
References: <4DED33DF.8000201@candelatech.com>	<4DED6221.1060806@candelatech.com>	<yunzkluzfw9.fsf@aiko.keithp.com>	<4DED69C6.1090301@candelatech.com> <20110606172402.72ddb29b@jbarnes-desktop> <4DEDA25C.5010405@candelatech.com>
In-Reply-To: <4DEDA25C.5010405@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2011 09:00 PM, Ben Greear wrote:
> On 06/06/2011 05:24 PM, Jesse Barnes wrote:
>> On Mon, 06 Jun 2011 16:59:02 -0700
>> Ben Greear<greearb@candelatech.com> wrote:
>>
>>> On 06/06/2011 04:41 PM, Keith Packard wrote:
>>>> On Mon, 06 Jun 2011 16:26:25 -0700, Ben
>>>> Greear<greearb@candelatech.com> wrote:
>>>>> On 06/06/2011 01:09 PM, Ben Greear wrote:
>>>>>> Anyone seen something like this? For what it's worth, it seems
>>>>>> that -rc1 had the same problem. I'll start bisecting soon if
>>>>>> the problem isn't already resolved somehow...
>>>>>
>>>>> I bisected this problem down to this commit:
>>>>
>>>> This should be fixed by this patch:
>>>>
>>>> -------------------- drivers/gpu/drm/i915/intel_display.c
>>>> ---------------------
>>>> index f553ddf..bb1b59b 100644
>>>> @@ -7675,6 +7675,7 @@ static void intel_init_display(struct
>>>> drm_device *dev)
>>>> dev_priv->display.update_wm = NULL;
>>>> } else
>>>> dev_priv->display.update_wm = pineview_update_wm;
>>>> + dev_priv->display.init_clock_gating = gen3_init_clock_gating;
>>>> } else if (IS_G4X(dev)) {
>>>> dev_priv->display.update_wm = g4x_update_wm;
>>>> dev_priv->display.init_clock_gating = g4x_init_clock_gating;
>>>>
>>>> This hasn't been merged yet, but should be soon.
>>>
>>> I tried adding that, but the problem stays the same.
>>>
>>> Any other patches I should try?
>>
>> Are you sure you booted the right kernel and that it built& installed
>> correctly?
>
> I double checked, but I tried to cheat a bit and just applied that patch on
> top of -rc2 instead of on top of the patch that breaks things according to
> bisect. Maybe there is more than one problem. I'll try tweaking that single
> patch tomorrow.
>
> And, I built and booted twice to make sure I didn't screw up..but it had
> been
> a long day of bisecting, so maybe I still messed up some how.

Ok, building with just your fixup patch on top of the busted patch
does let it boot.

There must be some other failure that is causing -rc2 to fail.

Think I'll wait for -rc3...

Thanks,
Ben


>
>>
>> You could add an:
>> if (dev_priv->display.init_clock_gating)
>> above the call to display.init_clock_gating in intel_init_clock_gating
>> to be sure it's the same problem...
>
> Ok, can try that too.
>
> Thanks,
> Ben
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

