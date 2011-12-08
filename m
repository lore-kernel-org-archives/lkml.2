Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1LHVSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 16:18:30 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:17821 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1LHVS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 16:18:29 -0500
Message-ID: <4EE12948.30508@oracle.com>
Date: Thu, 08 Dec 2011 13:16:56 -0800
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111101 SUSE/3.1.16 Thunderbird/3.1.16
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Peter Jones <pjones@redhat.com>, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2] ibft: Fix finding IBFT ACPI table on UEFI
References: <4EE073BB.6080403@oracle.com> <20111208142958.GA4096@andromeda.dapyr.net> <4EE0EB51.5010900@oracle.com> <20111208190808.GA25433@andromeda.dapyr.net>
In-Reply-To: <20111208190808.GA25433@andromeda.dapyr.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4EE12971.0015,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 11:08 AM, Konrad Rzeszutek Wilk wrote:

> On Thu, Dec 08, 2011 at 08:52:33AM -0800, Yinghai Lu wrote:
>>
>> Found one system with UEFI/iBFT, Kernel does not detect the iBFT during
>                                    ^^^^^ - lowercase 'kernel' please.
>> iscsi_ibft module loading.
> 
> I get this when compiling it:
> 
> Setup is 16588 bytes (padded to 16896 bytes).
> System is 6277 kB
> CRC 7fe65506
> Kernel: arch/x86/boot/bzImage is ready  (#2)
> ERROR: "find_ibft_region" [drivers/firmware/iscsi_ibft.ko] undefined!
> 
> This is on i386 x86 build when doing 'make allmodconfig'.


then will need more cleaner change.

> 
>>
>> the root cause: for x86, We have calling of find_ibft_region() much early.
>                           ^^ - You only need to uppercase it if you
> start a sentence - which is not what you are doing. So please make it
> lowercase.
>> in setup_arch() before ACPI is enabled.
> 
> This is what I changed the git description to:
> 
>  Root cause: on x86 (UEFI), we are calling find_ibft_region() much
>  earlier - specifically in setup_arch() before ACPI is enabled.
> 


will use that...

Thanks

Yinghai
