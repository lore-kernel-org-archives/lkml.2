Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1ALQ1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:27:48 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45148 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab1ALQ1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:27:45 -0500
Message-ID: <4D2DD629.1080701@oracle.com>
Date: Wed, 12 Jan 2011 08:26:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] module: fix build when DEBUGP is defined
References: <20110111172153.e43e03b8.randy.dunlap@oracle.com> <201101121918.21079.rusty@rustcorp.com.au>
In-Reply-To: <201101121918.21079.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/11 00:48, Rusty Russell wrote:
> On Wed, 12 Jan 2011 11:51:53 am Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix module loader build when DEBUGP is defined.
>> Fixes build error & warning:
>>
>> kernel/module.c:1910: error: 'name' undeclared (first use in this function)
>> kernel/module.c:2567: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'Elf64_Addr'
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> ---
>>  kernel/module.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- linux-next-20110111.orig/kernel/module.c
>> +++ linux-next-20110111/kernel/module.c
>> @@ -1907,7 +1907,7 @@ static void layout_sections(struct modul
>>  			    || strstarts(sname, ".init"))
>>  				continue;
>>  			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
>> -			DEBUGP("\t%s\n", name);
>> +			DEBUGP("\t%s\n", sname);
>>  		}
>>  		switch (m) {
>>  		case 0: /* executable */
>> @@ -2563,7 +2563,7 @@ static int move_module(struct module *mo
>>  			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
>>  		/* Update sh_addr to point to copy in image. */
>>  		shdr->sh_addr = (unsigned long)dest;
>> -		DEBUGP("\t0x%lx %s\n",
>> +		DEBUGP("\t0x%llx %s\n",
>>  		       shdr->sh_addr, info->secstrings + shdr->sh_name);
> 
> This will break on 32-bit.  We really need a cast to long here :(

Really?  I built it on i386 and x86_64 (successfully).

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
