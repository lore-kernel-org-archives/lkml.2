Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2GIJSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:18:06 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:43139 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab2GIJSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:18:03 -0400
Message-ID: <4FFAA463.1020608@linux.vnet.ibm.com>
Date: Mon, 09 Jul 2012 14:59:07 +0530
From: preeti <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: linux-next: comment on pm tree commit
References: <20120709094013.88a1117c9ef4510555147280@canb.auug.org.au> <201207091024.34585.rjw@sisk.pl>
In-Reply-To: <201207091024.34585.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
x-cbid: 12070909-4790-0000-0000-0000039A2717
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 01:54 PM, Rafael J. Wysocki wrote:
> On Monday, July 09, 2012, Stephen Rothwell wrote:
>> Hi Rafael,
>>
>> I noticed commit b8eec56cd8e5 ("PM / cpuidle: System resume hang fix with
>> cpuidle") in the pm tree needs some work (I noticed it because it was
>> changed in a rebase ...).
>>
>> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
>> index a6b3f2e..b90ccb2 100644
>> --- a/include/linux/cpuidle.h
>> +++ b/include/linux/cpuidle.h
>> @@ -146,6 +146,8 @@ extern void cpuidle_unregister_device(struct cpuidle_device *dev);
>>  
>>  extern void cpuidle_pause_and_lock(void);
>>  extern void cpuidle_resume_and_unlock(void);
>> +extern void cpuidle_pause(void);
>> +extern void cpuidle_resume(void);
>>  extern int cpuidle_enable_device(struct cpuidle_device *dev);
>>  extern void cpuidle_disable_device(struct cpuidle_device *dev);
>>  extern int cpuidle_wrap_enter(struct cpuidle_device *dev,
>> @@ -169,6 +171,8 @@ static inline void cpuidle_unregister_device(struct cpuidle_device *dev) { }
>>  
>>  static inline void cpuidle_pause_and_lock(void) { }
>>  static inline void cpuidle_resume_and_unlock(void) { }
>> +static inline cpuidle_pause(void) { }
>> +static inline cpuidle_resume(void) { }
>>
>> These need to be "static inline void".  I wonder what review and build
>> testing this went through (the above should produce warnings since they
>> are non void returning functions with no return statements).
> 
> Thanks for reporting this, I tried to fix a build issue in the original patch

I apologise for not having taken care of the above build scenario.

> hastily and failed miserably as you have noticed and then I build-tested a
> wrong tree.  Sorry.
> 
> It should be fixed now for real.
> 
> Thanks,
> Rafael
> 

Regards
Preeti

