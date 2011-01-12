Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1ALRzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:55:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:19529 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab1ALRzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:55:07 -0500
Message-ID: <4D2DE97C.2000205@oracle.com>
Date: Wed, 12 Jan 2011 09:48:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-acpi@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        akpm <akpm@linux-foundation.org>, Zhang Rui <rui.zhang@intel.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>
Subject: on builds/randconfigs (was: [PATCH -next] thermal: depends on NET)
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au> <20101213112033.d0060e6c.randy.dunlap@oracle.com> <20110110090059.6f4d739d.randy.dunlap@oracle.com> <alpine.LFD.2.02.1101120008590.19140@x980>
In-Reply-To: <alpine.LFD.2.02.1101120008590.19140@x980>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/11 21:18, Len Brown wrote:
>>> --- linux-next-20101213.orig/drivers/thermal/Kconfig
>>> +++ linux-next-20101213/drivers/thermal/Kconfig
>>> @@ -4,6 +4,7 @@
>>>  
>>>  menuconfig THERMAL
>>>  	tristate "Generic Thermal sysfs driver"
>>> +	depends on NET
> 
> I've added this line to the offending patch.

Thank you.

> While I agree that randconfig build testing
> is theoretically useful, in recent memory
> its results do not seem particularly relevant
> to useful configs.

Who defines useful?
"what is good for the goose is not good for the gander"

> Perhaps it would be a good idea to spend some time
> making non-useful configs impossible, and thus focus
> the testing where it will be of more benefit?

We have a plethora of kernel configs, so yes,
I'd be glad to see your efforts in that area.


Here's my take on kernel builds:

Ideally (randconfig) build testing wouldn't be needed
and developers would:

- know what kernel facilities their code uses and #include
  header files for all of them

- know what kernel configs their code uses and make their code
  depend on or select the needed config symbols

- actually read & review build output to look for errors and
  warnings in their code and not ignore them but actually fix them

- use sparse to check for other warnings

The current attitude of "if it builds, then it must be OK"
is not good.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
