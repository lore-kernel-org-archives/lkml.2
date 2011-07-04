Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1GDBhF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 21:37:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39422 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab1GDBhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 21:37:02 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <201107022358.58319.rjw@sisk.pl>
References: <1306471995-4048-1-git-send-email-myungjoo.ham@samsung.com>
	<1306471995-4048-2-git-send-email-myungjoo.ham@samsung.com>
	<201107022358.58319.rjw@sisk.pl>
Date: Mon, 4 Jul 2011 10:37:00 +0900
X-Google-Sender-Auth: PFaa45WhHE92LDqgJkwUKj8K4TQ
Message-ID: <CAJ0PZbQuiwkW-Z+1Wrqmr3r_U+LdWS312RggkkjFBGFHES4wCw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] PM / DEVFREQ: add example governors
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jiejing Zhang <kzjeef@gmail.com>, Colin Cross <ccross@google.com>,
        Nishanth Menon <nm@ti.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2011/7/3 Rafael J. Wysocki <rjw@sisk.pl>:
> Hi,
>
> On Friday, May 27, 2011, MyungJoo Ham wrote:
>> Three CPUFREQ-like governors are provided as examples.
>>
>> powersave: use the lowest frequency possible. The user (device) should
>> set the polling_ms as 0 because polling is useless for this governor.
>>
>> performance: use the highest freqeuncy possible. The user (device)
>> should set the polling_ms as 0 because polling is useless for this
>> governor.
>>
>> simple_ondemand: simplified version of CPUFREQ's ONDEMAND governor.
>>
>> When a user updates OPP entries (enable/disable/add), OPP framework
>> automatically notifies DEVFREQ to update operating frequency
>> accordingly. Thus, DEVFREQ users (device drivers) do not need to update
>> DEVFREQ manually with OPP entry updates or set polling_ms for powersave
>> , performance, or any other "static" governors.
>>
>> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
[]
>> +
>> +     /* Set the desired frequency based on the load */
>> +     a = (unsigned long long) stat.busy_time * stat.current_frequency;
>
> What's the purpose of the conversion?

Assuming that the work speed of a device is proportional to its
frequency, it measures the amount of work done.
It's time * work/time. For example, during the last 10 second, if the
busy_time was 5 sec and frequency was 10MHz,
it's "50M", which is same as 20MHz and 2.5 sec.

>
>> +     b = div_u64(a, stat.total_time);
>> +     b *= 100;
>> +     b = div_u64(b, (DFSO_UPTHRESHOLD - DFSO_DOWNDIFFERENCTIAL / 2));
>> +     *freq = (unsigned long) b;
>> +
>> +     return 0;
>> +}
>
> Rafael
>



-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
