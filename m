Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2B0GOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:14:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55369 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2B0GOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:14:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of myungjoo.ham@gmail.com designates 10.50.178.38 as permitted sender) smtp.mail=myungjoo.ham@gmail.com; dkim=pass header.i=myungjoo.ham@gmail.com
MIME-Version: 1.0
In-Reply-To: <201202260043.51118.rjw@sisk.pl>
References: <1329186372-2376-1-git-send-email-myungjoo.ham@samsung.com>
	<CAJ0PZbT4Sux6a8keUrDvinkQ9Q9L+99qbyDda04TKTc0VXEq4A@mail.gmail.com>
	<201202260043.51118.rjw@sisk.pl>
Date: Mon, 27 Feb 2012 15:14:30 +0900
Message-ID: <CAJ0PZbSO9igCymZzYhxWGE3jO4qkKGLn0T97F4MizVVNB-9WTQ@mail.gmail.com>
Subject: Re: [RFC PATCH] PM / QoS: Introduce new classes: DMA-Throughput and DVFS-Latency
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        markgross <markgross@thegnar.org>, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 8:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, February 14, 2012, MyungJoo Ham wrote:
>> On Tue, Feb 14, 2012 at 11:26 AM, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
>> > 1. CPU_DMA_THROUGHPUT
>> >
>> > This might look simliar to CPU_DMA_LATENCY. However, there are H/W
>> > blocks that creates QoS requirement based on DMA throughput, not
>> > latency, while their (those QoS requester H/W blocks) services are
>> > short-term bursts that cannot be effectively responsed by DVFS
>> > mechanisms (CPUFreq and Devfreq).
>> >
>> > In the Exynos4412 systems that are being tested, such H/W blocks include
>> > MFC (multi-function codec)'s decoding and enconding features, TV-out
>> > (including HDMI), and Cameras. When the display is operated at 60Hz,
>> > each chunk of task should be done within 16ms and the workload on DMA is
>> > not well spread and fluctuates between frames; some frame requires more
>> > and some do not and within a frame, the workload also fluctuates
>> > heavily and the tasks within a frame are usually not parallelized; they
>> > are processed through specific H/W blocks, not CPU cores. They often
>> > have PPMU capabilities; however, they need to be polled very frequently
>> > in order to let DVFS mechanisms react properly. (less than 5ms).
>> >
>> > For such specific tasks, allowing them to request QoS requirements seems
>> > adequete because DVFS mechanisms (as long as the polling rate is 5ms or
>> > longer) cannot follow up with them. Besides, the device drivers know
>> > when to request and cancel QoS exactly.
>> >
>> > 2. DVFS_LATENCY
>> >
>> > Both CPUFreq and Devfreq have response latency to a sudden workload
>> > increase. With near-100% (e.g., 95%) up-threshold, the average response
>> > latency is approximately 1.5 x polling-rate.
>> >
>> > A specific polling rate (e.g., 100ms) may generally fit for its system;
>> > however, there could be exceptions for that. For example,
>> > - When a user input suddenly starts: typing, clicking, moving cursors, and
>> >  such, the user might need the full performance immediately. However,
>> >  we do not know whether the full performance is actually needed or not
>> >  until we calculate the utilization; thus, we need to calculate it
>> >  faster with user inputs or any similar events. Specifying QoS on CPU
>> >  processing power or Memory bandwidth at every user input is an
>> >  overkill because there are many cases where such speed-up isn't
>> >  necessary.
>> > - When a device driver needs a faster performance response from DVFS
>> >  mechanism. This could be addressed by simply putting QoS requests.
>> >  However, such QoS requests may keep the system running fast
>> >  unnecessary in some cases, especially if a) the device's resource
>> >  usage bursts with some duration (e.g., 100ms-long bursts) and
>> >  b) the driver doesn't know when such burst come. MMC/WiFi often had
>> >  such behaviors although there are possibilities that part (b) might
>> >  be addressed with further efforts.
>> >
>> > The cases shown above can be tackled with putting QoS requests on the
>> > response time or latency of DVFS mechanism, which is directly related to
>> > its polling interval (if the DVFS mechanism is polling based).
>> >
>> > Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> In this PM-QoS patch, register_pm_qos_misc() for the new classes in
>> pm_qos_power_init() is missing.
>>
>> Those will be included in the next version of the patch.
>
> Has the new version been posted already?  I seem to have missed it if so.
>
> Thanks,
> Rafael

No. I've not posted the new version, yet, as I was waiting for other
comments for this patch. I'll send a V2 patch with the omitted part
included today.

Thanks.


Cheers!
MyungJoo.


-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
