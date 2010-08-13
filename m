Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0HMWAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 18:00:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38614 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab0HMWAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 18:00:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gYORGu5PMcR5naLx4gAUBHtw30JLXskMvsdIA6e9KIA7UBliUJ+JXc2U0aAXTQib/c
         pYF/VC61hbRRfYTSuXRzPUU/Cl1rY0ZeugijZto0raIUpxTGoiasWplipAajUXU6/8e3
         TBSaaUOtZ2VaInejETcLCtxDJBk8R2zzyOGu8=
MIME-Version: 1.0
In-Reply-To: <4C65BF90.6000302@zytor.com>
References: <20100517212138.GA21629@elte.hu> <AANLkTikvJna6vnc73RVhVAJZ8mERJoFk=V6Nwq-3HHWz@mail.gmail.com>
 <4C65BF90.6000302@zytor.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 13 Aug 2010 17:59:41 -0400
Message-ID: <AANLkTikaHsbdM0XSaHH1iE9p8cYE=YFM3an=+xB-JKgZ@mail.gmail.com>
Subject: Re: [GIT PULL] core/hweight changes for v2.6.35
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 17:56, H. Peter Anvin wrote:
> On 08/13/2010 02:42 PM, Mike Frysinger wrote:
>> On Mon, May 17, 2010 at 17:21, Ingo Molnar wrote:
>>>  arch/alpha/include/asm/bitops.h            |   18 +++++----
>>>  arch/ia64/include/asm/bitops.h             |   11 +++--
>>>  arch/sparc/include/asm/bitops_64.h         |   11 +++--
>>>  arch/x86/include/asm/bitops.h              |    4 +-
>>>  include/asm-generic/bitops/arch_hweight.h  |   25 ++++++++++++
>>>  include/asm-generic/bitops/const_hweight.h |   42 ++++++++++++++++++++
>>>  include/asm-generic/bitops/hweight.h       |    8 +---
>>
>> did this miss Blackfin because the original patch was against the
>> 2.6.34 tree ?  just wondering why it now build fails ...
>>
>> doing a simple grep shows that the new "tile" arch may also be broken
>> as it uses "hweight32" ...
>>
>> considering __sw_hweightX only exist when the generic hweight is in
>> play, wouldnt it make sense to have
>> include/asm-generic/bitops/arch_hweight.h not always define things ?
>> then most arches can simply pull in
>> include/asm-generic/bitops/hweight.h without having to worry about the
>> random inner details of hweight cruft.
>>
>
> __sw_hweightX can exist even when generic hweight isn't in use per se,
> because the arch implementation can wrapper the software implementation.
>  This is the case on x86, for example -- most x86 CPUs don't have popcnt
> yet, so on those the x86 implementation end up calling the
> __sw_hweight*() implementations.

but those targets still define CONFIG_GENERIC_HWEIGHT right ?  so at
the least, we should be wrapping the prototypes in linux/bitops.h with
that ...
-mike
