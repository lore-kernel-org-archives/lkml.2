Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2BCMNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 07:13:48 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46747 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2BCMNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 07:13:47 -0500
MIME-Version: 1.0
In-Reply-To: <1328253147.20438.19.camel@rui.sh.intel.com>
References: <1323789196-4942-1-git-send-email-amit.kachhap@linaro.org>
	<CAK44p22LmkGVo0W5eoT5Ms57pkP7PbWoxNS2c8bnx=1FhBvamA@mail.gmail.com>
	<1328253147.20438.19.camel@rui.sh.intel.com>
Date: Fri, 3 Feb 2012 17:43:46 +0530
Message-ID: <CAK44p238f5g5zEga-Tz3Nmf0W7y8p-2mgWU2qrjnxWozbx-APA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] thermal: Add generic cpu cooling devices
 according to thermal framework
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 February 2012 12:42, Zhang Rui <rui.zhang@intel.com> wrote:
> Hi, sorry for the late response.
>
> On 四, 2012-01-19 at 14:47 +0530, Amit Kachhap wrote:
>> On 13 December 2011 20:43, Amit Daniel Kachhap <amit.kachhap@linaro.org> wrote:
>> > PATCH 1)  [thermal: Add a new trip type to use cooling device instance number]
>> > This patch adds a new trip type THERMAL_TRIP_STATE_ACTIVE which passes
>> > cooling device instance number and may be helpful for cpufreq cooling devices
>> > to take the correct cooling action.
>> >
> Sorry, I'm still not quite clear about how this will be used.
> Say, processor has P0~P3, then we need to register a thermal zone with
> three STATE_ACTIVE trip points, like the picture shown below?
>
> processor in full speed, i.e. P0
> ----------------------------
> state active trip point 1
> ----------------------------
> processor in P1
> ----------------------------
> state active trip point 2
> ----------------------------
> processor in P2
> ----------------------------
> state active trip point 3
> ----------------------------
> processor in P3
>

Thanks for the review. Your representation of the 3 PSTATES and trip
points are correct. Also remember the case that we have registered one
cpufreq cooling device and binded 3 instance of it with the 3 trip
points. So in the current patch set_cur_state will pass the instance
id also which will help in moving to the current P state.

This same behaviour is achieved through PASSIVE state but it iterates
through all the P states. so the current patch avoids the iteration
and goes to a single state directly.

>> > PATCH 2)  [thermal: Add generic cpu cooling implementation]
>> > This patch adds generic cpu cooling low level implementation through frequency
>> > clipping and cpu hotplug. In future, other cpu related cooling devices may be
>> > added here. An ACPI version of this already exists(drivers/acpi/processor_thermal.c).
>> > But this will be useful for platforms like ARM using the generic thermal interface
>> > along with the generic cpu cooling devices. The cooling device registration API's
>> > return cooling device pointers which can be easily binded with the thermal zone
>> > trip points.
>> >
> It seems that we can convert the ACPI processor thermal driver to follow
> this generic cpu cooling implementation, right?
I am not sure if we can convert the processor thermal driver because
it performs other cpu cooling like throttling, idle etc and then ACPI
abstraction on top of it. I am thinking of exporting the generic low
level cooling implementation like this patch is doing from
processor_thermal.c file so that it can be usable with non-acpi
interface.
What is your opinion about it?

Thanks,
Amit Daniel
>
> thanks,
> rui
>>
>> Any comments on these patches? I submitted them quite long back.
>>
>> Regards,
>> Amit D
>>
>> >
>> > Amit Daniel Kachhap (2):
>> >  thermal: Add a new trip type to use cooling device instance number
>> >  thermal: Add generic cpu cooling implementation
>> >
>> >  Documentation/thermal/cpu-cooling-api.txt |   52 +++++
>> >  Documentation/thermal/sysfs-api.txt       |    4 +-
>> >  drivers/thermal/Kconfig                   |   11 +
>> >  drivers/thermal/Makefile                  |    1 +
>> >  drivers/thermal/cpu_cooling.c             |  302 +++++++++++++++++++++++++++++
>> >  drivers/thermal/thermal_sys.c             |   27 +++-
>> >  include/linux/cpu_cooling.h               |   45 +++++
>> >  include/linux/thermal.h                   |    1 +
>> >  8 files changed, 440 insertions(+), 3 deletions(-)
>> >  create mode 100644 Documentation/thermal/cpu-cooling-api.txt
>> >  create mode 100644 drivers/thermal/cpu_cooling.c
>> >  create mode 100644 include/linux/cpu_cooling.h
>> >
>
>
