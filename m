Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab0ILSwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:52:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32296 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab0ILSwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:52:46 -0400
Message-ID: <4C8D210D.8080307@oracle.com>
Date: Sun, 12 Sep 2010 11:50:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: lkml <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] PM_SLEEP_SMP: fix kconfig warning
References: <20100911155720.c4fe6b4b.randy.dunlap@oracle.com> <201009121926.08633.rjw@sisk.pl>
In-Reply-To: <201009121926.08633.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/10 10:26, Rafael J. Wysocki wrote:
> On Sunday, September 12, 2010, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix kconfig unmet dependency warning:
>>
>> warning: (PM_SLEEP_SMP && SMP && (ARCH_SUSPEND_POSSIBLE || ARCH_HIBERNATION_POSSIBLE) && PM_SLEEP) selects HOTPLUG_CPU which has unmet direct dependencies (SMP && HOTPLUG)
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>>  kernel/power/Kconfig |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- linux-next-20100908.orig/kernel/power/Kconfig
>> +++ linux-next-20100908/kernel/power/Kconfig
>> @@ -83,7 +83,7 @@ config PM_TRACE_RTC
>>  
>>  config PM_SLEEP_SMP
>>  	bool
>> -	depends on SMP
>> +	depends on SMP && HOTPLUG
>>  	depends on ARCH_SUSPEND_POSSIBLE || ARCH_HIBERNATION_POSSIBLE
>>  	depends on PM_SLEEP
>>  	select HOTPLUG_CPU
> 
> I'm afraid that may cause some people to find that suspend is not compiled in
> to their surprise.
> 
> Would it be possible to select both HOTPLUG and HOTPLUG_CPU instead (ie. would
> that work)?

That appears to work in my testing.  I'll ack your patch.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
