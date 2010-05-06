Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0EFCdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 22:33:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52340 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab0EFCdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 22:33:37 -0400
Message-ID: <4BE22A2D.8070301@oracle.com>
Date: Wed, 05 May 2010 19:32:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: Re: [PATCH -next] staging/rar_register: depends on PCI
References: <20100505123409.ed5678a2.sfr@canb.auug.org.au>	<20100505154522.c3d7807c.randy.dunlap@oracle.com> <20100506005557.7d458c7b@lxorguk.ukuu.org.uk>
In-Reply-To: <20100506005557.7d458c7b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090209.4BE22A70.0169:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/10 16:55, Alan Cox wrote:
> On Wed, 5 May 2010 15:45:22 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> rar_register driver uses PCI interfaces and PCI devices, so it
>> should depend on PCI.
>>
>> Also format the Kconfig help text as normally done.
>>
>> drivers/staging/rar_register/rar_register.c:623: error: implicit declaration of function 'pci_dev_get'
>> drivers/staging/rar_register/rar_register.c:623: warning: assignment makes pointer from integer without a cast
>>
>> Note:  The memrar driver selects this driver's Kconfig symbol, even when
>> PCI is not enabled.  That select could be changed to
>> 	select RAR_REGISTER if PCI
>> but that would still result in build errors when PCI is not enabled, namely:
>> drivers/built-in.o: In function `memrar_fini_rar_resources':
>> memrar_handler.c:(.text+0x2391b7): undefined reference to `unregister_rar'
>> drivers/built-in.o: In function `memrar_registration_callback':
>> memrar_handler.c:(.text+0x23925a): undefined reference to `rar_get_address'
>> drivers/built-in.o: In function `memrar_init':
>> memrar_handler.c:(.init.text+0x12c7b): undefined reference to `register_rar'
>> memrar_handler.c:(.init.text+0x12c97): undefined reference to `register_rar'
>>
>> Does anyone have suggestions for this?
> 
> Yes - memrar should depend upon the RAR_REGISTER

memrar currently selects RAR_REGISTER, but I'll be happy to change
that to depends on...

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
