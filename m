Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715Ab0I1Ikb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:40:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61278 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511Ab0I1Ika (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:40:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linasvepstas@gmail.com
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
Date: Tue, 28 Sep 2010 10:40:09 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com>
In-Reply-To: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009281040.09728.arnd@arndb.de>
X-Provags-ID: V02:K0:eAv5GsRmfFPSf8SvZqj3eaU/D2xaMnet5YtDSj+n0vB
 lDVW4t/IALnLU+P+DV+3GzEP9DU8GhM9Z1Lvnbgulsr7/eU8JR
 2s2DnrN8QzahXu9Icd8wv2QCQvX17EtrhbMJEbWzyfjvU3gs+t
 09OmYRb6d4QnVUPY/ZE82FXAP3808E3mO30x/uSDW1ch3aG+ne
 YLfFDpTK5u4BGX4l5l71Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 September 2010, Linas Vepstas wrote:
> I'm trying to figure out the status of glibc w.r.t the latest linux
> unistd syscall interface, specifically, the status of the NR_ipc
> syscall.   Currently, I see the following:
> 
> -- Circa June 2009, Arnd Bergman introduced asm-generic/unistd.h
> (into the linux kernel) to provide a generic interface to system
> calls. It does *not* define NR_ipc, and instead provides
> NR_msgsnd, msgrcv, msgget, msgctl etc. syscalls.
> 
> -- Current glibc (2.12.1, as well as the current eglibc) does
> not appear to use these new calls anywhere. Instead, glibc
> has generic (non-arch-specific) implementations of msgsnd
> etc.  that use the old NR_ipc interface (see, e.g.
> sysdeps/unix/sysv/linux/msgsnd.c, semget.c, shmdt.c, msgrcv.c,
> shmget.c, etc.)
> 
> Is someone working on patches to get glibc to use the new
> syscall interfaces (for IPC)?  Am I missing something? Seems like
> any arch wishing to use asm-generic/unistd.h and get glibc working
> gets to break new ground, here ... right?

Chris Metcalf is using the generic unistd.h file on the tile architecture
and has a glibc port that should be easily portable to all future
architectures. There are a few of them getting ready to be merged
now (c6x, lm32, nios2, and some people have contacted me privately
for architectures I cannot name).

I expect that all of them will just use the same syscall ABI and glibc
port.

	Arnd
