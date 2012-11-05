Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2KEMOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:14:10 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52260 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab2KEMOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:14:07 -0500
MIME-Version: 1.0
In-Reply-To: <5096D90A.401@gmail.com>
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
	<1352080784-30839-2-git-send-email-luming.yu@gmail.com>
	<5096D90A.401@gmail.com>
Date: Mon, 5 Nov 2012 07:14:06 -0500
Message-ID: <CAJRGBZxmUvtfbZAd1Z2G3WDJyu2cPwwob=mA3wzHwGnV4nHfXw@mail.gmail.com>
Subject: Re: [PATCH 01/13] HW-latency: hardware latency test 0.10
From: Luming Yu <luming.yu@gmail.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Luming Yu <luming.yu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 4, 2012 at 4:07 PM, Maarten Lankhorst
<m.b.lankhorst@gmail.com> wrote:
> Hey,
>
> Op 05-11-12 02:59, Luming Yu schreef:
>> This patch is the first step to test some basic hardware functions like
>> TSC to help people understand if there is any hardware latency as well
>> as throughput problem exposed on bare metal or left behind by BIOS or
>> interfered by SMI. Currently the patch tests TSC, CPU Frequency and
>> RDRAND which is a new CPU instruction to get random number introduced in
>> new CPU like Intel Ivy Bridge in stop_machine context,which is choosen to
>> make sure testers fully control their system under test to rule out some
>> level of unwanted noise.
>>
>> Signed-off-by: Luming Yu <luming.yu@intel.com>
>> ---
>>  drivers/misc/Kconfig           |   7 +
>>  drivers/misc/Makefile          |   1 +
>>  drivers/misc/hw_latency_test.c | 833 +++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 841 insertions(+)
>>  create mode 100644 drivers/misc/hw_latency_test.c
>>
>> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
>> index b151b7c..5ed440b 100644
>> --- a/drivers/misc/Kconfig
>> +++ b/drivers/misc/Kconfig
>> @@ -114,6 +114,13 @@ config IBM_ASM
>>         for information on the specific driver level and support statement
>>         for your IBM server.
>>
>> +config HW_LATENCY_TEST
>> +     tristate "Testing module to detect hardware lattency and throughput"
>> +     depends on DEBUG_FS
>> +     depends on RING_BUFFER
>> +     depends on X86
>> +     default m
> Is there any reason this tester couldn't easily be made to work for !x86?
>

Only problem is that I don't have platform to test.

> Also I think it would make more sense to squash all fixes, and submit fixes for the things like
> '[PATCH 07/13] HW-latency: delete too many "Fast TSC calibration using PIT" in cpufreq sampling'
> before the actual patch. It seems this is not necessarily a hw-latency specific patch to me.

Correct. I can do that later. I don't care it's a single big patch or
a patch series. It depends on how to help maintainers who would be
interested in taking  this feature into upstream. Although I will take
all responsibility to fix all bugs coming with it and the future
enhancement of  the feature.

The biggest problem to me right now for this feature is to find it a
way into upstream. I WILL do everything necessary. One big patch
instead of 13 patches-set is fine. Making it platform neutral is fine
too as long as it's necessary to make it upstream.

>
> ~Maarten
