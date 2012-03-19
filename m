Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030292Ab2CSNwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:52:43 -0400
Received: from thoth.sbs.de ([192.35.17.2]:15861 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab2CSNwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:52:42 -0400
Message-ID: <4F673A20.9020505@siemens.com>
Date: Mon, 19 Mar 2012 14:52:32 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH 1/4] kgdb: x86: Return all segment registers also in 64-bit
 mode
References: <cover.1331900215.git.jan.kiszka@siemens.com> <04b93bdc9d3d8ea89dc42adf055ce1c0787bb91f.1331900215.git.jan.kiszka@siemens.com> <4F636307.1050404@windriver.com>
In-Reply-To: <4F636307.1050404@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-16 16:57, Jason Wessel wrote:
> On 03/16/2012 07:17 AM, Jan Kiszka wrote:
>> Even if the content is always 0, gdb expects us to return also ds,
>> es, fs, and gs while in x86-64 mode. Do this to avoid ugly errors on
>> "info registers".
>>
>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>> ---
>>  arch/x86/include/asm/kgdb.h |    6 +++++-
>>  arch/x86/kernel/kgdb.c      |    6 ++++--
>>  2 files changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kgdb.h b/arch/x86/include/asm/kgdb.h
>> index 77e95f5..e857f1a 100644
>> --- a/arch/x86/include/asm/kgdb.h
>> +++ b/arch/x86/include/asm/kgdb.h
>> @@ -64,9 +64,13 @@ enum regnames {
>>  	GDB_PS,			/* 17 */
>>  	GDB_CS,			/* 18 */
>>  	GDB_SS,			/* 19 */
>> +	GDB_DS,			/* 20 */
>> +	GDB_ES,			/* 21 */
>> +	GDB_FS,			/* 22 */
>> +	GDB_GS,			/* 23 */
>>  };
>>  #define GDB_ORIG_AX		57
>> -#define DBG_MAX_REG_NUM		20
>> +#define DBG_MAX_REG_NUM		24
>>  /* 17 64 bit regs and 3 32 bit regs */
>>  #define NUMREGBYTES		((17 * 8) + (3 * 4))
> 
> You bumped the register numbers correctly, but you also need to add the correct padding to the NUMREGBYTES or you might not get a large enough memory block for the register struct.
> 
> You added 2 32 bit regs, so it should change to:
> 
> /* 17 64 bit regs and 5 32 bit regs */
> #define NUMREGBYTES        ((17 * 8) + (5 * 4))
> 

Oops. Most probably explains the random gs content I saw these days in a
64-bit debugging session.

> 
> The rest should be fine.   I can test this and add it to the merge queue with the NUMREGBYTES change, unless you disagree.

I don't disagree. :)

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
