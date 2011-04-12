Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab1DLPs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:48:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53195 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757640Ab1DLPsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:48:55 -0400
Message-ID: <4DA4743C.7070408@oracle.com>
Date: Tue, 12 Apr 2011 08:48:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ben Dooks <ben-linux@fluff.org>, Baruch Siach <baruch@tkos.co.il>,
        linux-i2c@vger.kernel.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next reresend] i2c: designware-pcidrv depends on PCI
References: <20110408083215.6b3b0bfe.randy.dunlap@oracle.com>	<BANLkTikX_rG+6Eg4owary1YRGRG8NzyrGQ@mail.gmail.com> <20110412114722.0f2e67d6@endymion.delvare>
In-Reply-To: <20110412114722.0f2e67d6@endymion.delvare>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DA47442.00B0:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/11 02:47, Jean Delvare wrote:
> Geert, Randy,
> 
> On Sat, 9 Apr 2011 13:34:49 +0200, Geert Uytterhoeven wrote:
>> On Fri, Apr 8, 2011 at 17:32, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> i2c-designware-pcidrv is a PCI driver and should depend on PCI.
>>> Fixes these build errors:
>>>
>>> drivers/i2c/busses/i2c-designware-pcidrv.c:256: error: implicit declaration of function 'pci_request_region'
>>> drivers/i2c/busses/i2c-designware-pcidrv.c:338: error: implicit declaration of function 'pci_release_region'
>>>
>>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>>> Cc: Baruch Siach <baruch@tkos.co.il>
>>> ---
>>>  drivers/i2c/busses/Kconfig |    1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> Does anybody merge i2c patches???
>>
>> Yes please, it's been there since Mar 17, reported several times, and probably
>> masking other build failures.
> 
> This bug only exists in linux-next, as the code in question wasn't
> merged in Linus's tree yet. It is drawn into linux-next from Ben
> Dooks's next-i2c branch:
>   http://git.fluff.org/gitweb?p=bjdooks/linux.git;a=shortlog;h=refs/heads/next-i2c
> 
> This is where it has to be fixed, so only Ben can do it. Ben, please?
> 
> Meanwhile, it should be possible to apply a hot fix to linux-next
> directly, Stephen does it pretty often. Stephen, could you please apply
> this fix temporarily until Ben wakes up and applies it to his tree?

Thanks, Jean.

>>> --- linux-next-20110316.orig/drivers/i2c/busses/Kconfig
>>> +++ linux-next-20110316/drivers/i2c/busses/Kconfig
>>> @@ -359,6 +359,7 @@ config I2C_DESIGNWARE_PLATFORM
>>>
>>>  config I2C_DESIGNWARE_PCI
>>>        tristate "Synopsys DesignWare PCI"
>>> +       depends on PCI
>>>        help
>>>          If you say yes to this option, support will be included for the
>>>          Synopsys DesignWare I2C adapter. Only master mode is supported.
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
