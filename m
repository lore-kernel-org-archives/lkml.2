Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab1KJBLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 20:11:14 -0500
Received: from host86-160-104-197.range86-160.btcentralplus.com ([86.160.104.197]:51863
	"EHLO oak.selfip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1KJBLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 20:11:13 -0500
Message-ID: <4EBB24AB.3090307@oak.selfip.net>
Date: Thu, 10 Nov 2011 01:11:07 +0000
From: Dave Haywood <tla@oak.selfip.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111103 Thunderbird/8.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Build warning: kernel/trace/trace.c (v3.2-rc1-90-g19e0baf)
References: <4EBA3E3E.9060402@oak.selfip.net> <20111109113303.GA18508@gere.osrc.amd.com>
In-Reply-To: <20111109113303.GA18508@gere.osrc.amd.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2011 11:33, Borislav Petkov wrote:

> On Wed, Nov 09, 2011 at 08:47:58AM +0000, Dave Haywood wrote:
>> Hi,
>>
>>   Noticed this new warning in the build of kernel v3.2-rc1-90-g19e0baf:
>>
>>   CC      kernel/trace/trace.o
>> kernel/trace/trace.c: In function 'tracing_mark_write':
>> kernel/trace/trace.c:3644:8: warning: 'page2' may be used uninitialized in this function
> That has to be gcc 4.5.x something. 4.6 is smarter in that aspect:
Correct, version is:

$ gcc --version

gcc (Gentoo Hardened 4.5.3-r1 p1.0, pie-0.4.5) 4.5.3

Copyright (C) 2010 Free Software Foundation, Inc.

This is free software; see the source for copying conditions.  There is NO

warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

>
> $ make CC=gcc-4.6 kernel/trace/trace.o
>   CHK     include/linux/version.h
>   UPD     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   UPD     include/generated/utsrelease.h
>   CC      kernel/bounds.s
>
>   ...
>
>   HOSTLD  scripts/mod/modpost
>   CC      kernel/trace/trace.o
> $ make CC=gcc-4.5 kernel/trace/trace.o
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CC      kernel/bounds.s
>
>   ...
>
>   HOSTLD  scripts/mod/modpost
>   CC      kernel/trace/trace.o
> kernel/trace/trace.c: In function ‘tracing_mark_write’:
> kernel/trace/trace.c:3644:8: warning: ‘page2’ may be used uninitialized in this function
>
> HTH
>

