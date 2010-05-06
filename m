Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0EFXlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:41:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27299 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab0EFXlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:41:04 -0400
Message-ID: <4BE35311.7030502@oracle.com>
Date: Thu, 06 May 2010 16:38:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Len Brown <lenb@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [linux-pm] linux-next: Tree for May 6 (acpi: PM=n)
References: <20100506151502.f97afe54.sfr@canb.auug.org.au> <20100506080538.b566f50e.randy.dunlap@oracle.com> <alpine.LFD.2.00.1005061623060.15286@localhost.localdomain> <20100506133215.f5dc579a.randy.dunlap@oracle.com> <alpine.LRH.2.00.1005070910490.31779@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1005070910490.31779@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BE35380.00B3:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/10 16:27, James Morris wrote:
> On Thu, 6 May 2010, Randy Dunlap wrote:
> 
>> On Thu, 06 May 2010 16:26:13 -0400 (EDT) Len Brown wrote:
>>
>>>> When CONFIG_PM is not set:
>>>>
>>>> drivers/built-in.o: In function `acpi_init':
>>>> bus.c:(.init.text+0x2d84): undefined reference to `pm_flags'
>>>> bus.c:(.init.text+0x2d91): undefined reference to `pm_flags'
>>>
>>> CONFIG_ACPI depends on CONFIG_PM,
>>> so acpi/bus.c should not be compiled for CONFIG_PM=n
>>>
>>> Hmm, is is somebody doing something strange, like "select ACPI"
>>> without guaranteeing that all of ACPI's dependencies are satisfied?
>>
>> Oh, thanks for the clue.
>>
>> That would be a patch that I commented on and was ignored,
>> but James Morris merged it anyway.  Now it should be dropped.
>>
>> http://lkml.org/lkml/2010/5/4/379
> 
> You weren't ignored.  Mimi responded and mentioned a subsequent patch, 
> after which, there was no further discussion.

OK.  But merging a known bad patch doesn't make much sense to me.

> I've reverted:
> 
> b89e66e1e396f7b5436af154e58209320cc08aed
> "TPM: ACPI/PNP dependency removal"
> 
> a674fa46c79ffa37995bd1c8e4daa2b3be5a95ae
> "ima: remove ACPI dependency"
> 

Thanks.

> 
> Note: any further ACPI-related changes here should have acks from 
> linux-acpi folk.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
