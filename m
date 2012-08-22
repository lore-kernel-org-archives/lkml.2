Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab2HVHNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:13:18 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33998 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab2HVHNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:13:14 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF0BF4@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0AD5@DQHE02.ent.ti.com>
 <CAK5ve-+LWG=YzEy=qWnGvqzw6+tX=7su5NH5V=5g+fjHA6gJrg@mail.gmail.com> <A874F61F95741C4A9BA573A70FE3998F41EF0BF4@DQHE02.ent.ti.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 22 Aug 2012 15:12:52 +0800
X-Google-Sender-Auth: le6Z1F4jD0hKcfQdZbSi-yH5kXA
Message-ID: <CAK5ve-Lr1nhw9Mpam_LR6s+1z8-pw+DW6JKnojMQwqOzt-+k1A@mail.gmail.com>
Subject: Re: [PATCH 1/4] leds-lp5523: add channel name in the platform data
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 1:43 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
>> >  LP5523 can drive up to 9 channels. Leds can be controlled directly
>> via
>> > -the led class control interface. Channels have generic names:
>> > +the led class control interface.
>> > +The name of each channel is configurable in the platform data.
>> > +If the name is NULL, channels have generic names:
>> >  lp5523:channelx where x is 0...8
>
>> Why we need a test here "pdata->label ?:"? From the document, looks
>> like we use lp5523:channel%d as default.
>
> To define the channel name, we have three options.
> a) using 'name' field for each channel
> b) using 'label' field without 'name'
> c) default : neither data is defined
>
> So I would change the description as below.
>

Thanks for this clarification. I'm fine with this, please resubmit patches.

-Bryan

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  Documentation/leds/leds-lp5523.txt |   18 ++++++++++++++++--
>  1 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/leds/leds-lp5523.txt b/Documentation/leds/leds-lp5523.txt
> index fad2feb..120fdfe 100644
> --- a/Documentation/leds/leds-lp5523.txt
> +++ b/Documentation/leds/leds-lp5523.txt
> @@ -10,8 +10,22 @@ Contact: Samu Onkalo (samu.p.onkalo-at-nokia.com)
>  Description
>  -----------
>  LP5523 can drive up to 9 channels. Leds can be controlled directly via
> -the led class control interface. Channels have generic names:
> -lp5523:channelx where x is 0...8
> +the led class control interface.
> +The name of each channel is configurable in the platform data - name and label.
> +There are three options to make the channel name.
> +
> +a) Define the 'name' in the platform data
> +To make specific channel name, then use 'name' platform data.
> +/sys/class/leds/R1               (name: 'R1')
> +/sys/class/leds/B1               (name: 'B1')
> +
> +b) Use the 'label' with no 'name' field
> +For one device name with channel number, then use 'label'.
> +/sys/class/leds/RGB:channelN     (label: 'RGB', N: 0 ~ 8)
> +
> +c) Default
> +If both fields are NULL, 'lp5523' is used by default.
> +/sys/class/leds/lp5523:channelN  (N: 0 ~ 8)
>
>  The chip provides 3 engines. Each engine can control channels without
>  interaction from the main CPU. Details of the micro engine code can be found
> --
> 1.7.2.5
>
>
> Best Regards,
> Milo
>
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
