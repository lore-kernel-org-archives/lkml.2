Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066Ab2HWDcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 23:32:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:44621 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab2HWDcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 23:32:09 -0400
Message-ID: <5035A286.3090508@windriver.com>
Date: Thu, 23 Aug 2012 11:24:54 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: <benh@kernel.crashing.org>, <jason.wessel@windriver.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [v2][PATCH 3/3] powerpc/kgdb: restore current_thread_info properly
References: <1345687820-5248-1-git-send-email-tiejun.chen@windriver.com>  <1345687820-5248-3-git-send-email-tiejun.chen@windriver.com> <1345691650.10190.31.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1345691650.10190.31.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 11:14 AM, Nicholas A. Bellinger wrote:
> On Thu, 2012-08-23 at 10:10 +0800, Tiejun Chen wrote:
>> For powerpc BooKE and e200, singlestep is handled on the critical/dbg
>> exception stack. This causes current_thread_info() to fail for kgdb
>> internal, so previously We work around this issue by copying
>> the thread_info from the kernel stack before calling kgdb_handle_exception,
>> and copying it back afterwards.
>>
>> But actually we don't do this properly. We should backup current_thread_info
>> then restore that when exit.
>>
>> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
>> ---
>> v2: fix a typo in patch head description.
>>
>>  arch/powerpc/kernel/kgdb.c |   11 +++++++++--
>>  1 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
>> index 05adb69..c470a40 100644
>> --- a/arch/powerpc/kernel/kgdb.c
>> +++ b/arch/powerpc/kernel/kgdb.c
>> @@ -25,6 +25,7 @@
>>  #include <asm/processor.h>
>>  #include <asm/machdep.h>
>>  #include <asm/debug.h>
>> +#include <linux/slab.h>
>>  
>>  /*
>>   * This table contains the mapping between PowerPC hardware trap types, and
>> @@ -153,6 +154,8 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
>>  static int kgdb_singlestep(struct pt_regs *regs)
>>  {
>>  	struct thread_info *thread_info, *exception_thread_info;
>> +	struct thread_info *backup_current_thread_info = \
>> +		(struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
>>  
> 
> Looks like a rouge '\' in the above assignment..

Remove that :)

Thanks
Tiejun
