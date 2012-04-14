Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab2DNI3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 04:29:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2DNI30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 04:29:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lubos Lunak <l.lunak@suse.cz>
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
Date: Sat, 14 Apr 2012 08:28:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <201204132124.21294.l.lunak@suse.cz> <CA+55aFxCrVtwCd9bjHLt82Uwisp8OtKP9c+raPYMqCTXqVfxGw@mail.gmail.com> <201204132346.57019.l.lunak@suse.cz>
In-Reply-To: <201204132346.57019.l.lunak@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204140828.49048.arnd@arndb.de>
X-Provags-ID: V02:K0:id/pWn3b8cVgvU3hac5GEJMJKgweSdTIWG/wv5rPZsX
 LouVy4Z29+lAtJK5WVun7VNVulNhtTd3p/VM4t7mMgtgVzetxW
 dYYCIldsaxXmLOPuZUHoR5+LNC6cFMY1ujayjuuu+IdFeqHknD
 L6tzpk5MnA7y7x9jaSpBSgZUPuU5te1yDV516QHC9y6s2e229p
 e+63lbrpti1khlG2Nx9Rl1QqP6kyQIEuaZEX49lZRXs3ZhHMhK
 jYJHQmZTDnl3zzFOaqec1SHyIYsOWsSdaq/f2y3gw0tllaPluZ
 pJ20wU9l5LA31RrzLj2rUh764QSatcXPVfG4lx/rbsGvkcBvNJ
 VfmYBwhuHxypWL0PcaN8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 April 2012, Lubos Lunak wrote:
>  If that were the case, one of the earlier versions of the patch would have 
> been correct then, but as Arnd has pointed out, user applications do include 
> the header. It's even as simple as:
> 
> #include <signal.h>
> 
> ( -> bits/sigcontext.h -> asm/sigcontext.h -> linux/types.h -> 
> linux/posix_types.h -> linux/stddef.h ).
> 

I knew there must have been something wrong with my thinking and I
clearly missed the posix_types.h reference. I accidentally did
'git grep linux/stddef.h obj/usr/include', instead of 'grep -r'.

I've tried to be more thorough this time, and I think that nothing
stops us from removing the linux/stddef.h include from the exported
version of posix_types.h, but we should probably make sure that we
still include linux/compiler.h, because a lot of stuff that includes
linux/posix_types.h expects that. Alternatively, we can just move the
NULL definition inside of #ifdef __KERNEL__.

	Arnd
