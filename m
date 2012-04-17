Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab2DQP3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:29:31 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:36293 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932111Ab2DQP3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:29:25 -0400
Message-ID: <4F8DB687.2090701@xenotime.net>
Date: Tue, 17 Apr 2012 11:29:27 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH -next] wireless: TI wlxxx depends on MAC80211
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>	 <4F8C784B.2040402@xenotime.net> <1334640620.27247.7.camel@cumari>
In-Reply-To: <1334640620.27247.7.camel@cumari>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 10:30 PM, Luciano Coelho wrote:

> Hi Randy,
> 
> On Mon, 2012-04-16 at 12:51 -0700, Randy Dunlap wrote: 
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> wl12xx build fails with many undefined symbol errors when MAC80211
>> and CFG80211 are not enabled, so make WLCORE and WL12XX depend
>> on MAC80211 (which already depends on CFG80211).
>>
>> Here are a few of the many build errors:
>>
> 
> [...]
> 
>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>> Cc:	Luciano Coelho <coelho@ti.com>
>> Cc:	linux-wireless@vger.kernel.org
>> Cc:	"John W. Linville" <linville@tuxdriver.com>
>> ---
> 
> Thanks for the patch!
> 
> 
>> --- linux-next-20120416.orig/drivers/net/wireless/ti/wl12xx/Kconfig
>> +++ linux-next-20120416/drivers/net/wireless/ti/wl12xx/Kconfig
>> @@ -1,5 +1,6 @@
>>  config WL12XX
>>         tristate "TI wl12xx support"
>> +	depends on MAC80211
>>         select WLCORE
> 
> Do we really need this one? wl12xx selects WLCORE which in turn depends
> on MAC80211 (with your change below).  Maybe we don't need this?

Hi,

[testing...]

The build fails if either one of these "depends" is omitted.


>> ---help---
>>  	  This module adds support for wireless adapters based on TI wl1271,
>> --- linux-next-20120416.orig/drivers/net/wireless/ti/wlcore/Kconfig
>> +++ linux-next-20120416/drivers/net/wireless/ti/wlcore/Kconfig
>> @@ -1,6 +1,6 @@
>>  config WLCORE
>>  	tristate "TI wlcore support"
>> -	depends on WL_TI && GENERIC_HARDIRQS
>> +	depends on WL_TI && GENERIC_HARDIRQS && MAC80211
>>  	depends on INET
>>  	select FW_LOADER
>>  	---help---
> 



-- 
~Randy
