Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2ISK6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 06:58:08 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:38645 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab2ISK6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 06:58:03 -0400
MIME-Version: 1.0
In-Reply-To: <201209181813.06124.arnd@arndb.de>
References: <1347987727-13739-1-git-send-email-catalin.marinas@arm.com> <201209181813.06124.arnd@arndb.de>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 19 Sep 2012 11:57:42 +0100
X-Google-Sender-Auth: IDlldpP-r4J-4uE0_m3vzlGE5fY
Message-ID: <CAHkRjk581OE1ugsYKB-M8tZP5sYEsxLYkFPsfneLpnLKm3q9-A@mail.gmail.com>
Subject: Re: [PATCH] compat: fs: Generic compat_sys_sendfile implementation
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 September 2012 19:13, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 18 September 2012, Catalin Marinas wrote:
>> @@ -229,7 +229,7 @@ COMPAT_SYS_SPU(sched_setaffinity)
>>  COMPAT_SYS_SPU(sched_getaffinity)
>>  SYSCALL(ni_syscall)
>>  SYSCALL(ni_syscall)
>> -SYS32ONLY(sendfile64)
>> +SYS32ONLY(sendfile64_wrapper)
>>  COMPAT_SYS_SPU(io_setup)
>>  SYSCALL_SPU(io_destroy)
>>  COMPAT_SYS_SPU(io_getevents)
>
> I believe this will break native ppc32 builds because there is
> no sys_sendfile64_wrapper function. You probably have to use
>
> SYSX(sys_ni_syscall, compat_sys_sendfile64_wrapper, sys_sendfile64)

OK, I only built ppc64. I made this change and I'll re-post the patch.

What I've noticed on ppc64 is that __NR_sendfile is routed to
sys_sendfile64(). I'm changing this to sys_sendfile() as I don't see
why we need to carry the two almost identical functions around:

-SYSX_SPU(sys_sendfile64,compat_sys_sendfile,sys_sendfile)
+SYSX_SPU(sys_sendfile,compat_sys_sendfile_wrapper,sys_sendfile)

-- 
Catalin
