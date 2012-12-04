Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2LDJY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:24:28 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63921 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2LDJYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:24:22 -0500
Message-ID: <50BDC140.8060004@numascale-asia.com>
Date: Tue, 04 Dec 2012 17:24:16 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v8] AMD64 EDAC: Fix type usage in NB IDs and memory
 ranges
References: <1354265060-22956-1-git-send-email-daniel@numascale-asia.com> <1354265060-22956-2-git-send-email-daniel@numascale-asia.com> <20121130171749.GB23034@liondog.tnic>
In-Reply-To: <20121130171749.GB23034@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2012 01:17, Borislav Petkov wrote:
> On Fri, Nov 30, 2012 at 04:44:20PM +0800, Daniel J Blueman wrote:
>> Use appropriate types for northbridge IDs and memory ranges. Mark immutable
>> data const and keep within compilation unit on related structures. Tested on
>> multi-socket server and multi-server, multi-socket NumaConnect setup.
>>
>> v7: Refactor patches grouping changes
>> v8: Drop unneeded change; use const and static where appropriate
>>
>> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
>> ---
>>   arch/x86/include/asm/amd_nb.h |    2 +-
>>   drivers/edac/amd64_edac.c     |   26 +++++++++++++-------------
>>   drivers/edac/amd64_edac.h     |    6 +++---
>>   3 files changed, 17 insertions(+), 17 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
>> index 417eb24..d2e703b 100644
>> --- a/arch/x86/include/asm/amd_nb.h
>> +++ b/arch/x86/include/asm/amd_nb.h
>> @@ -76,7 +76,7 @@ static inline bool amd_nb_has_feature(unsigned feature)
>>   	return ((amd_northbridges.flags & feature) == feature);
>>   }
>>
>> -static inline struct amd_northbridge *node_to_amd_nb(int node)
>> +static inline struct amd_northbridge *node_to_amd_nb(u16 node)
>
> I'm dropping this change from this patch because if we go with it,
> we'll have to change all callsites of node_to_amd_nb which would cause
> unnecessary churn.

> So, I've applied the final patchset and uploaded a branch here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git numascale
>
> Please give it a run on both configurations and let me know if something
> is still amiss.

It works well on fam10h and fam15h boxes, with and without Numaconnect.

Thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
