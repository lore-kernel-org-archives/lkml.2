Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3ACW1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:27:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59290 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab3ACW1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:27:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: uapi __NR_syscalls for microblaze
Date: Thu, 3 Jan 2013 22:27:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-arch@vger.kernel.org
References: <CAHTX3d+bwTNEhzB78mqoz6prk0nw0U_-1YFR3Tje_-uQLyTMBQ@mail.gmail.com> <201301031601.00594.arnd@arndb.de> <CAHTX3dKra4vNsYPzQJbaU4jNmDT_rh-XViBD7yp3k7Ty0GsYog@mail.gmail.com>
In-Reply-To: <CAHTX3dKra4vNsYPzQJbaU4jNmDT_rh-XViBD7yp3k7Ty0GsYog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301032227.05553.arnd@arndb.de>
X-Provags-ID: V02:K0:tbnaYQWKmj4XPnPLgaRgct10jmVfuMhtKt/mM/84Dc7
 i0M4SktFLxnBehHttw/gEwkvNI55j/DMCgyLkNOhxmRO0hXm9d
 fb3z3I29KIwP3f7hqVt/2epKKkwCpNcvidhE9IrYrqbBYGXeXy
 XDgER9yfTiukD9Y9lcVPSHHPfpdTZ2mgPEf/iNAZkngDtkXDrl
 3diyhDwfO63VkhFRdQ8X1ROAmJjBXMJD4cSZJ3EHmqCCHOrzwy
 RER3MFy2lD0iO7NRKG65VUJKWXJ46DroTbNianVnkDZBt7c+vE
 gNExEvaGhK5o7pmVTEGhu3YMqVZK6OqW0teD1Cj17vf9EJuN5g
 mR5zoglCMPsJ7ytMBFaI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2013, Michal Simek wrote:
> 
> 2013/1/3 Arnd Bergmann <arnd@arndb.de>:
> > On Thursday 03 January 2013, Michal Simek wrote:
> >> 2013/1/3 David Howells <dhowells@redhat.com>:
> >> > Michal Simek <monstr@monstr.eu> wrote:
> >> >
> >> >> just want to check with you if __NR_syscalls is necessary for user space. I
> >> >> see that powerpc and arm have this macro in asm not in uapi like Microblaze.
> >> >> If is not needed by user space, I should move it to asm/unistd.h
> >> >
> >> > It isn't as far as I know...  I recommend putting your question on the
> >> > linux-arch mailing list.
> >>
> >> I have add linux-arch to CC.
> >
> > Right, I'm pretty sure it's not needed, but it has traditionally been
> > exported on a lot of platforms, so you can keep it in UAPI to be
> > on the safe side.
> 
> Isn't it better to be consistent across all architectures?

Yes, certainly.

> If it is wrong to exported and there is no reason to use it in userspace
> then all architecture should move it out of uapi.
> If there is any reason then it is should be in uapi.

I don't really care which way we do it, I think you can rightfully argue
either way. AFAICT x86 doesn't even define __NR_syscalls at all, so
it's clearly not part of the ABI.

	Arnd
