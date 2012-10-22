Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab2JVRVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:21:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58878 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab2JVRVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:21:22 -0400
Message-ID: <5085808E.90702@linaro.org>
Date: Mon, 22 Oct 2012 19:21:18 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: linux-kernel@vger.kernel.org, len.brown@intel.com, khilman@ti.com,
        rjw@sisk.pl, deepthi@linux.vnet.ibm.com, akpm@linux-foundation.org,
        Trinabh Gupta <g.trinabh@gmail.com>, snanda@chromium.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH] acpi/cpuidle: reinitialize power_usage values when adding/removing
 C-states
References: <507FBC20.50004@linaro.org> <1350683446-8244-1-git-send-email-jwerner@chromium.org> <50831CA3.2020602@linaro.org> <CAODwPW-bnECEawh9sOwhydDodD+J4x2s4f5uHpeLusuBx-itxw@mail.gmail.com>
In-Reply-To: <CAODwPW-bnECEawh9sOwhydDodD+J4x2s4f5uHpeLusuBx-itxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 07:13 PM, Julius Werner wrote:
>> Could we just say this is always true because state[i+1] consumes less
>> than state[i] ?
>>
>> And then just remove the 'set_power_state' function, and the field
>> 'driver->power_specified' ?
>>
>> That will cleanup the code and fix this problem, no ?
> 
> I totally agree with your analysis. Even if a driver were to set
> proper usage values (and the power_specified bit), none of the
> existing governors would care about those actual numbers (and since
> the vast majority of drivers uses fake values anyway, this is not
> likely to change in the future). This seems to be a classic example of
> unnecessary over-engineering.
> 
> I am mostly interested in getting that bug fixed right now, but
> removing unnecessary code is always a good thing. If you think it
> would have a good chance of getting merged, I would be happy to draft
> up a larger patch that refactors power_usage away completely.

I am in favor of removing the unnecessary code as it fixes a bug also
but I am not a maintainer, so I can't tell if it has a good chance to be
merged as a bug fix.

I think Rafael can tell us what approach he would prefer.

Thanks
  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

