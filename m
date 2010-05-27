Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab0E0OwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:52:23 -0400
Received: from mailgw.tensilica.com ([65.119.96.134]:52441 "EHLO
	mailgw.tensilica.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab0E0OwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:52:21 -0400
From: Marc Gauthier <marc@tensilica.com>
To: Arnd Bergmann <arnd@arndb.de>, Chris Metcalf <cmetcalf@tilera.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Date: Thu, 27 May 2010 07:52:03 -0700
Subject: RE: [PATCH] arch/tile: new multi-core architecture for Linux
Thread-Topic: [PATCH] arch/tile: new multi-core architecture for Linux
Thread-Index: Acr9ptK5VDntjl3URLadggzvR0MwxAABAtDg
Message-ID: <522C1DF17AF50042AD8AE87F7887BD3D01637144CA@exch.hq.tensilica.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
 <201005271041.30519.arnd@arndb.de> <4BFE73DF.5090107@tilera.com>
 <201005271611.47963.arnd@arndb.de>
In-Reply-To: <201005271611.47963.arnd@arndb.de>
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

linux-arch-owner@vger.kernel.org wrote:
> On Thursday 27 May 2010, Chris Metcalf wrote:
>> On 5/27/2010 4:41 AM, Arnd Bergmann wrote:
>>>> Hmm, I didn't know about that.  Any information would be
>>>> appreciated.  I guess you could synthesize something that looked
>>>> like a signal purely in user-space?  But how would debuggers trap
>>>> it?  I'm not sure how it would work without a system call.
>>>
>>> I think the C99 standard allows you to not implement SIGFPE at all
>>> but instead rely on applications doing fetestexcept() etc.
>>
>> We use this not for the floating-point operations, but for integer
>> divide-by-zero.  In principle we could use it for floating-point too,
>> but we currently don't, since generally folks don't expect it there.
>
> Ah, I see. That probably makes a lot of sense to present as a signal
> the way you do.

FWIW, this can also be done using some recognizable illegal
instruction sequence, if the architecture reserves some opcodes
as always illegal.  This makes the division routine (typically part
of libgcc) more independent of OS, which has some merit.
The kernel illegal instruction handler needs to recognize this
sequence and turn it into a SIGFPE instead of SIGILL.

The Xtensa architecture libgcc added this recently, but we haven't
yet added the SIGILL=>SIGFPE code to the kernel.

-Marc
