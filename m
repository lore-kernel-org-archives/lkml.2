Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab0KAAJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 20:09:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58829 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab0KAAJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 20:09:40 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4CCE05A8.1080005@np.css.fujitsu.com>
Date: Mon, 01 Nov 2010 09:11:20 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H.Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] [x86, next] Add mce_sys_info interface for debug.
References: <4CCA50AF.1030302@np.css.fujitsu.com> <20101029072426.GB29995@liondog.tnic>
In-Reply-To: <20101029072426.GB29995@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Borislav Petkov

Thanks for your review. Because this patch will be canceled, I could not
update it as your comment. But I will do other patches as your comment.

Thanks again.

Best Regards,
Jin Dongming

(2010/10/29 16:24), Borislav Petkov wrote:
> On Fri, Oct 29, 2010 at 01:42:23PM +0900, Jin Dongming wrote:
>> Add mce_sys_info interface for testing mce.
>>
>> Following is the reason why the interface is needed:
>>   1. Sometimes before testing mce, we want to know the basic
>>      information of mce on the test machine. Though there are
>>      some provided interfaces, there are some kernel variables
>>      which could not be known still.
>>   2. When we inject mce data to test mce, the value of some
>>      interfaces may be changed. It is hard for everybody to confirm
>>      all the information of mce on the system.
>>
>> This interface could help us know what has happened and make mce test
>> become easier.
>>
>> The content of mce_sys_info will be like following:
>>
>>   MCE status:                      Original/(Current) Value
>>       mce_disabled:                N
>>
>>       mce_ser:                     0/1
>>       tolerant:                    1/1
>>       panic_on_oops:               0/0
>>       monarch_timeout:             1000000/1000000 us
>>       mce_ignore_ce:               0/0
>>       mce_cmci_disabled:           N/N
>>
>>   MCG Register:
>>       CAP_Reg_Val           BANKS    EXT_CNT    FUNCTIONS
>>       0x0000000000000806    0x06     0x00       TES
>>
>> Please note that it is used for testing only.
>>
>> I tested this patch on Intel64 next-tree.
>>
>> Signe-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
>> ---
>>  arch/x86/kernel/cpu/mcheck/mce.c |  126 ++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 126 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
>> index ed10e76..91108db 100644
>> --- a/arch/x86/kernel/cpu/mcheck/mce.c
>> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
>> @@ -97,6 +97,25 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
>>  static DEFINE_PER_CPU(struct mce, mces_seen);
>>  static int			cpu_missing;
>>  
>> +#ifdef CONFIG_DEBUG_FS
>> +struct mce_sys_info {
>> +	int mce_disabled;
>> +
>> +	u64 mcg_cap_register;
>> +
>> +	int mce_ser;
>> +	int tolerant;
>> +	int panic_on_oops;
>> +	int monarch_timeout;
>> +	int mce_cmci_disable;
>> +	int mce_ignore_ce;
>> +	int mce_cmci_disabled;
> 
> Most of those could be put in a flags vector, thus saving a bunch of
> space. Or a bitfield...
> 


