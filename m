Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044Ab2KPIq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:46:26 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:35626 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2KPIqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:46:25 -0500
Message-ID: <50A5FD5C.5030505@numascale-asia.com>
Date: Fri, 16 Nov 2012 16:46:20 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3, v5] AMD64 EDAC: Add muli-domain support
References: <1352095526-6522-1-git-send-email-daniel@numascale-asia.com> <20121112132436.GC5162@x1.osrc.amd.com>
In-Reply-To: <20121112132436.GC5162@x1.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 21:24, Borislav Petkov wrote:
> On Mon, Nov 05, 2012 at 02:05:24PM +0800, Daniel J Blueman wrote:
>> Fix the handling of memory controller detection to index the array
>> of detected Northbridges, allowing memory controllers over multiple
>> PCI domains in federated systems eg using Numascale's NumaConnect/
>> NumaChip.
>>
>> v4: Generate linear Northbridge ID by indexing detected Northbridges
>> v5: Reorder functions to prevent extra function declaration; merge 4th
>>      patch; simplify Fam15h code; add detail to warning
>>
>> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
>
> Acked-by: Borislav Petkov <bp@alien8.de>
>
> Btw, I don't have access to a multi-socket single-board AMD system right
> now so would you please test the patchset on such a system too, if you
> haven't done so yet?
>
> Thanks a lot.

Yep, the expected memory controller indexes, population, column-strobe 
rows, banks and sysfs paths are detected on my hex-northbridge fam10h 
box with 3.7-rc5 with these patches:

EDAC MC: Ver: 3.0.0
AMD64 EDAC driver v3.4.0
EDAC amd64: DRAM ECC enabled.
EDAC amd64: F10h detected (node 0).
EDAC MC: DCT0 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2: 4096MB 3: 4096MB
EDAC amd64: MC: 4:   0MB 5:   0MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC MC: DCT1 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2: 4096MB 3: 4096MB
EDAC amd64: MC: 4:   0MB 5:   0MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC amd64: using x8 syndromes.
EDAC amd64: MCT channel count: 2
EDAC amd64: CS2: Registered DDR3 RAM
EDAC amd64: CS3: Registered DDR3 RAM
EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
EDAC amd64: DRAM ECC enabled.
EDAC amd64: F10h detected (node 1).
EDAC MC: DCT0 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2: 4096MB 3: 4096MB
EDAC amd64: MC: 4:   0MB 5:   0MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC MC: DCT1 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2: 4096MB 3: 4096MB
EDAC amd64: MC: 4:   0MB 5:   0MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC amd64: using x8 syndromes.
EDAC amd64: MCT channel count: 2
EDAC amd64: CS2: Registered DDR3 RAM
EDAC amd64: CS3: Registered DDR3 RAM
EDAC MC1: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:19.2
EDAC amd64: DRAM ECC enabled.
EDAC amd64: F10h detected (node 2).
EDAC MC: DCT0 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2: 4096MB 3: 4096MB
EDAC amd64: MC: 4:   0MB 5:   0MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC MC: DCT1 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2: 4096MB 3: 4096MB
EDAC amd64: MC: 4:   0MB 5:   0MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC amd64: using x8 syndromes.
EDAC amd64: MCT channel count: 2
EDAC amd64: CS2: Registered DDR3 RAM
EDAC amd64: CS3: Registered DDR3 RAM
EDAC MC2: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:1a.2
EDAC amd64: DRAM ECC enabled.
EDAC amd64: F10h detected (node 3).
EDAC MC: DCT0 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2: 4096MB 3: 4096MB
EDAC amd64: MC: 4:   0MB 5:   0MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC MC: DCT1 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2: 4096MB 3: 4096MB
EDAC amd64: MC: 4:   0MB 5:   0MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC amd64: using x8 syndromes.
EDAC amd64: MCT channel count: 2
EDAC amd64: CS2: Registered DDR3 RAM
EDAC amd64: CS3: Registered DDR3 RAM
EDAC MC3: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:1b.2
EDAC amd64: DRAM ECC enabled.
EDAC amd64: F10h detected (node 4).
EDAC MC: DCT0 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2: 4096MB 3: 4096MB
EDAC amd64: MC: 4:   0MB 5:   0MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC MC: DCT1 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2: 4096MB 3: 4096MB
EDAC amd64: MC: 4:   0MB 5:   0MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC amd64: using x8 syndromes.
EDAC amd64: MCT channel count: 2
EDAC amd64: CS2: Registered DDR3 RAM
EDAC amd64: CS3: Registered DDR3 RAM
EDAC MC4: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:1c.2
EDAC amd64: DRAM ECC enabled.
EDAC amd64: F10h detected (node 5).
EDAC MC: DCT0 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2: 4096MB 3: 4096MB
EDAC amd64: MC: 4:   0MB 5:   0MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC MC: DCT1 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2: 4096MB 3: 4096MB
EDAC amd64: MC: 4:   0MB 5:   0MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC amd64: using x8 syndromes.
EDAC amd64: MCT channel count: 2
EDAC amd64: CS2: Registered DDR3 RAM
EDAC amd64: CS3: Registered DDR3 RAM
EDAC MC5: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:1d.2
EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI 
controller': DEV '0000:00:18.2' (POLLED)

root@ibm-x3755-01:/sys/devices/system/edac# ls -d mc/mc*/{rank*,csrow*}
mc/mc0/csrow2  mc/mc1/csrow2  mc/mc2/csrow2  mc/mc3/csrow2 
mc/mc4/csrow2  mc/mc5/csrow2
mc/mc0/csrow3  mc/mc1/csrow3  mc/mc2/csrow3  mc/mc3/csrow3 
mc/mc4/csrow3  mc/mc5/csrow3
mc/mc0/rank10  mc/mc1/rank10  mc/mc2/rank10  mc/mc3/rank10 
mc/mc4/rank10  mc/mc5/rank10
mc/mc0/rank11  mc/mc1/rank11  mc/mc2/rank11  mc/mc3/rank11 
mc/mc4/rank11  mc/mc5/rank11
mc/mc0/rank2   mc/mc1/rank2   mc/mc2/rank2   mc/mc3/rank2   mc/mc4/rank2 
   mc/mc5/rank2
mc/mc0/rank3   mc/mc1/rank3   mc/mc2/rank3   mc/mc3/rank3   mc/mc4/rank3 
   mc/mc5/rank3
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
