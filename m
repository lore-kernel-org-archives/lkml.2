Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab0H3Fop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 01:44:45 -0400
Received: from freeflow.nu ([178.79.134.28]:49307 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab0H3Fop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 01:44:45 -0400
Message-ID: <4C7B454A.7050101@kernel.org>
Date: Mon, 30 Aug 2010 08:44:42 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] x86: Remove unnecessary ifdefs from i387 code.
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>	<1283011478-27237-11-git-send-email-brgerst@gmail.com>	<AANLkTinnhht86aKkmHKypmgmThJP8a1rGEXFkwyW7dc3@mail.gmail.com> <AANLkTik7Gv3xoZphR0VRkHdr3Z1tvO484S-zkYncC2K7@mail.gmail.com>
In-Reply-To: <AANLkTik7Gv3xoZphR0VRkHdr3Z1tvO484S-zkYncC2K7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Brian,

On 8/30/10 2:38 AM, Brian Gerst wrote:
> On Sun, Aug 29, 2010 at 3:00 PM, Pekka Enberg<penberg@kernel.org>  wrote:
>> On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst<brgerst@gmail.com>  wrote:
>>> Remove ifdefs for code that the compiler can optimize away on 64-bit.
>>>
>>> Signed-off-by: Brian Gerst<brgerst@gmail.com>
>>> @@ -74,10 +74,8 @@ static void __cpuinit init_thread_xstate(void)
>>>
>>>         if (cpu_has_fxsr)
>>>                 xstate_size = sizeof(struct i387_fxsave_struct);
>>> -#ifdef CONFIG_X86_32
>>>         else
>>>                 xstate_size = sizeof(struct i387_fsave_struct);
>>> -#endif
>>>   }
>> I guess this is OK but keep in mind that cpu_has_fsxr is _not_
>> optimized by the compiler on 64-bit so the change probably increases
>> kernel text by few bytes.
> FXSR is a required feature on 64-bit, therefore cpu_has_fxsr is always true.
Yes, I realize that but it will still read boot_cpu_data at runtime, no?

             Pekka
