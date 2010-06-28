Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0F1TEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:04:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49202 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab0F1TEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:04:43 -0400
Message-ID: <4C28F210.7030909@oracle.com>
Date: Mon, 28 Jun 2010 12:03:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jacob Pan <jacob.jun.pan@intel.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, chuck.lever@oracle.com
Subject: problem: Re: [PATCH] input: fixup X86_MRST selects
References: <20100609133443.38f1f957.sfr@canb.auug.org.au> <201006091540.43122.dmitry.torokhov@gmail.com> <4C1018C0.6020304@oracle.com> <201006101204.45709.dmitry.torokhov@gmail.com>
In-Reply-To: <201006101204.45709.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C28F217.014A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/10 12:04, Dmitry Torokhov wrote:
> On Wednesday, June 09, 2010 03:42:08 pm Randy Dunlap wrote:
>> On 06/09/10 15:40, Dmitry Torokhov wrote:
>>> On Wednesday, June 09, 2010 03:29:21 pm Randy Dunlap wrote:
>>>> +++ linux-next-20100609/drivers/input/keyboard/Kconfig
>>>> @@ -70,9 +70,10 @@ config KEYBOARD_ATARI
>>>>  
>>>>  config KEYBOARD_ATKBD
>>>>         tristate "AT keyboard" if EMBEDDED || !X86
>>>> +       depends on !X86 || (X86 && !X86_MRST)
>>>
>>> Should it be simply 'depends on !X86_MRST' and then we could kill
>>> '!X86_MRST' conditionals in selects?
>>
>> Duh, that sounds good, yes.
> 
> Actually, I do not think this is a correct approach. While Moorestown does
> not have i8042 theoretically it is possible to add AT-style keyboard by
> other means (however unlikely it is) so we should not be disabling it.
> 
> We should, however, disallow i8042 from being selected. Could you please
> tell me if the patch below works for you?

Dmitry,

This patch (in current mainline git) causes a problem when X86_MRST is enabled.
CONFIG_SERIO_I8042 is no longer enabled when X86_MRST is enabled,
and X86_MRST could be enabled when someone is trying to build a generic kernel.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
