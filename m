Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2BUM4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 07:56:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45168 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab2BUM4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 07:56:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of daniel@numascale-asia.com designates 10.204.152.75 as permitted sender) smtp.mail=daniel@numascale-asia.com
Message-ID: <4F43948D.8070709@numascale-asia.com>
Date: Tue, 21 Feb 2012 12:56:45 +0000
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Steffen Persvold <sp@numascale.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] x86: Remove wrong error message in x86_default_fixup_cpu_id
References: <20120220171705.GA17069@alberich.amd.com> <20120221102725.GC14274@aftab> <4F437A71.6000402@numascale-asia.com> <20120221112042.GE14274@aftab>
In-Reply-To: <20120221112042.GE14274@aftab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/02/2012 11:20, Borislav Petkov wrote:
> On Tue, Feb 21, 2012 at 11:05:21AM +0000, Daniel J Blueman wrote:
>> The check and fixup wasn't needed in the Intel path thus far, so
>> wasn't added.
>>
>> We could specialise the 'if (c->phys_proc_id != node)' test to check
>> for x86_cpuinit.fixup_cpu_id being NULL and drop the default
>> override, if that is preferred?
> Before that, why do you need that check in the AMD path at all? Please
> give a more detailed explanation as to why is it needed on the AMD path
> at all.

Since Numascale's NumaConnect bridges multiple separate HyperTransport 
fabrics across multiple servers together, the HT IDs written in the 
hardware thus don't match the information in the SRAT table constructed 
in the bootloader, thus we need to set this to the logical value [1, 
'fixup_cpu_id'].

[1] https://lkml.org/lkml/2011/12/5/292

-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia

