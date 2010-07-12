Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0GLW53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:57:29 -0400
Received: from claw.goop.org ([74.207.240.146]:46090 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968Ab0GLW50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:57:26 -0400
Message-ID: <4C3B9DD4.1040808@goop.org>
Date: Mon, 12 Jul 2010 15:57:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Yinghai Lu <yinghai.lu@oracle.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Setup early console as early as possible
References: <4C3A3B27.7020009@oracle.com> <4C3AD94C.7070807@cs.helsinki.fi> <4C3B38F7.1050400@zytor.com> <20100712174420.GC5687@lenovo> <4C3B5A4A.4070107@zytor.com> <4C3B5AC9.3070604@oracle.com>
In-Reply-To: <4C3B5AC9.3070604@oracle.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 11:11 AM, Yinghai Lu wrote:
> On 07/12/2010 11:09 AM, H. Peter Anvin wrote:
>   
>> On 07/12/2010 10:44 AM, Cyrill Gorcunov wrote:
>>     
>>> Peter, while reviewing this patch I found another nit in
>>> context of early_param usage, so the patch is below. It's
>>> completely trivial. Actually I thought I've already fixed
>>> all early_param cases long ago but this one somehow sneaked ;)
>>>
>>> Anyway, Yinghai, Peter,
>>>
>>> I'm not sure but can't we use some boot_param "pad" field for
>>> "being copied" flag instead of new variable? There is a case
>>> when boot_param is used as __initdata and I'm not sure we clear
>>> this section explicitly.
>>>
>>>       
>> Actually, even better would be to simply use boot_params.hdr.version,
>> which will never be zero.
>>     
> Jeremy,
>
> any reason that xen cat not use x86_64_start_kernel directly?
>   

As I remember it, I split x86_64_start_kernel into two pieces, one
containing the bits that were awkward with Xen.  I don't remember which
were the problematic parts, but it all looks pretty tricky.  Specifically:

    * Xen will pre-clear the bss, so that's not necessary
    * we don't go via head, so cleanup_highmap isn't either
    * PV domains don't have an IDT available to them, or any of their
      associated structures

So the whole thing looks at best reundant, and at worst has the
potential for causing subtle damage.

Why do you ask?  Does it relate to the early console stuff, or are you
just asking because you're looking at it?

    J
