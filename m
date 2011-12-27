Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab1L0Ekf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 23:40:35 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29080 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1L0Eka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 23:40:30 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6571"; a="147820407"
Message-ID: <4EF94C39.3070705@codeaurora.org>
Date: Tue, 27 Dec 2011 10:10:25 +0530
From: Sujit Reddy Thumma <sthumma@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Dmitry Antipov <dmitry.antipov@linaro.org>
CC: linaro-dev@lists.linaro.org, patches@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: use usleep_range() in mmc_delay()
References: <4EF18310.6080801@linaro.org> <4EF1C230.6060005@codeaurora.org> <4EF1D97E.3000201@linaro.org>
In-Reply-To: <4EF1D97E.3000201@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antipov,

Sorry for the delayed response. Please find some comments below:

On 12/21/2011 6:35 PM, Dmitry Antipov wrote:
> On 12/21/2011 03:25 PM, Sujit Reddy Thumma wrote:
>
>> I have posted similar patch some time back.
>> http://comments.gmane.org/gmane.linux.ports.arm.msm/2119.
>>
>> Would you like to comment on that?
>
> - I believe we should forget about jiffies, HZ and other similar obsolete
> timekeeping stuff;
>
> - I have no ideas where did you get 'most typical' 20 ms. MMC subsystem
> uses
> mmc_delay() with two compile-time fixed values 1 and 10 ms, with the only
> exception of card-dependent sleep/awake timeout. I was unable to find a
> table
> with typical values, but it's rounded up to >= 1 ms anyway.

The main aim of my patch was to fix mmc_delay() to give accurate delay.
You might want to refer to Documentation/timers/timers-howto.txt 
(Section: SLEEPING FOR ~USECS OR SMALL MSECS) to know why usleep_range() 
must be used instead of msleep for delays less than 20ms (or more 
accurately two jiffies, since in HZ=100 systems this comes to 20ms).

Also, in the documentation it is suggested that for delays greater than 
10ms+ use msleep(). Although MMC subsystem doesn't use mmc_delay() for 
greater than 10ms today but I guess we should keep it for future purpose 
and just not have only usleep_range() as your patch did.

>
> Dmitry

