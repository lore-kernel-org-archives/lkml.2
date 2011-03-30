Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1C3R6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:58:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60169 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab1C3R6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:58:21 -0400
Message-ID: <4D936F2D.4000902@kernel.org>
Date: Wed, 30 Mar 2011 10:58:05 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: another pagetable initialization crash on xen
References: <alpine.DEB.2.00.1103281729190.5516@kaball-desktop> <alpine.DEB.2.00.1103281929390.5516@kaball-desktop> <alpine.DEB.2.00.1103291620560.16492@kaball-desktop> <4D9221DA.90900@kernel.org> <alpine.DEB.2.00.1103301714250.16492@kaball-desktop> <alpine.DEB.2.00.1103301748380.16492@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1103301748380.16492@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D936F38.00C7,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 09:59 AM, Stefano Stabellini wrote:
> On Wed, 30 Mar 2011, Stefano Stabellini wrote:
>> I have another unrelated question: init_memory_mapping is called on the
>> range 0 - max_low_pfn, but that range usually includes a reserved region
>> below the first MB. On one machine of mine the IOAPIC mmio region falls
>> in that memory range therefore we are mapping the IOAPIC mmio region in
>> init_memory_mapping without going through the fixmap as we should.
>> This is causing problems on Xen, but I guess it could theoretically
>> cause problems on other platforms as well. Should we avoid reserved
>> memory regions below the first MB from the initial memory mappings?
>
> Sorry I mixed up frame numbers with physical addresses, so the IOAPIC
> mmio region is actually at 0xfec00000 where it should be but it gets
> mapped during the initial memory mapping (range 0 - 0x100000000).
> Is that supposed to happen? Shouldn't it go through the fixmap?

io apic addr is going through fixmap.

initial_memory_mapping will map to [0, max_mem_under_4g).
max_mem_under_4g is from E820 table searching.

later it will map [4g, max_mem_above_4g).

We do not map mmio gap between [max_mem_under_4g,4g)

Thanks

Yinghai
