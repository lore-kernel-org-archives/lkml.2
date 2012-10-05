Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab2JEHd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:33:26 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56784 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2JEHdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:33:24 -0400
MIME-Version: 1.0
In-Reply-To: <17446332.558331349354185878.JavaMail.weblogic@epml02>
References: <17446332.558331349354185878.JavaMail.weblogic@epml02>
Date: Fri, 5 Oct 2012 10:23:30 +0530
Message-ID: <CA+Z25wWu_NTMn5U47+ukF8FOtEY0KUR6syKVVxVvJsXq7Pu+6Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] devfreq: Add support for devices which can idle
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: myungjoo.ham@samsung.com
Cc: "mturquette@linaro.org" <mturquette@linaro.org>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 October 2012 18:06, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
>> This patchset updates devfreq core to add support for devices
>> which can idle. When device idleness is detected perhaps
>> through runtime-pm, need some mechanism to suspend devfreq
>> load monitoring and resume when device is back online.
>>
>> patch 1 introduce core design changes - per device work, decouple
>> delayed work from core and event based interaction.
>> patch 2 add devfreq suspend and resume apis.
>> patch 3 add new sysfs attribute for governor predicted next target
>> frequency and callback for current device frequency.
>>
>> The existing devfreq apis are kept intact. Two new apis
>> devfreq_suspend_device() and devfreq_resume_device() are
>> added to support suspend/resume of device devfreq.
>
> Could you please tell me which version you have rebased?
>
> It seems that the patchset has issues on applying over 3.6.
> (tried at a0d271cbfed1dd50278c6b06bead3d00ba0a88f9)

These patches are rebased against Linus tree.

The 203b42f7317494ae5e5efc7be6fb7f29c927f102 commit, which
renames INIT_DELAYED_WORK_DEFERRABLE to
INIT_DEFERRABLE_WORK could be the reason for patchset
not applying over 3.6.

>
>
>>
>> Changes since v1:
>> - revised locking mechanism
>> - added kerneldoc comments for load monitoring helper functions
>> - fixed minor review comments
>>
>> Changes since v2:
>> - added new helper function for polling interval update
>> - handled work suspend/resume contention between devfreq driver
>> and sysfs
>>
>> Changes since v3:
>> - added additonal checks in suspend/resume to avoid invalid usage of apis
>> - added check in devfreq_monitor_start, not to start monitoring when
>> polling_ms is set to zero.
>>
>> --
>> Rajagopal Venkat (3):
>>   devfreq: Core updates to support devices which can idle
>>   devfreq: Add suspend and resume apis
>>   devfreq: Add current freq callback in device profile
>>
>>  Documentation/ABI/testing/sysfs-class-devfreq |  15 +-
>>  drivers/devfreq/devfreq.c                     | 481 ++++++++++++--------------
>>  drivers/devfreq/governor.h                    |  13 +
>>  drivers/devfreq/governor_performance.c        |  16 +-
>>  drivers/devfreq/governor_powersave.c          |  16 +-
>>  drivers/devfreq/governor_simpleondemand.c     |  33 ++
>>  drivers/devfreq/governor_userspace.c          |  23 +-
>>  include/linux/devfreq.h                       |  49 +--
>>  8 files changed, 353 insertions(+), 293 deletions(-)
>>
>> --
>> 1.7.11.3
>>
>>
>>
>>
>>
>>
>>
>>



-- 
Regards,
Rajagopal
