Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0JNPrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:47:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18931 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab0JNPrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:47:07 -0400
Message-ID: <4CB725E2.9020506@oracle.com>
Date: Thu, 14 Oct 2010 08:46:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH -next] mmc: fix cb710 kconfig dependency warning
References: <20101013181519.6ff00e10.randy.dunlap@oracle.com> <20101014090442.GA14454@rere.qmqm.pl>
In-Reply-To: <20101014090442.GA14454@rere.qmqm.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/10 02:04, Micha³ Miros³aw wrote:
> On Wed, Oct 13, 2010 at 06:15:19PM -0700, Randy Dunlap wrote:
>> Fix kconfig dependency warning to satisfy dependencies:
>>
>> warning: (MMC_CB710 && MMC && PCI) selects CB710_CORE which has unmet direct dependencies (MISC_DEVICES && PCI)
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: <mirq-linux@rere.qmqm.pl>
>> ---
>>  drivers/mmc/host/Kconfig |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- linux-next-20101013.orig/drivers/mmc/host/Kconfig
>> +++ linux-next-20101013/drivers/mmc/host/Kconfig
>> @@ -394,7 +394,7 @@ config MMC_TMIO
>>  
>>  config MMC_CB710
>>  	tristate "ENE CB710 MMC/SD Interface support"
>> -	depends on PCI
>> +	depends on PCI && MISC_DEVICES
>>  	select CB710_CORE
>>  	help
>>  	  This option enables support for MMC/SD part of ENE CB710/720 Flash
> 
> Is this really necessary? MISC_DEVICES is only a submenu enabler, not
> a real dependency.
> 
> Maybe just select MISC_DEVICES instead? User/developer should not have
> to know that for this specific MMC controller he has to first enable some
> other device burried somewhere in the config tree.

Yes, I'll resubmit using "select".  (like I did with another mmc + memstick patch)

thanks,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
