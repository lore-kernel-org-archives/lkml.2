Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab2C2RoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:44:00 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:14820
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752662Ab2C2Rn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:43:57 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zzbb2dI9371I1454I1432N98dK1447Mzz1202hzzz2fh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F749F47.4040500@am.sony.com>
Date: Thu, 29 Mar 2012 10:43:35 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [RFC] Android Logger vs. Shared Memory FIGHT!
References: <20120328210631.GB2297@fifo99.com> <20120329145055.GE13912@fifo99.com> <4F748CF6.4010205@am.sony.com> <20120329170930.GD16476@fifo99.com>
In-Reply-To: <20120329170930.GD16476@fifo99.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 10:09 AM, Daniel Walker wrote:
> John Stultz commented on how gettimeofday() is more accurate that what
> is needed. Logger actually uses a less accurate, and faster, method of timing.
> The time isn't exactly apples to apples, my shared memory example is actually
> using a slower clock compared to logger.

OK - that's interesting.
>  
>>
>> Tests were 60 seconds.  I presume there were multiple runs and these are
>> averages.  Can you provide the number of runs and the standard deviation for
>> each set?
> 
> 
> Test cases were 600 seconds (10 minutes) .. There were three runs. 
> Here's the raw data, all in bytes per second:
> 
> X86:
> Logger TSC = 70072480.0, 83911562.7, 78610971.8
> Shared Memory TSC = 460262336.0, 454204684.1, 457050682.2
> 
> Logger ACPI_PM = 75523320.0, 81615111.9, 81588600.2
> Shared Memory ACPI_PM = 29688532.0, 28211029.2, 28225661.6
> 
> 
> ARM:
> Logger = 6985508.0, 5827587.3, 7034293.7
> Shared Memory = 12371886.7, 18362639.9, 15274489.3


> You can feel free to compute the standard deviation if you wish.

Here are the std deviations:

x86-logger-tsc: 7.4%
x86-shmem-tsc: 0.5%
x86-logger-ACPI_PM: 3.6%
x86-shmem-ACPI_PM: 2.4%
ARM-logger: 8.4%
ARM-shmem: 15.9%

Performance ratios:
x86-shmem-tsc/x86-logger-tsc -> 5.9
x86-shmem-ACPI_PM/x86-logger-ACPI_PM -> 0.36
ARM-shem/ARM-logger -> 2.3

It would be nice to understand why the ARM numbers are
not more consistent.  I'll try to take a look at this next week.

Thanks for the data.

I recently started work on my own performance test suite
for logger.  I'm taking the approach of simulating log
insertions based on log timings from a sampled device, and
measuring cost per message.  I'm not sure when I'll finish
it, but I'll post results when I have them.
  -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

