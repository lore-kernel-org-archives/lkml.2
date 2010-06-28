Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab0F1VMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:12:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:29623 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab0F1VMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:12:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,499,1272870000"; 
   d="scan'208";a="812457391"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>,
       "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 28 Jun 2010 14:12:03 -0700
Subject: RE: problem: Re: [PATCH] input: fixup X86_MRST selects
Thread-Topic: problem: Re: [PATCH] input: fixup X86_MRST selects
Thread-Index: AcsW/9qfA/aD9qhGRjuz/2LakY8+vwABVhKg
Message-ID: <43F901BD926A4E43B106BF17856F0755EA339079@orsmsx508.amr.corp.intel.com>
References: <20100609133443.38f1f957.sfr@canb.auug.org.au>
 <201006101204.45709.dmitry.torokhov@gmail.com> <4C28F210.7030909@oracle.com>
 <201006281318.16377.dmitry.torokhov@gmail.com> <4C2904D0.3000409@oracle.com>
In-Reply-To: <4C2904D0.3000409@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
>Sent: Monday, June 28, 2010 1:24 PM
>To: Dmitry Torokhov
>Cc: Stephen Rothwell; Pan, Jacob jun; linux-next@vger.kernel.org; LKML;
>linux-input@vger.kernel.org; akpm; chuck.lever@oracle.com
>Subject: Re: problem: Re: [PATCH] input: fixup X86_MRST selects
>
>On 06/28/10 13:18, Dmitry Torokhov wrote:
>> On Monday, June 28, 2010 12:03:44 pm Randy Dunlap wrote:
>>> On 06/10/10 12:04, Dmitry Torokhov wrote:
>>>> On Wednesday, June 09, 2010 03:42:08 pm Randy Dunlap wrote:
>>>>> On 06/09/10 15:40, Dmitry Torokhov wrote:
>>>>>> On Wednesday, June 09, 2010 03:29:21 pm Randy Dunlap wrote:
>>>>>>> +++ linux-next-20100609/drivers/input/keyboard/Kconfig
>>>>>>> @@ -70,9 +70,10 @@ config KEYBOARD_ATARI
>>>>>>>
>>>>>>>  config KEYBOARD_ATKBD
>>>>>>>
>>>>>>>         tristate "AT keyboard" if EMBEDDED || !X86
>>>>>>>
>>>>>>> +       depends on !X86 || (X86 && !X86_MRST)
>>>>>>
>>>>>> Should it be simply 'depends on !X86_MRST' and then we could kill
>>>>>> '!X86_MRST' conditionals in selects?
>>>>>
>>>>> Duh, that sounds good, yes.
>>>>
>>>> Actually, I do not think this is a correct approach. While
>Moorestown
>>>> does not have i8042 theoretically it is possible to add AT-style
>>>> keyboard by other means (however unlikely it is) so we should not be
>>>> disabling it.
>>>>
>>>> We should, however, disallow i8042 from being selected. Could you
>please
>>>> tell me if the patch below works for you?
>>>
>>> Dmitry,
>>>
>>> This patch (in current mainline git) causes a problem when X86_MRST
>is
>>> enabled. CONFIG_SERIO_I8042 is no longer enabled when X86_MRST is
>enabled,
>>> and X86_MRST could be enabled when someone is trying to build a
>generic
>>> kernel.
>>
>> Randy,
>>
>> Looking at arch/x86/kernel/mrst.c I am not sure if generic kernel will
>> work well witbh X86_MRST set. However if we supposed to support
>Moorestown
>> on generic images then, instead of playing with Kconfig, we need to
>adjust
>> i8042_platform_init() to abort on Moorestown.
>
>OK.  Until something else is done, you might want to revert this patch
>and just live with the build errors (that caused me to send the original
>patch).
>
We do intend to maintain binary compatibility between generic kernel and Moorestown.
I guess the challenge is not having enumeration of i8042 pass to the driver. Do you
prefer abort i8042_platform_init() based on #define CONFIG_X86_MRST? It is no safe
to probe HW on Moorestown, unfortunately.

