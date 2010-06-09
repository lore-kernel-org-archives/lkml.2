Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab0FIUGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 16:06:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59915 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab0FIUGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 16:06:34 -0400
Message-ID: <4C0FF3F0.2080601@oracle.com>
Date: Wed, 09 Jun 2010 13:05:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Daniel Oliveira Nascimento <don@syst.com.br>
Subject: Re: [PATCH -next] classmate-laptop: fix for RFKILL=m, CMPC=y
References: <20100603134753.710a64b3.sfr@canb.auug.org.au> <20100603093903.d9378c9a.randy.dunlap@oracle.com> <20100609200218.GD2551@barata.holoscopio.com>
In-Reply-To: <20100609200218.GD2551@barata.holoscopio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4C0FF43C.010C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/10 13:02, Thadeu Lima de Souza Cascardo wrote:
> On Thu, Jun 03, 2010 at 09:39:03AM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix build error when CONFIG_RFKILL=m and CONFIG_ACPI_CMPC=y:
>> classmate-laptop should depend on RFKILL or RFKILL=n.
>>
>> classmate-laptop.c:(.text+0x1351fc): undefined reference to `rfkill_unregister'
>> classmate-laptop.c:(.text+0x135204): undefined reference to `rfkill_destroy'
>> classmate-laptop.c:(.text+0x135237): undefined reference to `rfkill_set_sw_state'
>> classmate-laptop.c:(.text+0x1352b9): undefined reference to `rfkill_alloc'
>> classmate-laptop.c:(.text+0x1352ca): undefined reference to `rfkill_register'
>> classmate-laptop.c:(.text+0x1352d6): undefined reference to `rfkill_destroy'
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
> 
> 
> Randy,
> 
> Since this implies a build failure, shouldn't it be sent for rc too?

Yes, it should.
I hit the problem during a linux-next build, but it does apply to mainline as well.
Thanks.


>>  drivers/platform/x86/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> --- linux-next-20100603.orig/drivers/platform/x86/Kconfig
>> +++ linux-next-20100603/drivers/platform/x86/Kconfig
>> @@ -520,6 +520,7 @@ config TOSHIBA_BT_RFKILL
>>  config ACPI_CMPC
>>  	tristate "CMPC Laptop Extras"
>>  	depends on X86 && ACPI
>> +	depends on RFKILL || RFKILL=n
>>  	select INPUT
>>  	select BACKLIGHT_CLASS_DEVICE
>>  	default n


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
