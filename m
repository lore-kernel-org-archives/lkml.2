Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab2CQDoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 23:44:06 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:35281 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752184Ab2CQDoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 23:44:02 -0400
Message-ID: <4F640880.30809@xenotime.net>
Date: Fri, 16 Mar 2012 20:44:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        corentincj@iksaif.net, mjg@redhat.com, rientjes@google.com
Subject: Re: + drivers-platform-x86-samsung-laptopc-fix-build.patch added
 to -mm tree
References: <20120316233728.857605C0050@hpza9.eem.corp.google.com> <4F6407EF.5080403@xenotime.net>
In-Reply-To: <4F6407EF.5080403@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 08:41 PM, Randy Dunlap wrote:

> On 03/16/2012 03:53 PM, akpm@linux-foundation.org wrote:
> 
>> The patch titled
>>      Subject: drivers/platform/x86/samsung-laptop.c: fix build
>> has been added to the -mm tree.  Its filename is
>>      drivers-platform-x86-samsung-laptopc-fix-build.patch
>>
> 
> 
> See https://lkml.org/lkml/2012/3/14/25
> and https://lkml.org/lkml/2012/3/14/27
> from David Reintjes.


Make that David Rientjes...


> 
> 
>>
>> ------------------------------------------------------
>> From: Andrew Morton <akpm@linux-foundation.org>
>> Subject: drivers/platform/x86/samsung-laptop.c: fix build
>>
>> gcc-4.4.4:
>>
>> drivers/platform/x86/samsung-laptop.c: In function 'sabi_set_commandb':
>> drivers/platform/x86/samsung-laptop.c:433: error: unknown field 'd0' specified in initializer
>> drivers/platform/x86/samsung-laptop.c:433: warning: missing braces around initializer
>> drivers/platform/x86/samsung-laptop.c:433: warning: (near initialization for 'in.<anonymous>')
>> drivers/platform/x86/samsung-laptop.c:433: error: unknown field 'd1' specified in initializer
>> drivers/platform/x86/samsung-laptop.c:433: warning: excess elements in struct initializer
>> drivers/platform/x86/samsung-laptop.c:433: warning: (near initialization for 'in')
>> drivers/platform/x86/samsung-laptop.c:433: error: unknown field 'd2' specified in initializer
>> drivers/platform/x86/samsung-laptop.c:433: warning: excess elements in struct initializer
>> drivers/platform/x86/samsung-laptop.c:433: warning: (near initialization for 'in')
>> drivers/platform/x86/samsung-laptop.c:433: error: unknown field 'd3' specified in initializer
>> drivers/platform/x86/samsung-laptop.c:433: warning: excess elements in struct initializer
>> drivers/platform/x86/samsung-laptop.c:433: warning: (near initialization for 'in')
>> drivers/platform/x86/samsung-laptop.c: At top level:
>> drivers/platform/x86/samsung-laptop.c:1108: warning: initialization from incompatible pointer type
>>
>> Cc: Corentin Chary <corentincj@iksaif.net>
>> Cc: Matthew Garrett <mjg@redhat.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  drivers/platform/x86/samsung-laptop.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff -puN drivers/platform/x86/samsung-laptop.c~drivers-platform-x86-samsung-laptopc-fix-build drivers/platform/x86/samsung-laptop.c
>> --- a/drivers/platform/x86/samsung-laptop.c~drivers-platform-x86-samsung-laptopc-fix-build
>> +++ a/drivers/platform/x86/samsung-laptop.c
>> @@ -430,7 +430,7 @@ exit:
>>  static int sabi_set_commandb(struct samsung_laptop *samsung,
>>  			     u16 command, u8 data)
>>  {
>> -	struct sabi_data in = { .d0 = 0, .d1 = 0, .d2 = 0, .d3 = 0 };
>> +	struct sabi_data in = { { { .d0 = 0, .d1 = 0, .d2 = 0, .d3 = 0 } } };
>>  
>>  	in.data[0] = data;
>>  	return sabi_command(samsung, command, &in, NULL);
>> _
>> Subject: Subject: drivers/platform/x86/samsung-laptop.c: fix build
> 
> 
> 



-- 
~Randy
