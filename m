Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab2JZHfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 03:35:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45451 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554Ab2JZHfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 03:35:30 -0400
Message-ID: <508A3D32.6090101@ti.com>
Date: Fri, 26 Oct 2012 13:05:14 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        VGER <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: Re: [PATCH] ARM: davinci: dm644x: fix out range signal for ED
References: <1349246100-7477-1-git-send-email-prabhakar.lad@ti.com> <506C158D.4000906@ti.com> <CA+V-a8uFNXvb7bPv0dLKeSeNzZ9C3rvrXCNSWy+8HgiumR9sEw@mail.gmail.com> <506D3704.4060102@ti.com> <CA+V-a8uqQhpe+9Q_A_ojR1MahHLnbKpOEBdg9Vz3Gq8YQbHyjg@mail.gmail.com>
In-Reply-To: <CA+V-a8uqQhpe+9Q_A_ojR1MahHLnbKpOEBdg9Vz3Gq8YQbHyjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/4/2012 7:23 PM, Prabhakar Lad wrote:
> Sekhar
> 
> On Thu, Oct 4, 2012 at 12:43 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>> On 10/4/2012 10:22 AM, Prabhakar Lad wrote:
>>> Hi Sekhar,
>>>
>>> On Wed, Oct 3, 2012 at 4:08 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>>>> On 10/3/2012 12:05 PM, Prabhakar wrote:
>>>>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>>>>
>>>>> while testing display on dm644x, for ED out-range signals
>>>>> was observed. This patch fixes appropriate clock setting
>>>>> for ED.
>>>>
>>>> Can you please clarify what you mean by "out range signal"? Are there
>>>> any user visible artifacts on the display? What was the clock being
>>>> provided earlier and what is the value after this patch?
>>>>
>>>> Also, is the issue severe enough that this patch should be applied to
>>>> stable tree as well?
>>>>
>>> Ideally a clock of 54Mhz is required for  enhanced definition to
>>> work, which it was actually set to but while testing I noticed
>>> out-of-range signal. The out-of-range signal is often caused
>>> when the field rate is above the rate that the television will handle.
>>> When this is the case the TV or monitor displays "Out-Of-Range Signal".
>>>
>>> Reducing the clock fixed it. now the clock is set to 27Mhz.
>>
>> So, is the requirement for ED 54MHz or lower? Still trying to explain
>> myself how 27MHz is working where a 54MHz is required. I guess there is
>> also a lower limit on what the frequency should be?
>>
> Ideally its 54Mhz, but I see in the datasheet for AD7342/3 [1] it can also
> work at 27Mhz too.

So, based on this discussion I think a better description would be:

"
Fix the video clock setting when custom timings are used with pclock  <=
27MHz. Existing clock selection uses PLL2 mode which results in a 54MHz
clock where as using the MXI mode results in a 27MHz clock (which is the
one actually desired).

This affects the Enhanced Definition (ED) support on DM644x. Without
this patch, out-range signals errors are were observed on the TV. An
out-of-range signal is often caused when the field rate is above the
rate that the television will handle.
"

Is this accurate? In future, please try to be descriptive in patch
description as it will help understand what the patch is doing and why
(which in turn will lead to the patch getting accepted faster).

Also I assume you need this patch in v3.7? Or can I send it for v3.8?

Thanks,
Sekhar
