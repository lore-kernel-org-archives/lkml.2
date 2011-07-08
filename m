Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1GHVbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:31:43 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17305 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab1GHVbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:31:42 -0400
Message-ID: <4E17772B.3060906@oracle.com>
Date: Fri, 08 Jul 2011 14:31:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: J Freyensee <james_p_freyensee@linux.intel.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: Re: linux-next: Tree for July 4 (misc/pti)
References: <20110704170952.1024e89b.sfr@canb.auug.org.au> <20110704134541.9adfd4f1.randy.dunlap@oracle.com> <20110707081441.a4a64e59.randy.dunlap@oracle.com> <4E15DF07.4010507@linux.intel.com> <20110707093202.a831fce8.randy.dunlap@oracle.com> <CAMuHMdV_kgfM2bEmHw8u8c3js7EK7BLmd2yzoip3rjOPAWUQ2Q@mail.gmail.com> <4E17757C.5030909@linux.intel.com>
In-Reply-To: <4E17757C.5030909@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E177735.0094:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/11 14:24, J Freyensee wrote:
> On 07/08/2011 01:07 PM, Geert Uytterhoeven wrote:
>> On Thu, Jul 7, 2011 at 18:32, Randy Dunlap<randy.dunlap@oracle.com> 
>> wrote:
>>> On Thu, 07 Jul 2011 09:29:59 -0700 J Freyensee wrote:
>>>> On 07/07/2011 08:14 AM, Randy Dunlap wrote:
>>>>> On Mon, 4 Jul 2011 13:45:41 -0700 Randy Dunlap wrote:
>>>>>> On Mon, 4 Jul 2011 17:09:52 +1000 Stephen Rothwell wrote:
>>>>>>> Changes since 20110701:
>>>>>> when CONFIG_PCI is not enabled:
>>>>>>
>>>>>> drivers/misc/pti.c:410: error: implicit declaration of function
>>>>>> 'pci_release_region'
>>>>>> drivers/misc/pti.c:859: error: implicit declaration of function
>>>>>> 'pci_request_region'
>>>>>>
>>>>>> Stubs for these 2 functions could be added to include/linux/pci.h,
>>>>>> but it would
>>>>>> make more sense to me just to make the driver depend on PCI since
>>>>>> it seems to rely
>>>>>> on so many PCI functions.  or are the PCI pieces optional?
>>>>> ping.  still a problem in linux-next 20110706.
>>>> Thanks for the ping.
>>>>
>>>> Is there something you need me to do or look at?
>>>>
>>>> For Intel-Atom architectures, the MIPI PTI module does sit on the PCI
>>>> bus.  It's very much dependent upon the PCI bus for working
>>>> functionality and it's not optional.  So yes, it makes sense for the
>>>> driver to depend on PCI to be there and if PCI is not enabled on the
>>>> system, don't build the pti driver.
>>>>
>>>> Maybe it's a Kconfig dependency?
>>> Yes, please send/merge a patch that adds
>>>         depends on PCI
>>> to "config INTEL_MID_PCI".
>> http://kisskb.ellerman.id.au/kisskb/buildresult/4292241/:
> I can't access that http site (with or without the ':').

Works for me (without the trailing colon).

>> drivers/misc/pti.c:249: error: implicit declaration of function 'kmalloc'
>> drivers/misc/pti.c:258: error: implicit declaration of function 'kfree'
>> drivers/misc/pti.c:657: error: implicit declaration of function
>> 'copy_from_user'
>> drivers/misc/pti.c:848: error: implicit declaration of function 'kzalloc'
>>
>> Probably missing
> 
>>
>> #include<linux/slab.h>
>> #include<linux/uaccess.h>
> 
> I can send a patch to add these two includes.  It didn't have previous
> troubles compiling, so maybe one of the other includes used to be
> including these?


That URL (above) says:
Compiler:  	m68k (m68k-linux-gcc (GCC) 4.4.0)

and different $ARCH-es do different #inclusions.

Anyway, the interfaces are used so the source file should #include
the header files.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
