Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab2J0VIn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:08:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55730 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2J0VIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:08:41 -0400
Message-ID: <508C4D56.5030801@zankel.net>
Date: Sat, 27 Oct 2012 14:08:38 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 60/85] xtensa: add missing system calls to the syscall table
References: <20121026000031.107227138@linuxfoundation.org> <20121026000037.158689095@linuxfoundation.org> <1351362392.4834.17.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1351362392.4834.17.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,


On 10/27/2012 11:26 AM, Ben Hutchings wrote:
> On Thu, 2012-10-25 at 17:06 -0700, Greg Kroah-Hartman wrote:
> [...]
>>  #define __NR_available287			287
>> -__SYSCALL(287, sys_faccessat, 0)
>> +__SYSCALL(287, sys_ni_syscall, 0)
> [...]
>
> Why was this one un-plumbed rather than properly numbered (#define
> __NR_faccessat)?
I can only speculate, that this was probably a copy/paste error that has been there for a long time. __NR_faccessat is (and was) defined as number 301. Given that 287 was never defined, it's save to
fix the table entry and set it to sys_ni_syscall.

unistd.h:
[...]
#define __NR_faccessat                          301
__SYSCALL(301, sys_faccessat, 4)
[...]

Thanks,
-Chris

