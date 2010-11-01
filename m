Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0KAAF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 20:05:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54582 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab0KAAF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 20:05:56 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4CCE04C7.3050803@np.css.fujitsu.com>
Date: Mon, 01 Nov 2010 09:07:35 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H.Peter Anvin" <hpa@zytor.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] [x86, next] Add mce_sys_info interface for debug.
References: <4CCA50AF.1030302@np.css.fujitsu.com> <20101029081003.GB11149@basil.fritz.box>
In-Reply-To: <20101029081003.GB11149@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andi

Thanks for your review.
I will cancel this patch.

But I suggested there is such kind of tool for mce test.
It really costs too much time to confirm them one by one.

Best Regards,
Jin Dongming

(2010/10/29 17:10), Andi Kleen wrote:
> On Fri, Oct 29, 2010 at 01:42:23PM +0900, Jin Dongming wrote:
>> Add mce_sys_info interface for testing mce.
>>
>> Following is the reason why the interface is needed:
>>   1. Sometimes before testing mce, we want to know the basic
>>      information of mce on the test machine. Though there are
>>      some provided interfaces, there are some kernel variables
>>      which could not be known still.
> 
> That doesn't make sense to me. AFAIK everything is either available
> in sysfs or printed in the kernel log or can be known by knowing 
> the hardware.
> 
>>   2. When we inject mce data to test mce, the value of some
>>      interfaces may be changed. It is hard for everybody to confirm
>>      all the information of mce on the system.
>>
>> This interface could help us know what has happened and make mce test
>> become easier.
> 
> 
> The new interface seems overkill to me.
> 
>>
>> The content of mce_sys_info will be like following:
>>
>>   MCE status:                      Original/(Current) Value
>>       mce_disabled:                N
> 
> Well you should know if you set that. It's also visible
> in the kernel log.
> 
>>
>>       mce_ser:                     0/1
> 
> That should be known or can be read directly.
> 
>>       tolerant:                    1/1
>>       panic_on_oops:               0/0
>>       monarch_timeout:             1000000/1000000 us
>>       mce_ignore_ce:               0/0
>>       mce_cmci_disabled:           N/N
> 
> These are all in sysfs or in the command line.
> 
> 
> 
>>
>>   MCG Register:
>>       CAP_Reg_Val           BANKS    EXT_CNT    FUNCTIONS
>>       0x0000000000000806    0x06     0x00       TES
> 
> You can just read that from /dev/cpu/*/msr if you really want it.
> No need to bloat the kernel.
> 
> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


