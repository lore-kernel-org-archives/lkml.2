Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3ADLlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 06:41:46 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35534 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3ADLlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 06:41:40 -0500
MIME-Version: 1.0
In-Reply-To: <14685.1357230917@warthog.procyon.org.uk>
References: <CAHTX3d+P_UQK8nPfN8BKLdTkVY2VMKhty1rkCKbfHCrQBa+Nyw@mail.gmail.com>
	<14685.1357230917@warthog.procyon.org.uk>
Date: Fri, 4 Jan 2013 12:41:39 +0100
Message-ID: <CAHTX3d+BhEaTW8=0=bKQZSVQbfHtAf_fa9WDe2gsCVEnA0uxkw@mail.gmail.com>
Subject: Re: Add #includes needed to permit the removal of asm/system.h - sha1 96f951edb1f1bdbbc99b0cd458f9808bb83d58ae
From: Michal Simek <monstr@monstr.eu>
To: David Howells <dhowells@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/3 David Howells <dhowells@redhat.com>:
> Michal Simek <monstr@monstr.eu> wrote:
>
>> It is because microblaze uses cmpxchg_local which is defined
>> asm-generic/atomic.h file.
>> Arnds patch has added it to atomic.h
>> asm-generic: add generic atomic.h and io.h
>> (sha1: 3f7e212df82ca0459d44c91d9e019efd1b5f936c)
>>
>> What about to move cmpxchg_local and cmpxchg64_local from atomic.h to
>> cmpxchg-local.h?
>
> Hmmm...  cmpxchg_local() should be obtained through asm/cmpxchg.h, not
> asm/atomic.h.  See:
>
>         grep -r define\\s*cmpxchg_local arch

But it is also here which Microblaze uses.

[linux-2.6.x]$ grep -r define\\s*cmpxchg_local include/asm-generic/
include/asm-generic/atomic.h:#define cmpxchg_local(ptr, o, n)				  	       \

(not checked on the latest but probably it is the same)
m68k, arm contains the same copy for one case
c6x, unicore, cris, blackfin, h8300, sparc32

Probably make sense to move these two macros
cmpxchg64_local and cmpxchg_local to asm-generic/cmpxchg-local.h
with #ifndef cmpxchg_local ...etc. and remove it from architectures above.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian
