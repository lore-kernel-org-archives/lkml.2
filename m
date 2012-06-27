Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab2F0PAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:00:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42187 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab2F0PAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:00:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAJRGBZze+hyoj=XepAU3gfSoxzenR1OW+huqGcmF2k3hwMT4kA@mail.gmail.com>
References: <20120625212312.GA2345@p4.domain>
	<CAJRGBZze+hyoj=XepAU3gfSoxzenR1OW+huqGcmF2k3hwMT4kA@mail.gmail.com>
Date: Wed, 27 Jun 2012 23:00:06 +0800
Message-ID: <CAJRGBZz50QsoWTxGrFxyxoyiy-0-m9evC83dQdLrwTqZbM7oSA@mail.gmail.com>
Subject: Re: [patch update-v1] a simple hardware detector for latency as well
 as throughput ver. 0.1.0
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de
Cc: jcm@jonmasters.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 9:37 PM, Luming Yu <luming.yu@gmail.com> wrote:
> On Tue, Jun 26, 2012 at 5:23 AM, Luming Yu <luming.yu@gmail.com> wrote:
>> The patch is the fist step to test some basic hardware functions like
>> TSC to help people understand if there is any hardware latency as well
>> as throughput problem exposed on bare metal or left behind by BIOS or
>> interfered by SMI. Currently the patch tests TSC, CPU Frequency, and
>> RDRAND, which is a new CPU instruction to get random number introudced
>> in new CPU like Intel Ivy Bridge, in stop_machine context.
>>
>> The tsc samples (ns) below are from a P4 system. You can change from 0
>> to 1000 in /sys/kernel/debug/hw_atency_test/threshold to TSC sample at ms.
>
> typo.
>
> s/ms/us/
>
>>
>> [root@p4 linux]# rmmod hw_latency_test
>> [root@p4 linux]# insmod drivers/misc/hw_latency_test.ko
>> [root@p4 linux]# echo tsc > /sys/kernel/debug/hw_latency_test/current
>> [root@p4 linux]# echo 1 > /sys/kernel/debug/hw_latency_test/enable
>> [root@p4 linux]# cat /sys/kernel/debug/hw_latency_test/sample
>> 1340657264.0434121340   388
>> 1340657264.0935125912   379
>> 1340657265.0436123548   404
>> 1340657265.0937122432   441
>> ....
>> ^C
>> [root@p4 linux]# echo 0 > /sys/kernel/debug/hw_latency_test/enable
>>
>> Signed-off-by: Luming  Yu <luming.yu@intel.com>
>> ---
>> I will add more tests after the first patch gets merged for those guys
>> who want to directly play with new hardware functions, and latency and
>> bandwidth is concern, or simply out of curiosity. The patch is based on
>> hardware latency dector written by Jcm in RT-tree. I assume I can add
>> Jcm's signed off here.
>>
>>
>>  drivers/misc/Kconfig           |    7 +
>>  drivers/misc/Makefile          |    2 +
>>  drivers/misc/hw_latency_test.c |  833 ++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 842 insertions(+), 0 deletions(-)
>>
>>
>> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
>> index c779509..a5216b5 100644
>> --- a/drivers/misc/Kconfig
>> +++ b/drivers/misc/Kconfig
>> @@ -123,6 +123,13 @@ config IBM_ASM
>>          for information on the specific driver level and support statement
>>          for your IBM server.
>>
>> +config HW_LATENCY_TEST
>> +       tristate "Testing module to detect hardware lattency and throughput"
>> +       depends on DEBUG_FS
>> +       depends on RING_BUFFER
>> +       depends on X86

I begun the tool on X86, but bear in mind that use standard kernel interface
as much as possible. I was trying to measure CPU Frequency, but the use of
calibrate_tsc forced me add a X86 dependency here.

Other finding is recalibrate_cpu_khz() is a null function in SMP.
But the only two users (p4-clockmod.c and powernow-k7.c) themselves
could lack of users roo these days.

Let me know if there are any other comments.

My plan for the tool is to push it in 3.6 or 3.7. So I will routinely
get back to the thread probably weekly or bi-weekly in the time frame.
:-)
The 0.2 will based on what I can see in upstream of the tool.

Thanks!!!
