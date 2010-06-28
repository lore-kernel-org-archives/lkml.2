Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0F1UYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:24:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58617 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab0F1UYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:24:43 -0400
Message-ID: <4C2904D0.3000409@oracle.com>
Date: Mon, 28 Jun 2010 13:23:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jacob Pan <jacob.jun.pan@intel.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, chuck.lever@oracle.com
Subject: Re: problem: Re: [PATCH] input: fixup X86_MRST selects
References: <20100609133443.38f1f957.sfr@canb.auug.org.au> <201006101204.45709.dmitry.torokhov@gmail.com> <4C28F210.7030909@oracle.com> <201006281318.16377.dmitry.torokhov@gmail.com>
In-Reply-To: <201006281318.16377.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C2904DE.0160:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/10 13:18, Dmitry Torokhov wrote:
> On Monday, June 28, 2010 12:03:44 pm Randy Dunlap wrote:
>> On 06/10/10 12:04, Dmitry Torokhov wrote:
>>> On Wednesday, June 09, 2010 03:42:08 pm Randy Dunlap wrote:
>>>> On 06/09/10 15:40, Dmitry Torokhov wrote:
>>>>> On Wednesday, June 09, 2010 03:29:21 pm Randy Dunlap wrote:
>>>>>> +++ linux-next-20100609/drivers/input/keyboard/Kconfig
>>>>>> @@ -70,9 +70,10 @@ config KEYBOARD_ATARI
>>>>>>
>>>>>>  config KEYBOARD_ATKBD
>>>>>>  
>>>>>>         tristate "AT keyboard" if EMBEDDED || !X86
>>>>>>
>>>>>> +       depends on !X86 || (X86 && !X86_MRST)
>>>>>
>>>>> Should it be simply 'depends on !X86_MRST' and then we could kill
>>>>> '!X86_MRST' conditionals in selects?
>>>>
>>>> Duh, that sounds good, yes.
>>>
>>> Actually, I do not think this is a correct approach. While Moorestown
>>> does not have i8042 theoretically it is possible to add AT-style
>>> keyboard by other means (however unlikely it is) so we should not be
>>> disabling it.
>>>
>>> We should, however, disallow i8042 from being selected. Could you please
>>> tell me if the patch below works for you?
>>
>> Dmitry,
>>
>> This patch (in current mainline git) causes a problem when X86_MRST is
>> enabled. CONFIG_SERIO_I8042 is no longer enabled when X86_MRST is enabled,
>> and X86_MRST could be enabled when someone is trying to build a generic
>> kernel.
> 
> Randy,
> 
> Looking at arch/x86/kernel/mrst.c I am not sure if generic kernel will
> work well witbh X86_MRST set. However if we supposed to support Moorestown
> on generic images then, instead of playing with Kconfig, we need to adjust
> i8042_platform_init() to abort on Moorestown.

OK.  Until something else is done, you might want to revert this patch
and just live with the build errors (that caused me to send the original
patch).

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
