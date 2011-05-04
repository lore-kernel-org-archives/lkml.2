Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab1EDAUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 20:20:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50323 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683Ab1EDAUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 20:20:24 -0400
Message-ID: <4DC09BBA.6040906@zytor.com>
Date: Tue, 03 May 2011 17:20:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v3] x86: allow ZONE_DMA to be configurable
References: <alpine.DEB.2.00.1104141134260.386@chino.kir.corp.google.com> <4DA82F33.7080403@ladisch.de> <4DA8A5CE.2010004@zytor.com> <alpine.DEB.2.00.1104201929170.15661@chino.kir.corp.google.com> <4DAFAD9F.4020809@zytor.com> <alpine.DEB.2.00.1104271637310.25369@chino.kir.corp.google.com> <alpine.DEB.2.00.1105031700380.26030@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1105031700380.26030@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2011 05:00 PM, David Rientjes wrote:
> On Wed, 27 Apr 2011, David Rientjes wrote:
> 
>> ZONE_DMA is unnecessary for a large number of machines that do not
>> require addressing in the lower 16MB of memory because they do not use
>> devices with 16-bit address registers (plus one page byte register).
>>
>> This patch allows users to disable ZONE_DMA for x86 if they know they
>> will not be using such devices with their kernel.
>>
>> This prevents the VM from unnecessarily reserving a ratio of memory
>> (defaulting to 1/256th of system capacity) with lowmem_reserve_ratio
>> for such allocations when it will never be used.
>>
>> Signed-off-by: David Rientjes <rientjes@google.com>
> 
> Peter, is this ready for merge?


+ DMA memory allocation support allows devices with 16-bit address
+ registers to allocate memory within the first 16MB of address space.
+ Disable if no such devices will be used.

This is still not correct... this is for devices with less than a 32-bit
mask, not just for things that have 24-bit (not 16-bit!) DMA address
restrictions.

Please get this right.

Other than that, I don't have any technical objections.

	-hpa
