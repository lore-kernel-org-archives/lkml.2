Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab1DYSVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 14:21:17 -0400
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:43168 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722Ab1DYSVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 14:21:16 -0400
X-Greylist: delayed 5236 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Apr 2011 14:21:15 EDT
Message-ID: <4DB5A71A.5080802@genband.com>
Date: Mon, 25 Apr 2011 10:53:46 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Robert Whitton <rwhitton@iee.org>, Clemens Ladisch <clemens@ladisch.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Background memory scrubbing
References: <18563.1303314382@jupiter.eclipse.co.uk> <20110420160125.GC2312@gere.osrc.amd.com>
In-Reply-To: <20110420160125.GC2312@gere.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Apr 2011 16:53:47.0855 (UTC) FILETIME=[588655F0:01CC0369]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18096.000
X-TM-AS-Result: No--7.126000-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2011 10:01 AM, Borislav Petkov wrote:
> On Wed, Apr 20, 2011 at 04:46:22PM +0100, Robert Whitton wrote:
>>
>>> On Wed, Apr 20, 2011 at 05:19:41PM +0200, Clemens Ladisch wrote:
>>>>> Unfortunately in common with a large number of hardware platforms
>>>>> background scrubbing isn't supported in the hardware (even though ECC
>>>>> error correction is supported) and thus there is no BIOS option to
>>>>> enable it.
>>>>
>>>> Which hardware platform is this? AFAICT all architectures with ECC
>>>> (old AMD64, Family 0Fh, Family 10h) also have scrubbing support.
>>>> If your BIOS is too dumb, just try enabling it directly (bits 0-4 of
>>>> PCI configuration register 0x58 in function 3 of the CPU's northbridge
>>>> device, see the BIOS and Kernel's Developer's Guide for details).
>>>
>>> Or even better, if on AMD, you can build the amd64_edac module
>>> (CONFIG_EDAC_AMD64) and do
>>>
>>> echo  > /sys/devices/system/edac/mc/mc/sdram_scrub_rate
>>>
>>> where x is the scrubbing bandwidth in bytes/sec and y is the memory
>>> controller on the machine, i.e. node.
>>
>> Unfortunately that also isn't an option on my platform(s). There surely must be a way for a module to be able to get a mapping for each physical page of memory in the system and to be able to use that mapping to do atomic read/writes to scrub the memory.
> 
> For such questions I've added just the right ML to Cc :).

There was a thread back in 2009 cwith the subject "marching through all
physical memory in software" that discussed some of the issues of a
software background scrub.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
