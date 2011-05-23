Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1EWPQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:16:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42498 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab1EWPQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:16:22 -0400
Message-ID: <4DDA7A24.6050909@oracle.com>
Date: Mon, 23 May 2011 08:15:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>
Subject: Re: [PATCH -next] firmware: fix GOOGLE_SMI kconfig dependency warning
References: <20110520165507.cba539d5.sfr@canb.auug.org.au>	<20110522173802.c0766c64.randy.dunlap@oracle.com> <BANLkTi=T4JsDZ7EX18AHcwG8nd50FzHGtg@mail.gmail.com>
In-Reply-To: <BANLkTi=T4JsDZ7EX18AHcwG8nd50FzHGtg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DDA7A40.0120:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/11 22:39, Mike Waychison wrote:
> 
> On May 22, 2011 5:38 PM, "Randy Dunlap" <randy.dunlap@oracle.com
> <mailto:randy.dunlap@oracle.com>> wrote:
>>
>> From: Randy Dunlap <randy.dunlap@oracle.com
> <mailto:randy.dunlap@oracle.com>>
>>
>> Is it meaningful/useful to enable EFI_VARS but not EFI?
>> That's what GOOGLE_SMI does.  Make it enable EFI also.
>>
>> Fixes this kconfig dependency warning:
>>
>> warning: (GOOGLE_SMI) selects EFI_VARS which has unmet direct
> dependencies (EFI)
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com
> <mailto:randy.dunlap@oracle.com>>
>> Cc: Mike Waychison <mikew@google.com <mailto:mikew@google.com>>
> 
> Acked.
> 
> Is this a new warning?  I haven't seen it before which is weird because
> we don't use efi boot.

It's not new for 20110520, but I don't know when it began.

>> ---
>>  drivers/firmware/google/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> --- linux-next-20110520.orig/drivers/firmware/google/Kconfig
>> +++ linux-next-20110520/drivers/firmware/google/Kconfig
>> @@ -13,6 +13,7 @@ menu "Google Firmware Drivers"
>>  config GOOGLE_SMI
>>        tristate "SMI interface for Google platforms"
>>        depends on ACPI && DMI
>> +       select EFI
>>        select EFI_VARS
>>        help
>>          Say Y here if you want to enable SMI callbacks for Google
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
