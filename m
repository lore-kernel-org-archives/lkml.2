Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1GMQTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 12:19:36 -0400
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:42871 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab1GMQTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 12:19:35 -0400
Message-ID: <4E1DC535.1030000@genband.com>
Date: Wed, 13 Jul 2011 10:17:57 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: MK <mk@cognitivedissonance.ca>, linux-kernel@vger.kernel.org
Subject: Re: AVX "Sandy Bridge" hardware issue?
References: <20110712161616.b5196a3b.mk@cognitivedissonance.ca> <m2k4bn57j4.fsf@firstfloor.org>
In-Reply-To: <m2k4bn57j4.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2011 16:17:57.0916 (UTC) FILETIME=[6DB1EDC0:01CC4178]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18258.000
X-TM-AS-Result: No--16.637300-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 06:49 PM, Andi Kleen wrote:
> MK<mk@cognitivedissonance.ca>  writes:
>>
>> In which Andreas Schwab points out (rightly or wrongly) that according
>> to the /proc/cpuinfo from the slice, the processor actually does not
>> support AVX.  However,  the "model name", "Intel(R) Xeon(R) CPU
>> E31230", is according to this a Sandy Bridge processor with AVX:
>
> If it's in a VM then the VM may not expose AVX to the guest
> (the VMs have to do that explicitely because AVX has additional state).
> If it's not in /proc/cpuinfo on the guest that's likely the case.

The OP mentioned that he's using OpenVZ, so it's running in a container 
(chroot on steroids), not a "true" VM.

Each instance runs the same kernel, they're isolated from the other 
instances using filesystem/process/network namespaces.

That said, /proc/cpuinfo is virtualized somehow by the containerization 
since it shows only the cpus assigned to the container--it seems 
plausible that they screwed up the cpu flags while doing it.

I think your suggestion of talking to the vendor is the correct next step.

Chris


-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
