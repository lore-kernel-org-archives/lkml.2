Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030Ab1FTICw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:02:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38336 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1FTICm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:02:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rf7qnXmKBNUP6jWGHkQV9DBdJ8DdaPWdZk7n3CHmtE3n7D9xBJ4ypaSslrt/1CaeAc
         UaESHs85gADrqrI1Nm1G5sdpTUOJ6b94mFk0i7mKuo45Oj18EbxBuLzzeoAK6/73iqVq
         01UxZuD+0a2QFqPKBUiV7A8AboNw5a+rZeNJ4=
Message-ID: <4DFEFEC0.3040703@gmail.com>
Date: Mon, 20 Jun 2011 18:03:12 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Petr Tesarik <ptesarik@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
References: <201106171038.25988.ptesarik@suse.cz> <20110617093032.GA19235@elte.hu> <4DFE7FF9.9070406@gmail.com> <20110620073122.GA24716@elte.hu>
In-Reply-To: <20110620073122.GA24716@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/11 17:31, Ingo Molnar wrote:
> * Ryan Mallon <rmallon@gmail.com> wrote:
>
>> On 17/06/11 19:30, Ingo Molnar wrote:
>>> * Petr Tesarik<ptesarik@suse.cz>  wrote:
>>>
>>>> This patch series enhances /dev/mem, so that read and write is
>>>> possible at any address. The patchset includes actual
>>>> implementation for x86.
>>> This series lacks a description of why this is desired.
>>>
>>> My strong opinion is that it's not desired at all: /dev/mem never
>>> worked beyond 4G addresses so by today it has become largely obsolete
>>> and is on the way out really.
>>>
>>> I'm aware of these current /dev/mem uses:
>>>
>>>  - Xorg maps below 4G non-RAM addresses and the video BIOS
>>>
>>>  - It used to have some debugging role but these days kexec and kgdb
>>>    has largely taken over that role - partly due to the 4G limit.
>>>
>>>  - there's some really horrible out-of-tree drivers that do mmap()s
>>>    via /dev/mem, those should be fixed if they want to move beyond
>>>    4G: their char device should be mmap()able.
>> There are drivers where this makes sense. For example an FPGA 
>> device with a proprietary register layout on the memory bus can be 
>> done this way. [...]
> So you want us to help vendors screw users with insane, proprietary, 
> user-space drivers with sekrit binary blobs?
>
> Wow.
It's not about that. I mean proprietary in the sense that the register
layout is not based on some open spec and is customised to some
particular usage, not that it is evil, anti-GPL and "sekrit". I have
worked on embedded products which have custom FPGAs for _very_ dedicated
usage. The FPGA firmware is company IP and therefore not open (which is
nothing to do with Linux). The types of products I'm talking about are
often very niche market and dedicate use and therefore not a case of
vendors screwing over the general public. Writing the drivers in
user-space makes development easier; it's not an attempt to hide code
from the public. There is nothing to stop a /dev/mem userspace driver
from being open, just as there is nothing to stop a kernel driver for a
closed platform under Linux being "closed".

~Ryan

